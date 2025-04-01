def hasChangesInDir(String dir) {
    return sh(script: "git diff --name-only HEAD~1 HEAD | grep '^${dir}/' || true", returnStdout: true).trim()
}

def deployToEC2(String imageName, String tag, String dockerfileName) {
    sshPublisher(publishers: [
        sshPublisherDesc(
            configName: 'kitchana-docker',
            transfers: [
                sshTransfer(
                    cleanRemote: false,
                    excludes: '',
                    execCommand: """
                        docker build -t ${env.AWS_ECR_URI}/${imageName}:${tag} -f ./outer/${dockerfileName} ./outer >> build-log.txt 2>&1
                        docker push ${env.AWS_ECR_URI}/${imageName}:${tag} >> build-log.txt 2>&1
                    """,
                    execTimeout: 180000,
                    flatten: false,
                    makeEmptyDirs: false,
                    noDefaultExcludes: false,
                    patternSeparator: '[, ]+',
                    remoteDirectory: './outer',
                    remoteDirectorySDF: false,
                    removePrefix: 'build/libs/',
                    sourceFiles: 'build/libs/*-SNAPSHOT.jar'
                )
            ],
            usePromotionTimestamp: false,
            useWorkspaceInPromotion: false,
            verbose: false
        )
    ])
}

pipeline {
    agent any

    tools {
        gradle 'gradle8.12.1'
        jdk 'jdk17'
    }

    environment {
        GIT_TARGET_BRANCH = 'main'
        GIT_REPOSITORY_URL = 'https://github.com/lgcns-mini-proejct2-kitchana/Kitchana-BE.git'
    }
    
    stages {
        stage('Github checkout') {
            steps {
                script {
                    echo "Cloning Repository"
                    git branch: "${GIT_TARGET_BRANCH}", url: "${GIT_REPOSITORY_URL}"
                }
            }
        }

        stage('Deploy Changed Services') {
            steps {
                script {
                    def imageTag = env.BUILD_NUMBER
                    echo "사용될 Image Tag: ${imageTag}"
                    
                    // eureka 배포
                    if (hasChangesInDir('eureka')) {
                        echo 'Eureka 변경 감지됨, 빌드 시작'
                        dir('eureka') {
                            sh './gradlew clean build -x test'
                            deployToEC2("kitchana/eureka", imageTag, "DockerfileEureka")
                        }
                        sshPublisher(publishers: [
                            sshPublisherDesc(
                                configName: 'kitchana-docker',
                                transfers: [
                                    sshTransfer(
                                        cleanRemote: false,
                                        excludes: '',
                                        sourceFiles: 'deploy-eureka.sh',
                                        removePrefix: '',
                                        remoteDirectory: '/tmp',
                                        execCommand: """
                                            cd /home/ec2-user/tmp
                                            chmod +x deploy-eureka.sh
                                            export TAG=${imageTag}
                                            ./deploy-eureka.sh
                                        """,
                                        execTimeout: 180000,
                                        flatten: false,
                                        makeEmptyDirs: false,
                                        noDefaultExcludes: false,
                                        patternSeparator: '[, ]+'
                                    )
                                ],
                                usePromotionTimestamp: false,
                                useWorkspaceInPromotion: false,
                                verbose: false
                            )
                        ])
                    }
                    
                    // Config-server 배포
                    if (hasChangesInDir('Config-server')) {
                        echo 'Config-server 변경 감지됨, 빌드 시작'
                        dir('Config-server') {
                            sh './gradlew clean build -x test'
                            deployToEC2("kitchana/config-server", imageTag, "DockerfileConfig")
                        }
                        sshPublisher(publishers: [
                            sshPublisherDesc(
                                configName: 'kitchana-docker',
                                transfers: [
                                    sshTransfer(
                                        cleanRemote: false,
                                        excludes: '',
                                        sourceFiles: 'deploy-config-server.sh',
                                        removePrefix: '',
                                        remoteDirectory: '/tmp',
                                        execCommand: """
                                            cd /home/ec2-user/tmp
                                            chmod +x deploy-config-server.sh
                                            export TAG=${imageTag}
                                            ./deploy-config-server.sh
                                        """,
                                        execTimeout: 180000,
                                        flatten: false,
                                        makeEmptyDirs: false,
                                        noDefaultExcludes: false,
                                        patternSeparator: '[, ]+'
                                    )
                                ],
                                usePromotionTimestamp: false,
                                useWorkspaceInPromotion: false,
                                verbose: false
                            )
                        ])
                    }
                    
                    // API-Gateway 배포
                    if (hasChangesInDir('API-Gateway')) {
                        echo 'API-Gateway 변경 감지됨, 빌드 시작'
                        dir('API-Gateway') {
                            sh './gradlew clean build -x test'
                            deployToEC2("kitchana/api-gateway", imageTag, "DockerfileGateway")
                        }
                        sshPublisher(publishers: [
                            sshPublisherDesc(
                                configName: 'kitchana-docker',
                                transfers: [
                                    sshTransfer(
                                        cleanRemote: false,
                                        excludes: '',
                                        sourceFiles: 'deploy-api-gateway.sh',
                                        removePrefix: '',
                                        remoteDirectory: '/tmp',
                                        execCommand: """
                                            cd /home/ec2-user/tmp
                                            chmod +x deploy-api-gateway.sh
                                            export TAG=${imageTag}
                                            ./deploy-api-gateway.sh
                                        """,
                                        execTimeout: 180000,
                                        flatten: false,
                                        makeEmptyDirs: false,
                                        noDefaultExcludes: false,
                                        patternSeparator: '[, ]+'
                                    )
                                ],
                                usePromotionTimestamp: false,
                                useWorkspaceInPromotion: false,
                                verbose: false
                            )
                        ])
                    }
                }
            }
        }
    }

    post {
        success {
            echo '모든 빌드 및 배포가 성공적으로 완료되었습니다.'
        }
        failure {
            echo '빌드 또는 배포 중 오류가 발생했습니다.'
        }
    }
}
