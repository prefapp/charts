# AWS alb generic proxified Chart 

## Purpose

A Helm chart for Kubernetes to deploy a service proxified via init container with nginx into AWS with ALB.

This chart is a generic implementation of the [AWS ALB](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-components.html) service.

Allows running services that speak http or that do not speak http, such as fastcgi.

## To install

```
helm repo add prefapp https://prefapp.github.io/charts/aws-alb-generic-proxified
helm repo update
```

## Requirements

* None

### AWS Application Load Balancer

If you want to use AWS Application Load Balancer, first you have to deploy the [official ALB chart](https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller).

## Values

| Name | Type | Description | Default |
| ---- | ---- | ----------- | ------- |
| **labels** | {} | Set a labels for all resources | {} |
| **configmap** | {} | ConfigMap with extra environment variables | {} |
| **secrets** | {} | Secrets with extra environment variables | {} |
| **whitelist** | {} | Section to define who will have access to the service by filtering ips and ranges via proxy | - |
| whitelist.**enabled** | boolean | Enable whitelist | false |
| whitelist.**private_ranges** | [] | List of private IP ranges that are allowed to access the service | []
| whitelist.**ips** | [] | List of private IPs that are allowed to access the service | []
| **deployment** | {} | Section to define deployment behaviour | - |
| deployment.**replicas** | int | Number of replicas | 1 |
| deployment.**volumeMounts** | [] | List of volumeMounts | [] |
| deployment.**volumes** | [] | List of volumes | [] |
| deployment.**nodeSelector** | {} | Optionally specify a node selector to run the service on a specific node. Is necessary put values in the form of type=value | {} |
| deployment.**annotations** | {} | Optionally specify a extra annotations to add to the deployment | - |
| **proxy** | {} | Section to define proxy behaviour | - |
| proxy.**name** | string | Name of the proxy container | proxy |
| proxy.**image** | string | Image of the proxy container |- |
| proxy.**image**.**registry** | string | Registry of the proxy image container | docker.io |
| proxy.**image**.**repository** | string | Repository of the proxy image container |prefapp/nginx-proxified |
| proxy.**image**.**tag** | string | Tag of the proxy image container | 0.1.0 |
| proxy.**pullPolicy** | string | Pull policy of the proxy image container | Always |
| proxy.**cors** | boolean | Enable CORS | false |
| proxy.**resources** | {} | Configure resource requests and limits for the proxy container | - |
| proxy.**resources**.**requests** | {} | Configure resource requests for the proxy container | {} |
| proxy.**resources**.**limits** | {} | Configure resource limits for the proxy container | {} |
| proxy.**maintenance_mode** | boolean | Enable maintenance mode. Activate or deactivate maintenance mode to run the container in an empty state so that it can be debugged | false |
| proxy.**command** | [] | Override default container command (useful when using custom images) | - |
| proxy.**args** | [] | Override default container args (useful when using custom images) | - |
| **app** | {} | Section to define application behaviour | - |
| app.**name** | string | Name of the application | - |
| app.**image** | string | Image of the application | - |
| app.**image**.**registry** | string | Registry of the application image | docker.io |
| app.**image**.**repository** | string | Repository of the application image | library/httpd |
| app.**image**.**tag** | string | Tag of the application image | alpine3.16 |
| app.**pullPolicy** | string | Pull policy of the application image | Always |
| app.**port** | int | Port of the application | 80 |
| app.**resources** | {} | Configure resource requests and limits for the application container | - |
| app.**resources**.**requests** | {} | Configure resource requests for the application container | {} |
| app.**resources**.**limits** | {} | Configure resource limits for the application container | {} |
| app.**maintenance_mode** | boolean | Enable maintenance mode. Activate or deactivate maintenance mode to run the container in an empty state so that it can be debugged | false |
| app.**command** | [] | Override default container command (useful when using custom images) | - |
| app.**args** | [] | Override default container args (useful when using custom images) | - |
| app.**livenessProbe** | {} | Configure liveness probe for the application container | - |
| app.**livenessProbe**.**enabled** | boolean | Enable liveness probe | false |
| app.**livenessProbe**.**httpGet** | {} | Configure httpGet for the liveness probe | - |
| app.**livenessProbe**.**httpGet**.**path** | string | Path of the httpGet | /status |
| app.**livenessProbe**.**httpGet**.**port** | int | Port of the httpGet | 80 |
| app.**livenessProbe**.**initialDelaySeconds** | int | Initial delay for the liveness probe | 10 |
| app.**livenessProbe**.**periodSeconds** | int | Period for the liveness probe | 20 |
| app.**livenessProbe**.**timeoutSeconds** | int | Timeout for the liveness probe | 10 |
| app.**livenessProbe**.**failureThreshold** | int | Number of consecutive failures before the liveness probe is considered failed | 10 |
| app.**livenessProbe**.**successThreshold** | int | Number of consecutive successes before the liveness probe is considered successful | 1 |
| app.**readinessProbe** | {} | Configure readiness probe for the application container | - |
| app.**readinessProbe**.**enabled** | boolean | Enable readiness probe | false |
| app.**readinessProbe**.**httpGet** | {} | Configure httpGet for the readiness probe | - |
| app.**readinessProbe**.**httpGet**.**path** | string | Path of the httpGet | /status |
| app.**readinessProbe**.**httpGet**.**port** | int | Port of the httpGet | 80 |
| app.**readinessProbe**.**initialDelaySeconds** | int | Initial delay for the readiness probe | 10 |
| app.**readinessProbe**.**periodSeconds** | int | Period for the readiness probe | 20 |
| app.**readinessProbe**.**timeoutSeconds** | int | Timeout for the readiness probe | 10 |
| app.**readinessProbe**.**failureThreshold** | int | Number of consecutive failures before the readiness probe is considered failed | 10 |
| app.**readinessProbe**.**successThreshold** | int | Number of consecutive successes before the readiness probe is considered successful | 1 |
| app.**startupProbe** | {} | Configure startup probe for the application container | - |
| app.**startupProbe**.**enabled** | boolean | Enable startup probe | false |
| app.**startupProbe**.**httpGet** | {} | Configure httpGet for the startup probe | - |
| app.**startupProbe**.**httpGet**.**path** | string | Path of the httpGet | /status |
| app.**startupProbe**.**httpGet**.**port** | int | Port of the httpGet | 80 |
| app.**startupProbe**.**initialDelaySeconds** | int | Initial delay for the startup probe | 10 |
| app.**startupProbe**.**periodSeconds** | int | Period for the startup probe | 20 |
| app.**startupProbe**.**timeoutSeconds** | int | Timeout for the startup probe | 10 |
| app.**startupProbe**.**failureThreshold** | int | Number of consecutive failures before the startup probe is considered failed | 10 |
| app.**startupProbe**.**successThreshold** | int | Number of consecutive successes before the startup probe is considered successful | 1 |
| app.**service** | {} | section to define the service behavior | - |
| app.**service**.**type** | string | Type of the service | ClusterIP |
| app.**ingress_enabled** | boolean | Enable ingress | false |
| **ingress** | [] | section to define the ingress behavior. Accepts multiple ingress definitions | - |
| ingress.**enabled** | boolean | Enable ingress | false |
| ingress.**name** | string | Name of the ingress | external |
| ingress.**tls** | [] | section to define the TLS behavior | [] |
| ingress.**host** | string | Host of the ingress | foo.bar.me |
| ingress.**paths** | [] | Paths of the ingress | / |
| ingress.**ingressClassName** | string | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+). No chamges this field if you don't know what you're really doing | alb |
| ingress.**annotations** | {} | Annotations for the ingress | {} |
| ingress.**alb** | {} | section to define the ALB behavior | - |
| ingress.**alb**.**enabled** | boolean | Enable ALB | true |
| ingress.**alb**.**scheme** | string | Scheme of the ALB | internet-facing |
| ingress.**alb**.**protocol** | string | Protocol of the ALB | HTTP |
| ingress.**alb**.**listernPort** | int | Port of the ALB | [{"HTTP": 80}, {"HTTPS": 443}] |
| ingress.**alb**.**groupName** | string | Group name of the ALB | intenernet-facing |

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
