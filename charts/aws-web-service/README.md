# AWS Web Service chart

![](./pic/diagram-aws-web-service.png)

## Purpose

This chart allows you to deploy any webservice on your EKS Cluster to expose it to the internet.

### To install
```
helm repo add prefapp https://prefapp.github.io/charts/aws-web-service
helm repo update
```

## Requirements

### AWS Parameter Store

If you want to use AWS Parameter Store, first you have to install [csi-secrets-store-provider-aws](https://artifacthub.io/packages/helm/aws/csi-secrets-store-provider-aws).

Then you have to grant access to the pods to the secrets. So we need to create a policy, a role and an attachtment.

You can do it with terraform, where you have your EKS Module.

Example:

```terraform

#IAM Policy to grant access to
resource "aws_iam_policy" "iam_policy_parameter_store" {
  name = "iam_policy_parameter_store"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : ["ssm:GetParameter", "ssm:GetParameters"],
      "Resource" : ["arn:aws:ssm:${var.region}:${var.aws_account}:parameter/mypath.*"]
    }]
  })
}

# Role IAM Parameter Store
resource "aws_iam_role" "iam_role_parameter_store" {
  name = "iam_role_parameter_store"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${module.eks.oidc_provider_arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringLike" : {
            "${split("oidc-provider/", module.eks.oidc_provider_arn)[1]}:sub" : "system:serviceaccount:my-sa"
          }
        }
      }
    ]
  })
}

# Attach custom IAM Role Policy
resource "aws_iam_role_policy_attachment" "iam_role_parameter_store_attachment" {
  role       = aws_iam_role.iam_role_parameter_store.name
  policy_arn = aws_iam_policy.iam_policy_parameter_store.arn
}

```

### AWS Application Load Balancer

If you want to use AWS Application Load Balancer, first you have to deploy the [official ALB chart](https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller).

### AWS Storage

Enabling the `volume.enabled` flag will enable the options to add a volume. The Chart has the necessary values prepared to link an AWS EFS but you can also connect other types of storage.

## Values

| Name                              | Description                                                                                                                                                                                             | Type    | Default                          |
|-----------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------|----------------------------------|
| configmap.data                    | Kubernetes common configmap data                                                                                                                                                                        | {}      | {}                               |
| deployment.additionalLabels       | Additional labels for deployment                                                                                                                                                                        | {}      | {}                               |
| deployment.app                    | App name and container name                                                                                                                                                                             | string  | app                              |
| deployment.replicas               | Container replicas                                                                                                                                                                                      | number  | 1                                |
| deployment.containerPort          | Exposed container port                                                                                                                                                                                  | number  | 80                               |
| deployment.command                | Common unique command                                                                                                                                                                                   | string  | ""                               |
| deployment.entrypointFile         | Command mounted as entrypoint with special values                                                                                                                                                       | string  | ""                               |
| deployment.startupProbe           | Common kubernetes startupProbe                                                                                                                                                                          | {}      | {}                               |
| deployment.livenessProbe          | Common kubernetes livenessProbe                                                                                                                                                                         | {}      | {}                               |
| deployment.readinessProbe         | Common kubernetes readinessProbe                                                                                                                                                                        | {}      | {}                               |
| deployment.volumeMounts           | Common kubernetes volumeMounts                                                                                                                                                                          |         |                                  |
| deployment.imagePullPolicy        | Common kubernetes imagePullPolicy                                                                                                                                                                       | string  | Always                           |
| deployment.imagePullSecrets       | Common kubernetes imagePullSecrets                                                                                                                                                                      | {}      |                                  |
| deployment.nodeSelector.enabled   | Enables nodeSelector feature                                                                                                                                                                            | boolean | false                            |
| deployment.nodeSelector.tags      | Deploys the pods on your tagged node                                                                                                                                                                    | {}      | {}                               |
| deployment.resources.limits.cpu   | Common kubernetes resources limits cpu                                                                                                                                                                  | string  |                                  |
| deployment.resources.limits.memory| Common kubernetes resources limits memory                                                                                                                                                               | string  | 128Mi                            |
| deployment.resources.requests.cpu | Common kubernetes resources requests cpu                                                                                                                                                                | string  | 100m                             |
| deployment.resources.requests.memory| Common kubernetes resources requests memory                                                                                                                                                           | string  | 128Mi                            |
| ingress.enabled                   | Enables/Disables Ingress creation                                                                                                                                                                       | boolean | true                             |
| ingress.alb.enabled               | Enables/Disables the ALB                                                                                                                                                                                | boolean | true                             |
| ingress.alb.scheme                | Exposes web service to internet with "internet-facing" or internally with "internal"                                                                                                                    | string  | internet-facing                  |
| ingress.alb.protocol              | Protocol that ALB will use in the ingress, it is not neccesary to set it as "HTTPS", because the chart has an ssl-redirect to 443                                                                       | string  | HTTP                             |
| ingress.alb.listenPorts           | ALB listen ports                                                                                                                                                                                        | string  | '[{"HTTP": 80}, {"HTTPS": 443}]' |
| ingress.alb.groupName             | Name of the group that ingress will belong to. If you have multiple deployments with the chart, it is recommended to use the same group name.                                                           | string  | default-group                    |
| ingress.alb.host                  | Host URL                                                                                                                                                                                                | string  | site.com                         |
| ingress.annotations               | Common aditional annotations for the ingress                                                                                                                                                            | {}      | {}                               |
| ingress.ingressClassName          | Common ingress class name, if you use alb the value should be "alb"                                                                                                                                     | string  | alb                              |
| parameterStore.enabled            | Enables/Disables parameter store                                                                                                                                                                        | boolean | false                            |
| parameterStore.secrets_scm_sa_arn | ARN Role that will use the Service Account to access to get the parameters from the parameter store. This role should be created previosly with Terraform.                                              | string  | ""                               |
| parameterStore.secrets_scm_sa     | Service account name. This service account will use the previous parameter.                                                                                                                             | string  | ""                               |
| parameterStore.splitter           | Parameter Store recomends to use a path when you create a new parameter (/my/parameter/path), but you can generate it with another special character, so if you use another, you should specify it here | string  | "/"                              |
| parameterStore.data               | The data from your parameter store. The key is the env var and the value is the path of your parameter. Example: ```MY_ENV_VAR: /my/parameter/path ```                                                  | {}      | {}                               |
| maintenance_mode                  | If you have problems to deploy your container, this mode will execute ```tail -f /dev/null```                                                                                                           | boolean | false                            |
| service.port                      | Service port and targetPort unified                                                                                                                                                                     | number  | 80                               |
| service.labels                    | Common labels for service                                                                                                                                                                               | {}      | {}                               |
| secrets                           | If you don´t use Parameter Store, you can add your own secrets                                                                                                                                          | {}      | {}                               |
| volume.efs_id                     | For add the `volumeHandle`. Must be the same value as in StorageClass of the pod you want to link to.                                                                                                   | string  | efs-sc                           |
| volume.enabled                    | Enables/Disables the volume (EFS). If the volumes are enabled, the remaining values are required.                                                                                                       | boolean | true                             |
| volume.mount                      | Mount point for `mountPath`.                                                                                                                                                                            | string  | ""                               |
| volume.runAsGroup                 | The GID to run the entrypoint of the container process. Uses runtime default if unset. If set the value specified in SecurityContext takes precedence.                                                  | string  | ""                               |
| volume.runAsUser                  | The UID to run the entrypoint of the container process. Uses runtime default if unset. If set the value specified in SecurityContext takes precedence.                                                  | string  | ""                               |
| volume.storageClass               | Each StorageClass has a provisioner that determines what volume plugin is used for provisioning PVs. efs-sc, manual, etc                                                                                | string  | ""                               |
| volume.storageSize                | Define the storage capacity in  Ei, Pi, Ti, Gi, Mi, Ki or  E, P, T, G, M,                                                                                                                               | string  | ""                               |
| webService.image                  | Your Docker Image                                                                                                                                                                                       | string  |   stefanprodan/podinfo           |

## License

Copyright &copy; 2022 Prefapp

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
