#!/usr/bin/env bash
ECR_REPO=${1}
AWS_REGION=${2}

aws ecr describe-repositories --repository-names "${ECR_REPO}" --region "${AWS_REGION}"
if [ $? -ne 0 ]
then
    aws ecr create-repository --repository-name "${ECR_REPO}" --region "${AWS_REGION}"
    echo "Creating ECR repository: ${ECR_REPO}"
fi