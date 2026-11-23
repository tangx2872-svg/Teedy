// Teedy 持续集成流水线（实验七）— 声明式 Pipeline
// 阶段：构建 → PMD 代码检查 → 自动化测试 → JavaDoc → 打包归档
// 说明：本项目存在 3 个上游基线测试失败（TestMimeTypeUtil、
//       TestPdfFormatHandler#testIssue373、TestFileUtil），测试阶段如实
//       运行不降级，失败即标红，并在报告中如实记录。

pipeline {
    agent any

    tools {
        // 需在 Jenkins「全局工具配置」中命名为 jdk11 与 maven3
        jdk 'jdk11'
        maven 'maven3'
    }

    options {
        timeout(time: 45, unit: 'MINUTES')
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
    }

    environment {
        MAVEN_OPTS = '-Xmx2048m -Dfile.encoding=UTF-8'
        // 如 Jenkins 部署在内网代理后，可在此补充 HTTP_PROXY / NO_PROXY
        // Docker 镜像仓库（实验八）：默认推 GHCR，可改为 Docker Hub
        DOCKER_REGISTRY = 'ghcr.io/tangx2872-svg'
        IMAGE_NAME = 'teedy'
    }

    stages {
        stage('检出代码') {
            steps {
                checkout scm
            }
        }

        stage('Maven 构建') {
            steps {
                sh 'mvn -B -ntp clean compile'
            }
        }

        stage('PMD 代码检查') {
            steps {
                sh 'mvn -B -ntp pmd:pmd pmd:cpd pmd:check pmd:cpd-check'
            }
            post {
                always {
                    // 归档 PMD 报告，便于在 Jenkins 界面查看
                    archiveArtifacts artifacts: '**/target/site/pmd.html, **/target/pmd.xml, **/target/cpd.xml',
                        allowEmptyArchive: true
                }
            }
        }

        stage('自动化测试') {
            steps {
                sh 'mvn -B -ntp test'
            }
            post {
                always {
                    // 发布 Surefire 测试报告（TestNG/JUnit 结果）
                    junit testResults: '**/target/surefire-reports/*.xml', allowEmptyResults: true
                    // 发布 JaCoCo 覆盖率报告
                    jacoco(
                        execPattern: '**/target/jacoco.exec',
                        classPattern: '**/target/classes',
                        sourcePattern: '**/src/main/java',
                        exclusionPattern: '**/target/**'
                    )
                    // 归档测试报告原始文件
                    archiveArtifacts artifacts: '**/target/surefire-reports/**', allowEmptyArchive: true
                }
            }
        }

        stage('生成 JavaDoc') {
            steps {
                sh 'mvn -B -ntp javadoc:javadoc javadoc:jar'
            }
            post {
                always {
                    archiveArtifacts artifacts: '**/target/apidocs/**, **/target/*-javadoc.jar',
                        allowEmptyArchive: true
                }
            }
        }

        stage('打包与归档') {
            steps {
                sh 'mvn -B -ntp package -DskipTests'
            }
            post {
                always {
                    // 归档可执行 WAR / JAR 制品
                    archiveArtifacts artifacts: '**/target/*.war, **/target/*.jar',
                        allowEmptyArchive: true
                }
            }
        }

        // ===== 实验八：Docker 容器化阶段 =====
        // 需 Jenkins agent 已安装 Docker，且已配置 Docker Hub/GHCR 凭据
        // （凭据 ID 见 environment，勿将密码/Token 明文写入）。
        stage('构建 Docker 镜像') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${env.BUILD_NUMBER} .'
            }
        }

        stage('推送 Docker 镜像') {
            steps {
                // 用 withCredentials 注入凭据，避免 Token 泄漏
                withCredentials([usernamePassword(
                        credentialsId: 'ghcr-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_TOKEN')]) {
                    sh '''
                        echo "$DOCKER_TOKEN" | docker login ${DOCKER_REGISTRY} -u "$DOCKER_USER" --password-stdin
                        docker tag ${IMAGE_NAME}:${env.BUILD_NUMBER} ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                        docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                        docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}
                    '''
                }
            }
        }

        stage('运行容器（端口 8888）') {
            steps {
                sh '''
                    docker rm -f teedy || true
                    docker run -d --name teedy \
                        -p 8888:8080 \
                        -e DOCS_BASE_URL="http://localhost:8888" \
                        ${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}
                '''
            }
            post {
                always {
                    // 验证 8888 端口可访问后清理容器
                    sh '''
                        for i in $(seq 1 30); do
                            if curl -fsS -o /dev/null http://localhost:8888/ 2>/dev/null; then
                                echo "容器已通过 8888 端口正常响应"
                                break
                            fi
                            sleep 2
                        done
                        docker rm -f teedy || true
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Teedy 持续集成流水线执行成功。'
        }
        failure {
            echo 'Teedy 持续集成流水线执行失败，请查看阶段日志与测试报告。'
        }
        always {
            cleanWs()
        }
    }
}

