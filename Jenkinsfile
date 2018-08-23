pipeline {
    agent any
    environment {
        AWS_REGION = 'eu-west-1'
        VTW_ECR = '461549540087.dkr.ecr.eu-west-1.amazonaws.com'
        FILE_DOWNLOADER_IMAGE_REPO = 'vtw-file-downloader'
        IMAGE_DESCRIPTION = 'file-downloader'
    }
    stages {
        stage('create-ecr-repo') {
            steps {
                sh 'chmod u+x ./scripts/createEcrRepo.sh'
                sh './scripts/createEcrRepo.sh "${FILE_DOWNLOADER_IMAGE_REPO}" "${AWS_REGION}"'
            }
        }
        stage('build-base-image') {
            steps {
                sh '''set -eux
                     GIT_SHA=$(git rev-parse --short HEAD)
                     docker build -t "${IMAGE_DESCRIPTION}":"${GIT_SHA}" .
                     '''
            }
        }
        stage('push-to-registry') {
            steps {
                sh '''set -eux
                 GIT_SHA=$(git rev-parse --short HEAD)
                 docker tag "${IMAGE_DESCRIPTION}":"${GIT_SHA}" "${VTW_ECR}"/"${FILE_DOWNLOADER_IMAGE_REPO}":${IMAGE_DESCRIPTION}
                 docker tag "${IMAGE_DESCRIPTION}":"${GIT_SHA}" "${VTW_ECR}"/"${FILE_DOWNLOADER_IMAGE_REPO}":"${GIT_SHA}"
                 eval $(aws ecr get-login --no-include-email --region "${AWS_REGION}")
                 docker push "${VTW_ECR}"/"${FILE_DOWNLOADER_IMAGE_REPO}":"${GIT_SHA}"
                 docker push "${VTW_ECR}"/"${FILE_DOWNLOADER_IMAGE_REPO}":"${IMAGE_DESCRIPTION}";
                 '''
            }
            post {
                always {
                    sh '''GIT_SHA=$(git rev-parse --short HEAD)
                    docker rmi "${IMAGE_DESCRIPTION}":"${GIT_SHA}"
                    '''
                }
            }
        }
    }
}