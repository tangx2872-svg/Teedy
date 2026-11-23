# 环境配置记录（ENVIRONMENT）

> 记录开发环境版本、依赖与启动命令。跨会话恢复时以本文件为准。

## 基础环境

| 项目 | 版本 | 备注 |
| --- | --- | --- |
| 操作系统 | Windows 11 | 宿主（非 WSL） |
| 仓库路径 | `D:\Research\Teedy` | 本地工作副本 |
| Git | 2.55.0.windows.3 | |
| Java (JDK) | OpenJDK 11.0.32.1 (Temurin) | Teedy 依赖 JDK 11 |
| Node.js | v22.22.2 | 前端构建 |
| npm | 10.9.7 | |
| Maven | 3.9.9 | 本轮重新安装，见下方安装位置 |
| 远程仓库 | `https://github.com/tangx2872-svg/Teedy.git` | HTTPS（已从 SSH 切换） |

## Maven 安装信息

- **安装位置**：`D:\tools\apache-maven-3.9.9`
- **MAVEN_HOME**：`D:\tools\apache-maven-3.9.9`
- **PATH**：需包含 `D:\tools\apache-maven-3.9.9\bin`
- **本地仓库**：`C:\Users\Lenovo\.m2\repository`（已存在，历史构建下载的依赖）

> 说明：本项目为 Maven 多模块工程，无 `mvnw` wrapper，必须依赖系统 Maven。当前会话的 PATH 已在运行前临时导出，跨会话/新终端需重新确认 `mvn -version` 可用，或永久配置系统环境变量。

## 项目结构与构建模块

Teedy 为 Maven 多模块项目，根 `pom.xml` 聚合以下模块：

- `docs-core/`：核心后端
- `docs-web/`：Web 应用（含前端 `src/main/webapp/`）
- `docs-web-common/`：Web 公共模块
- `docs-android/`：Android（本次实验不展开）
- `docs-importer/`：导入模块

## 常用命令

```bash
# 查看 Maven 版本
mvn -version

# 完整构建（跳过测试可加 -DskipTests）
mvn clean install

# 只构建不跑测试
mvn clean install -DskipTests

# 启动 Teedy（构建产物方式，具体以 README 为准）
# 详见根目录 README「构建与运行」章节
```

## 访问地址

- 登录页：`http://localhost:8080`（构建产物方式，端口以实际配置为准）

## Docker 环境（实验八/九新增）

- **Docker Desktop**：4.100.0（Engine 29.9.3），后端 WSL2（内核 6.18.33）
- **安装位置**：`C:\Users\Lenovo\AppData\Local\Programs\DockerDesktop\`
- **docker.exe**：`C:\Users\Lenovo\AppData\Local\Programs\DockerDesktop\resources\bin\docker.exe`
- **Docker Compose**：v5.7.1；**kubectl**：v1.36.1（Docker Desktop 自带）
- **代理**：FlClashCore，`127.0.0.1:7890`（仅监听本机回环，未开局域网）
- **镜像加速源**（`C:\Users\Lenovo\.docker\daemon.json` 的 `registry-mirrors`）：
  - `https://docker.m.daocloud.io`
  - `https://docker.1ms.run`
  - `https://docker.xuanyuan.me`

### 环境修复记录（2026-11-23）

1. **WSL 服务被禁用**（`WSLService` 状态 Disabled，报错 `0x80070422`）→ 管理员 PowerShell 执行
   `sc.exe config WSLService start= auto; sc.exe start WSLService` 修复，现开机自启。
2. **Docker Hub 拉镜像超时**（`auth.docker.io` 走代理不稳定）→ 配置 `registry-mirrors`
   走国内加速源解决。
3. **代理配置**：`C:\Users\Lenovo\AppData\Roaming\Docker\settings-store.json` 增加
   `OverrideProxyHTTP/HTTPS = http://127.0.0.1:7890`。
4. **注意**：Docker Desktop 的 GUI 启动/`wsl.exe` 被 WorkBuddy 沙箱拦截，需用户手动
   双击桌面图标启动；`docker`/`docker compose`/`kubectl` 命令可直接调用（PATH 需含 bin 目录）。

## 历史环境差异说明

`docs/experiment-02-git.md` 记录的历史实验在 **WSL2（Ubuntu）** 下完成（路径 `/home/tang/Research/Teedy`）。当前恢复实验在 **Windows 原生** 环境进行（路径 `D:\Research\Teedy`），两者是独立副本。环境差异不影响实验结论，但记录版本时应以当前实际环境为准。
