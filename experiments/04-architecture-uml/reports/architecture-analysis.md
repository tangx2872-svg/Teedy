# 实验四：Teedy 软件架构与 UML 分析报告

## 一、项目模块结构

Teedy 是一个基于 Maven 的多模块项目，根 POM 为 `docs-parent`（packaging=pom），管理三个子模块：

| 模块 | 类型 | 职责 |
| --- | --- | --- |
| `docs-core` | jar | 业务核心：JPA 实体、DAO 层、Service 层、事件监听、工具类（索引、PDF、认证、格式化） |
| `docs-web-common` | jar | 共享基础设施：REST 异常、安全 Principal（IPrincipal/UserPrincipal/AnonymousPrincipal）、过滤器（SecurityFilter/CorsFilter/JwtBasedSecurityFilter 等）、REST 工具（RestUtil/AclUtil/ValidationUtil） |
| `docs-web` | war | Web 层：REST 资源层（JAX-RS）+ AngularJS 前端，经 Jetty 打包部署 |

**模块依赖关系**：

```
docs-web ──依赖──> docs-core
docs-web ──依赖──> docs-web-common
docs-core ──依赖──> docs-web-common
```

> 注：目录中另有 `docs-android/`、`docs-importer/`，但未纳入根 POM 的 `<modules>`，属于独立/历史遗留模块，不参与主构建。

## 二、Java 包结构（分层）

### docs-core（`com.sismics.docs.core`）

| 包 | 职责 |
| --- | --- |
| `dao` | 数据访问对象（DocumentDao、FileDao、TagDao、AclDao、RouteDao 等 22 个 DAO） |
| `dao.criteria` | 查询条件对象（DocumentCriteria 等） |
| `dao.dto` | 数据传输对象 |
| `model` / `model.jpa` | JPA 实体（Document、File、Tag、User、Acl、Route 等 27 个实体） |
| `model.context` | 线程本地上下文（ThreadLocalContext，提供 EntityManager） |
| `service` | 业务服务（FileService、FileSizeService、InboxService） |
| `event` / `listener` | 事件与监听器（含异步监听 listener.async） |
| `util` | 工具类（authentication 认证、indexing 索引、pdf、format 格式化、jpa、action） |
| `constant` | 常量定义 |

### docs-web（`com.sismics.docs.rest`）

| 包 | 职责 |
| --- | --- |
| `rest.resource` | JAX-RS 资源类（DocumentResource、FileResource、TagResource、AclResource、RouteResource 等 17 个 Resource，均继承 BaseResource） |
| `rest.constant` | REST 常量 |
| `rest.util` | REST 工具 |

### 前端（docs-web/src/main/webapp，AngularJS）

```
src/app/docs/
├── controller/   （document / tag / usergroup / settings 四类控制器）
├── directive/    （自定义指令）
├── filter/       （过滤器）
└── service/      （UserService 等服务）
```

## 三、核心类及类关系

### 1. REST 资源层（继承关系）

- 抽象基类 `BaseResource`：持有 `@Context HttpServletRequest`、`IPrincipal principal`，提供 `authenticate()`、`checkBaseFunction()` 等鉴权方法。
- 具体资源类 `DocumentResource`、`FileResource`、`TagResource`、`AclResource`、`RouteResource` 等 **继承** `BaseResource`。

### 2. 实体层（实现关系）

- 接口 `Loggable`：声明 `toMessage()`，用于审计日志。
- 实体 `Document`、`File`、`User` 等 **实现** `Loggable`。

### 3. 实体间关联（关键设计特点）

Teedy 的 JPA 实体**不使用 `@ManyToOne`/`@OneToMany` 等关系注解**，而是用**字符串外键字段**手动关联：

- `Document.userId` → 关联 `User`
- `Document.fileId` → 关联 `File`
- `Document` ↔ `Tag` 经关联表 `DocumentTag` 实现多对多

这种设计弱化了 ORM 关系，由 DAO 层手动 join 查询，关系更显式、可控。

### 4. DAO 层（依赖关系）

- 各 DAO（DocumentDao、FileDao、TagDao 等）是普通类，**无继承关系**。
- 通过 `ThreadLocalContext.get().getEntityManager()` 获取 `EntityManager`（线程本地上下文模式，而非 Spring 依赖注入）。
- REST 资源类**依赖** DAO：如 `DocumentResource → DocumentDao`、`FileResource → FileDao/FileService`。

## 四、主要模块交互过程

以「文档上传」为例（对应时序图）：

1. 用户在 AngularJS 前端选择文件，发起 `POST /file`（multipart）。
2. 请求经 `SecurityFilter` 拦截，校验 Token / Principal 后放行。
3. `FileResource` 调用 `FileService.processFile()` 处理文件。
4. `FileService` 调 `FileDao.create()` 写入 `T_FILE`，返回 `fileId`。
5. `FileResource` 再调 `DocumentDao.create()` 写入 `T_DOCUMENT`（关联 fileId），返回 `documentId`。
6. 前端收到 `200 {id, fileId}`，显示上传成功。

分层调用链：**AngularJS 前端 → REST 资源层（BaseResource 子类）→ Service → DAO → JPA 实体 → 数据库**。

## 五、UML 图清单

| 图 | 文件（源 / 渲染） | 说明 |
| --- | --- | --- |
| 模块依赖图 | `diagrams/01-module-dependencies.puml` → `screenshots/module-dependencies.png` | Maven 多模块结构及依赖 |
| 分层架构图 | `diagrams/02-layered-architecture.puml` → `screenshots/layered-architecture.png` | 前端/REST/业务/持久四层 |
| 核心类图 | `diagrams/03-core-class-diagram.puml` → `screenshots/core-class-diagram.png` | REST→DAO→实体及继承/依赖关系 |
| 文档上传时序图 | `diagrams/04-document-upload-sequence.puml` → `screenshots/document-upload-sequence.png` | 上传请求完整链路 |

> 同时保存了可编辑的 PlantUML 源文件（`.puml`）和渲染结果（`.png`），满足教材「尽量同时保存可编辑源文件和渲染结果」的要求。

## 六、架构特点总结

1. **前后端分离**：AngularJS SPA 前端 + JAX-RS 后端，通过 JSON 交互。
2. **分层清晰**：REST → Service → DAO → Entity → DB 五层，职责单一。
3. **多模块 Maven 工程**：core（业务）/ web-common（共享）/ web（Web）三模块，依赖单向。
4. **线程本地 EntityManager**：DAO 通过 ThreadLocalContext 获取 EntityManager，规避事务边界问题。
5. **字符串外键而非 ORM 关系**：实体间用字符串外键 + 关联表，关系显式、查询可控。
6. **安全过滤器链**：SecurityFilter/CorsFilter/JwtBasedSecurityFilter 等统一处理认证授权。
