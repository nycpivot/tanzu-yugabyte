#!/bin/bash

[[ -z "$TANZU_AWS_REGION" ]] && { echo "TANZU_AWS_REGION is empty. Please set" ; exit 1; }
[[ -z "$TANZU_AWS_ACCESS_KEY_ID" ]] && { echo "TANZU_AWS_ACCESS_KEY_ID is empty. Please set" ; exit 1; }
[[ -z "$TANZU_AWS_SECRET_ACCESS_KEY" ]] && { echo "TANZU_AWS_SECRET_ACCESS_KEY is empty. Please set" ; exit 1; }
[[ -z "$TANZU_IMAGE_NAME" ]] && { echo "TANZU_IMAGE_NAME is empty. Please set" ; exit 1; }


REGION=$TANZU_AWS_REGION
AWS_ACCESS_KEY_ID=$TANZU_AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$TANZU_AWS_SECRET_ACCESS_KEY
IMAGE_NAME=$TANZU_IMAGE_NAME


function configure_aws_cli {
    mkdir $HOME/.aws
cat << EOF > $HOME/config
[default]
region = $REGION
output = json
EOF

cat << EON > $HOME/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EON
}

function get_aws_account_id {
    echo "gettinget_aws_account_id()"
    AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
    echo "AWS ACCOUNT ID: $AWS_ACCOUNT_ID"
}

function ecr_password {
    echo "getting ecr_password"
    #remove quotes around $REGION
    temp="${REGION%\"}"
    temp="${temp#\"}"
    #remove quotes
    
    ECR_PASSWORD=`aws ecr get-login-password \
        --region $temp`  

    [[ -z "$ECR_PASSWORD" ]] && { echo "ECR_PASSWORD is empty. Please set" ; exit 1; }

    echo $ECR_PASSWORD | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$temp.amazonaws.com

}

function create_repo {
    aws ecr create-repository \
        --repository-name $IMAGE_NAME \
        --image-scanning-configuration scanOnPush=false \
        --region $REGION

}

function tag_image {
	docker tag $IMAGE_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$IMAGE_NAME:latest
}

function push_image {
	docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$IMAGE_NAME:latest
}

function get_repositories_aws_cli {
    aws ecr describe-repositories --no-cli-pager
}

function get_repositories {
        REPOS_JSON=`get_repositories_aws_cli`
        echo $REPOS_JSON | jq .repositories[].repositoryName
}

function get_images_aws_cli {
    aws ecr describe-images --no-cli-pager --repository-name $IMAGE_NAME
}

function get_images {
    IMAGES_JSON=`get_images_aws_cli`
    echo $IMAGES_JSON | jq .
}

function create_k8s_secret_for_docker {
    echo "creating docker secret"
    kubectl delete secret harbor
    
    kubectl create secret generic harbor \
    --from-file=.dockerconfigjson=$HOME/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson -o yaml > docker-secret.yaml
}

configure_aws_cli
get_aws_account_id
ecr_password
#create_repo
#get_repositories
#get_images
#tag_image
#push_image
create_k8s_secret_for_docker

