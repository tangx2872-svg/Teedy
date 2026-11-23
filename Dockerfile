# =============================================================
# Teedy 多阶段构建 Dockerfile（实验八）
# 阶段 1（builder）：构建前端 + Maven 打包，产出 docs-web WAR
# 阶段 2（runtime）：Jetty 11 + JRE 11 运行环境，部署 WAR
# =============================================================

# ---------- 阶段 1：构建 ----------
FROM maven:3.9-eclipse-temurin-11 AS builder

# 安装 Node.js 22（与本地已验证的构建环境一致：node v22 + npm 10）
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# 先拷贝 pom 依赖定义，利用 Docker 层缓存
COPY pom.xml .
COPY docs-core/pom.xml docs-core/
COPY docs-web-common/pom.xml docs-web-common/
COPY docs-web/pom.xml docs-web/

# 预下载 Maven 依赖（缓存层）
RUN mvn -B -ntp dependency:go-offline -DskipTests || true

# 拷贝全部源码
COPY docs-core docs-core/
COPY docs-web-common docs-web-common/
COPY docs-web docs-web/

# 前端构建（npm install + grunt 生成 dist）
WORKDIR /build/docs-web/src/main/webapp
RUN npm install \
    && ./node_modules/.bin/grunt

# Maven 打包（跳过测试，产出 WAR）
WORKDIR /build
RUN mvn -B -ntp package -DskipTests

# ---------- 阶段 2：运行 ----------
FROM eclipse-temurin:11-jre

LABEL maintainer="tangx2872-svg"
LABEL description="Teedy document management system (experiment 8)"

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV JAVA_OPTIONS="-Dfile.encoding=UTF-8 -Xmx1g"
ENV JETTY_VERSION 11.0.20
ENV JETTY_HOME /opt/jetty

# 安装运行所需系统依赖（OCR / 媒体处理）
RUN apt-get update && \
    apt-get -y -q --no-install-recommends install \
    tzdata curl \
    ffmpeg \
    mediainfo \
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-chi-sim \
    tesseract-ocr-chi-tra \
    tesseract-ocr-fra \
    tesseract-ocr-deu \
    tesseract-ocr-spa \
    tesseract-ocr-ita \
    tesseract-ocr-jpn \
    tesseract-ocr-kor \
    tesseract-ocr-rus \
    tesseract-ocr-ara \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 安装 Jetty 11
RUN curl -fsSL -o /tmp/jetty.tar.gz \
    "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/${JETTY_VERSION}/jetty-home-${JETTY_VERSION}.tar.gz" \
    && tar xzf /tmp/jetty.tar.gz -C /opt \
    && mv /opt/jetty-home-${JETTY_VERSION} /opt/jetty \
    && rm /tmp/jetty.tar.gz \
    && useradd jetty -U -s /bin/false \
    && mkdir -p /opt/jetty/webapps /data \
    && chown -R jetty:jetty /opt/jetty /data \
    && chmod +x /opt/jetty/bin/jetty.sh

# 拷贝 Jetty 配置与 WAR 制品
COPY docs.xml /opt/jetty/webapps/docs.xml
COPY --from=builder /build/docs-web/target/docs-web-*.war /opt/jetty/webapps/docs.war

# Jetty 容器内监听端口（宿主机通过 -p 8888:8080 映射）
EXPOSE 8080

WORKDIR /opt/jetty
USER jetty

# 初始化 Jetty 模块并启动
RUN java -jar /opt/jetty/start.jar --add-modules=server,http,webapp,deploy

CMD ["java", "-jar", "/opt/jetty/start.jar"]
