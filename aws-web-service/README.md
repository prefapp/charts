# AWS Web Service chart

## Purpose

This chart allows you to deploy any webservice on your EKS Cluster to expose it to the internet.

## Requirements

### AWS Parameter Store

If you want to use AWS Parameter Store, first you have to install [csi-secrets-store-provider-aws](https://artifacthub.io/packages/helm/aws/csi-secrets-store-provider-aws).

Link here: 

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

If you want to use AWS Application Load Balancer, first you have to deploy the [official ALB chart](https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller)





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
