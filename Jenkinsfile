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
