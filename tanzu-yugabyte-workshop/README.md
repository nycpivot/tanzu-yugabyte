Tanzu/YugabyteDB Workshop
=============================

This repository will outline the steps necessary for building a demo or workshop showcasing integration of YugabyteDB with VMware Tanzu Build Service (TBS) and Tanzu Kubernetes Grid (TKG). These include the following...

* installing an instance of a YugabyteDB Universe to a TKG cluster.
* creating a sample database to which a Spring Boot application will connect.
* build a container image from a Spring Boot application with TBS hosted in a TKG cluster.
* deploy the image to a TKG cluster.
* setup users participating in a workshop setting (optional).

Here is a high-level reference architecture.

![](ref-arch/gitlab-pipeline.jpg "Reference Architecture")

## Prerequisites

* The secret acquired by YugabyteDB for pulling the chart to install the YugabyteDB Platform version (UI-based).

* Access to a running [Tanzu Build Service](https://docs.pivotal.io/build-service/1-0/index.html) instance.

* Access to a running [Tanzu Kubernetes Grid](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/index.html) workload cluster.

* NOTE: For purposes of this demonstration, our workload cluster was created with six worker nodes using t3.2xlarge AMI instances defined in .tkg/config.

## Getting started

Follow the steps [here](https://docs.yugabyte.com/latest/yugabyte-platform/install-yugabyte-platform/install-software/kubernetes/) to download and install the platform.

## Pipeline configuration

The .gitlab-ci.yml file defines the stages of an automated CI/CD pipeline from a code commit to the deployment of a container image to a Kubernetes cluster. Each stage is composed of one or more jobs.

<pre>
stages:
  - static testing
  - set-registry-creds
  - build
  - container scanning
  - deploy
  - review
  - dast
  - staging
  - canary
  - production
  - incremental rollout 10%
  - incremental rollout 25%
  - incremental rollout 50%
  - incremental rollout 100%
  - performance
  - cleanup
  - deploy-to-review
  - dast
  - cleanup
  </pre>

Those stages in bold will be given the most attention in this documentation. Many of these stages are already covered in GitLab documentation which makes them highly reusable across a variety of different pipeline use cases.

An include section imports these predefined stages and respective jobs in their own .yml files.

<pre>
include:
  - local: ci/test.gitlab-ci.yml
  - local: ci/update-glr-creds.gitlab-ci.yml
  - local: ci/build.gitlab-ci.yml
  - template: Jobs/Code-Quality.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/ci/templates/Jobs/Code-Quality.gitlab-ci.yml
  - template: Jobs/Deploy.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/ci/templates/Jobs/Deploy.gitlab-ci.yml
  - template: Jobs/DAST-Default-Branch-Deploy.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/ci/templates/Jobs/DAST-Default-Branch-Deploy.gitlab-ci.yml
  - template: Jobs/Browser-Performance-Testing.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/ci/templates/Jobs/Browser-Performance-Testing.gitlab-ci.yml
  - template: Security/DAST.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/ci/templates/Security/DAST.gitlab-ci.yml
  - template: Security/Container-Scanning.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/ci/templates/Security/Container-Scanning.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/ci/templates/Security/Dependency-Scanning.gitlab-ci.yml
  - template: Security/License-Scanning.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/ci/templates/Security/License-Scanning.gitlab-ci.yml
  - template: Security/SAST.gitlab-ci.yml  # https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/ci/templates/Security/SAST.gitlab-ci.yml
  - template: Security/Secret-Detection.gitlab-ci.yml # https://gitlab.com/gitlab-org/gitlab-foss/blob/master/lib/gitlab/ci/templates/Security/Secret-Detection.gitlab-ci.yml
</pre>

Basics
=====================

Text defined within the curly braces are environment variables, either provided by the GitLab pipeline, such as, **{CI_REGISTRY_USER}** and **{CI_PROJECT_ID}**, or custom user variables defined on the **[Settings -> CI/CD -> Variables](https://gitlab.com/gitlab-com/alliances/vmware/sandbox/vmworld-2020-demo/spring-music/-/settings/ci_cd)** page section, in this case, **{CI_TBS_GLR_USER}**, and **{CI_TBS_GLR_PASSWORD}**.

**Note**: GitLab uses a "CI_" prefix on internal pipeline variables. We suggest choosing a different prefix according to your organization's own naming conventions. This helps differentiate user defined variables and those defined by the GitLab platform environment. The demo uses the "TBS_" prefix consistently throughout.


Stages
=====================

## set-registry-creds

This stage is defined in the **ci/update-glr-creds.gitlab-ci.yml** file. The purpose of this stage is to set the secret necessary for TBS to authenticate with the GitLab registry to push the image after being built.

**NOTE**: If TBS pulls OS stacks and buildpacks from a private registry, it is required to generate a secret for that registry as well. You many have done this already when setting up TBS itself.

This job relies on a custom container built with the requisite CLI tools necessary to build images on TBS. The image is stored in the GitLab registry of the project with the same name.

<pre>
Set Registry Credentials:
  stage: set-registry-creds
  image: 
    name: registry.gitlab.com/gitlab-com/alliances/vmware/sandbox/vmworld-2020-demo/spring-music/tbs-tools
  script:
    - create-kubeconfig.sh
    - secretName="${CI_REGISTRY_USER}-${CI_PROJECT_ID}"
    - |
      export REGISTRY_PASSWORD=${TBS_GITLAB_REGISTRY_PASSWORD}
      kp secret delete "${secretName}" || true
      kp secret create "${secretName}" --registry "${CI_REGISTRY}" --registry-user "${TBS_GITLAB_REGISTRY_USERNAME}"
</pre>

The following outline describes this stage.  

* **image**, the container image used to run this stage.
* **image.name**, the docker hub repository from where the image is pulled.
* **create-kubeconfig.sh**, the script defined in the container responsible for generating the .kube/config context for the TBS cluster.
* **kp secret create**, stores the password on the TBS cluster used to authenticate with the target image registry, in this case, the GitLab registry.

The secret name and value for the target registry is defined in the **[Settings -> Repository -> Deploy Tokens](https://gitlab.com/gitlab-com/alliances/vmware/sandbox/vmworld-2020-demo/spring-music/-/settings/repository)** section. This section is where scopes can be applied, for example, read_registry and write_registry. It is then necessary to create environment variables for the username and secret of the token. In this example, those are **{TBS_GITLAB_REGISTRY_USERNAME}** and **{TBS_GITLAB_REGISTRY_PASSWORD}** respectively.

## build

This stage is defined in the **ci/build.gitlab-ci.yml** file. The primary purpose of this stage is to update an existing image or create a new image.

This job relies on a custom container built with the requisite CLI tools necessary to build images on TBS. The image is stored in the GitLab registry of the project with the same name.

<pre>
TBS Image  Build:  
  stage: build
  image:  
    name: registry.gitlab.com/gitlab-com/alliances/vmware/sandbox/vmworld-2020-demo/spring-music/tbs-tools
  script:
    - create-kubeconfig.sh
    - kp image status "$CI_PROJECT_NAME-$CI_COMMIT_BRANCH" > /dev/null 2>&1 || image=0
    - |
      if [[ $image != 0 ]]; then
        kp image patch "$CI_PROJECT_NAME-$CI_COMMIT_BRANCH" --git "$CI_REPOSITORY_URL" --git-revision "$CI_COMMIT_SHA" -w
      else
       kp image create "$CI_PROJECT_NAME-$CI_COMMIT_BRANCH" --tag "$CI_REGISTRY_IMAGE/$CI_COMMIT_BRANCH" --git "$CI_REPOSITORY_URL" --git-revision "$CI_COMMIT_SHA" -w
      fi
</pre>

The following outline describes this stage.  

* **image**, the container image used to run this stage.
* **image.name**, the docker hub repository from where the image is pulled.
* **create-kubeconfig.sh**, the script responsible for building .kube/config and setting the context to the TBS cluster.
* **kp image status**, determines if the image is new or an updated version based on the commit branch.
* **kp image patch**, updates an existing image in the registry.
* **kp image create**, creates and stores a new image in the registry.

## tbs-tools

The custom container used in the preceding two stages is prebuilt with various useful VMware Tanzu CLI tools.

* **kp**, manages images on the TBS instance.
* **kubectl**, to execute native Kubernetes commands.

You can reuse this container, or build your own to customize it to your own needs.

**create-kubeconfig.sh**, creates the .kube/config file and builds the TBS context.

In order for Tanzu Build Service to access the container registry, it is necessary to create a Deploy Token **[Settings -> Repository -> Deploy Tokens](https://gitlab.com/gitlab-com/alliances/vmware/sandbox/vmworld-2020-demo/spring-music/-/settings/repository)**. In this demo, the username (tbs-tools) and password are stored as Environment Variables for easy access in case the password is forgotten. Use these to create a secret on the Build Service cluster.

<pre>
  kp secret create gitlab-registry-secret --registry registry.gitlab.com --registry-user tbs-tools
</pre>

It will prompt for the password. Input the password generated from the new Deploy Token.

<pre>
#!/usr/bin/env bash
set -eu

export KUBECONFIG=~/.kube/config

mkdir -p "$(dirname "${KUBECONFIG}")"

cat > "${KUBECONFIG}" << EOF
apiVersion: v1
kind: Config
clusters:
  - cluster:
      certificate-authority-data: ${TBS_CLUSTER_CERTIFICATE_AUTHORITY_DATA}
      server: ${TBS_CLUSTER_SERVER_ADDRESS}
    name: cluster
contexts:
  - context:
      cluster: cluster
      user: user
    name: user@cluster
current-context: user@cluster
users:
  - name: user
    user:
      client-certificate-data: ${TBS_CLUSTER_CLIENT_CERTIFICATE_DATA}
      client-key-data: ${TBS_CLUSTER_CLIENT_KEY_DATA}
EOF
</pre>

All of these environment variables are injected into the container when executed and are defined on the **[Settings -> CI/CD -> Variables](https://gitlab.com/gitlab-com/alliances/vmware/sandbox/vmworld-2020-demo/spring-music/-/settings/ci_cd)** page section.

## Kubernetes

A Kubernetes cluster must be configured as the target environment where the app image is deployed. This is done on the **[Operations -> Kubernetes](https://gitlab.com/gitlab-com/alliances/vmware/sandbox/vmworld-2020-demo/spring-music/-/clusters)** page.

Follow these steps to setup the target workload cluster for the app to run.

* Connect existing cluster.
* Specify a name and environment scope.
* The API URL is the path to the kube-apiserver in the cluster. This is the **server** attribute in the .kube config file. Alternately, run the following command. Paste the URL into the API URL field.

<pre>
  kubectl cluster-info | grep -E 'Kubernetes master|Kubernetes control plane' | awk '/http/ {print $NF}'
</pre>

* The CA certificate is a base64 decoded string of either the **client-certificate-data** attribute in .kube config. Alternatively, decode the token within the **default-token-xxxxx** secret of the namespace. Copy and paste the certificate into the CA certificate field.

<pre>
  kubectl get secrets
  kubectl get secret default-token-xxxxx -o jsonpath="{['data']['ca\.crt']}" | base64 --decode
</pre>

* Service token. It is necessary to create a service account for GitLab to access and modify the namespace. Add the following configuration to a YAML file, for example, gitlab-admin-service-account.yaml, and apply it.

<pre>
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: gitlab
    namespace: kube-system
  ---
  apiVersion: rbac.authorization.k8s.io/v1beta1
  kind: ClusterRoleBinding
  metadata:   
    name: gitlab-admin
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: cluster-admin
  subjects:
    - kind: ServiceAccount
      name: gitlab
      namespace: kube-system
</pre>

<pre>
  kubectl apply -f gitlab-admin-service-account.yaml
</pre>

Retrieve the token from the service account with the following command and paste it into the Service token field on the cluster configuration page.

<pre>
  kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep gitlab | awk '{print $1}')
</pre>

For the purposes of this demo, an existing Tanzu Kubernetes Grid cluster must be configured so the auto-deploy mechanism (see below) will have the details it needs to communicate with it.

## Deployment

The majority of the stages defined in this pipeline are included in the **Jobs/Deploy.gitlab-ci.yml** file.

<pre>
stages:
  - review
  - staging
  - canary
  - production
  - incremental rollout 10%
  - incremental rollout 25%
  - incremental rollout 50%
  - incremental rollout 100%
  - cleanup
</pre>

The scripts executed in these stages/jobs are baked into the .auto-deploy container image.

<pre>
.auto-deploy:
  image: "registry.gitlab.com/gitlab-org/cluster-integration/auto-deploy-image:v1.0.3"
</pre>

The scripts used to deploy the app to the target container, whether they are, review, staging, canary, or production, are generally as follows.

For example, the following snippet are the scripts run during the **staging** stage.

<pre>
- auto-deploy check-kube-domain
- auto-deploy download_chart
- auto-deploy ensure_namespace
- auto-deploy initialize_tiller
- auto-deploy create_secret
- auto-deploy deploy
</pre>

These scripts will fail if the necessary settings are not in place.

* **check-kube-domain**, checks that the ingress is configured with a wildcard domain.
* **download_chart**, pulls the helm chart used to deploy the app.
* **deploy**, deploys the app to the target Kubernetes cluster.