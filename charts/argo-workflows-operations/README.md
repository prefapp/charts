# Documentation for argo-workflows-operations Helm Chart

## Overview

The `argo-workflows-operations` Helm chart is designed to manage and automate operations on:
- Azure Kubernetes Service (AKS) clusters
- Virtual Machine Scale Sets (VMSS)
- Flexible Servers in Azure Database for PostgreSQL
- MongoDB Atlas clusters

...using Argo Workflows. This chart dynamically generates Kubernetes RoleBindings, Roles, CronWorkflows, and ServiceAccounts based on the operations defined in the values file.

## Presumptions

- The chart will be installed in a Kubernetes cluster that has Argo Workflows installed.
- When an operation has the `managed_identity` field set to `true`, it is assumed that the service account for the operation has permissions to perform the operation on the Azure resource. This configuration will make the service account use the managed identity defined in the global configuration by setting the `subject` field of the service account to the managed identity.
- The necessary secrets exist from which the credentials required to perform the operations can be obtained, as specified below for each case.
- The Slack notification will be sent for all specified operations except itself, and this message will be the set of operations that have been performed in the same instantiation block of the chart. It will be sent to a Slack channel (webhook) specified in a secret.

## Operations

The chart supports the following operations:
- `aks-start-stop-cluster`: Start or stop an AKS cluster.
- `vmss-scale-instances`: Scale the number of instances in a VMSS.
- `flexible-server-start-stop-postgresql`: Start or stop a Flexible Server in Azure Database for PostgreSQL.
- `mongodb-atlas-start-pause-cluster`: Start or pause a MongoDB Atlas cluster.
- `datadog-unmute-mute-monitors`: Unmute or mute Datadog monitors.
- `uptimerobot-resume-pause-monitors`: Resume or pause UptimeRobot monitors.
- `slack-notification`: Send a notification to a Slack channel.
- `apply-patches-system-services-aks-to-datadog`: Apply patches to system services in AKS to send logs to Datadog.
- `aks-upgrade-upgrade`: Upgrade an AKS cluster.

## Values File Structure

The values file should define global configurations and a list of operations. Each operation should specify the necessary inputs and schedule for the operation.

### Global Configuration

The global configuration should define the following properties:
- `managed_identity`: The managed identity properties for the Azure service principal.
  - `client_id`: The Azure service principal client ID.
  - `tenant_id`: The Azure service principal tenant ID.
- `subscription_id`: The Azure subscription ID.
- `timezone`: The timezone for the cron schedule.
- `suspend`: If true, the operations will not be executed.

### Features Configuration

The operations configuration should define a list of operations. Each operation should specify the following properties:

- `name`: The name of the operation.
- `cron`: The cron schedule for the operation.
- `timezone` (optional, replaces the global configuration): The timezone for the cron schedule.
- `managed_identity` If true, the operation will use the managed identity defined in the global configuration and set de subject of the service account to the managed identity.
- `subscription_id` (optional, replaces the global configuration): The Azure subscription ID.
- `inputs`: The input parameters for the operation.

#### Inputs Configuration for `aks-start-stop-cluster`

The `aks-start-stop-cluster` operation should define the following input parameters:
- `resource_group`: The name of the resource group containing the AKS cluster.
- `cluster_name`: The name of the AKS cluster.
- `action`: The action to perform on the AKS cluster (`start` or `stop`).

#### Inputs Configuration for `vmss-scale-instances`

The `vmss-scale-instances` operation should define the following input parameters:
- `resource_group`: The name of the resource group containing the VMSS.
- `vmss_name`: The name of the VMSS.
- `instances`: The number of instances to scale (or descale) the VMSS to.

#### Inputs Configuration for `flexible-server-start-stop-postgresql`

The `flexible-server-start-stop-postgresql` operation should define the following input parameters:
- `resource_group`: The name of the resource group containing the Flexible Server.
- `server_name`: The name of the Flexible Server.
- `action`: The action to perform on the Flexible Server (`start` or `stop`).

#### Inputs Configuration for `mongodb-atlas-start-pause-cluster`

The `mongodb-atlas-start-pause-cluster` operation should define the following input parameters:
- `secret_namespace`: The namespace of the Kubernetes secret containing the MongoDB Atlas (public and private) API key.
- `secret_name`: The name of the Kubernetes secret containing the MongoDB Atlas (public and private) API key. `private_key` and `public_key` are the keys in the secret.
- `organization_id`: The organization ID of the MongoDB Atlas project.
- `project_id`: The project ID of the MongoDB Atlas project.
- `cluster_name`: The name of the MongoDB Atlas cluster.
- `action`: The action to perform on the MongoDB Atlas cluster (`start` or `pause`).

#### Inputs Configuration for `datadog-unmute-mute-monitors`

The `datadog-unmute-mute-monitors` operation should define the following input parameters:
- `secret_namespace`: The namespace of the Kubernetes secret containing the Datadog API key and APPLICATION_KEY.
- `secret_name`: The name of the Kubernetes secret containing the Datadog API key and APPLICATION_KEY. `apikey` and `appkey` are the keys in the secret.
- `monitor_ids`: The list of monitor IDs to unmute or mute.
- `action`: The action to perform on the Datadog monitors (`unmute` or `mute`).

#### Inputs Configuration for `uptimerobot-resume-pause-monitors`

The `uptimerobot-resume-pause-monitors` operation should define the following input parameters:
- `secret_namespace`: The namespace of the Kubernetes secret containing the UptimeRobot API key.
- `secret_name`: The name of the Kubernetes secret containing the UptimeRobot API key. `apikey` is the key in the secret.
- `monitor_ids`: The list of monitor IDs to resume or pause.
- `action`: The action to perform on the UptimeRobot monitors (`resume` or `pause`).


#### Inputs Configuration for `slack-notification`

The `slack-notification` operation should define the following input parameters:
- `secret_namespace`: The namespace of the Kubernetes secret containing the Slack webhook URL.
- `secret_name`: The name of the Kubernetes secret containing the Slack webhook URL. `webhook` is the key in the secret.
- `operations`: The list of operations to notify for:
  - `aks`: `aks-<env>-<cluster_name>-<action>`
  - `flexible`: `flexible-<env>-<server_name>-<action>`
  - `vmss`: `vmss-<env>-<vmss_name>-<action>`
  - `mongodb`: `mongodb-<env>-<project_id[4 digits]>-<cluster_name>-<action>`
  - `datadog`: `datadog-<namespace>-<action>`
  - `uptimerobot`: `uptimerobot-<namespace>-<action>`

### Inputs Configuration for `apply-patches-system-services-aks-to-datadog`

The `apply-patches-system-services-aks-to-datadog` operation should define the following input parameters:
- `resource_group`: The name of the resource group containing the AKS cluster.
- `cluster_name`: The name of the AKS cluster.

### Inputs Configuration for `aks-upgrade-upgrade`

The `aks-upgrade-upgrade` operation should define the following input parameters:
- `resource_group`: The name of the resource group containing the AKS cluster.
- `cluster_name`: The name of the AKS cluster.
- `event`: The event to perform on the AKS cluster (`update_image` or `upgrade_version`). `update_image` will update the image of the all the nodes in the cluster, and `upgrade_version` will upgrade the version of the cluster (control plane and nodes).
- `kubernetes_version`: The version of the Kubernetes cluster to upgrade to. This field is required if the `event` is `upgrade_version`.

### Example Values File

```yaml
---
global:
  managed_identity:
    client_id: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    tenant_id: "YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY"
  subscription_id: "ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ"
  timezone: "America/New_York"

operations:
  - name: aks-start-stop-cluster
    managed_identity: true
    cron: "0 0 * * *"
    inputs:
      resource_group: "myResourceGroup"
      cluster_name: "myAKSCluster"
      action: "start"

  - name: aks-start-stop-cluster
    managed_identity: true
    cron: "0 0 * * *"
    inputs:
      resource_group: "myResourceGroup"
      cluster_name: "myAKSCluster"
      action: "stop"

  - name: aks-upgrade-update
    managed_identity: true
    cron: "00 19 * * 1-5"
    inputs:
      resource_group: "group1"
      cluster_name: "cluster1"
      event: "upgrade_version"
      kubernetes_version: "1.2.3"

  - name: aks-upgrade-update
    managed_identity: true
    cron: "00 07 * * 1-5"
    inputs:
      resource_group: "group1"
      cluster_name: "cluster1"
      event: "update_image"

  - name: vmss-scale-instances
    managed_identity: true
    cron: "0 0 * * *"
    timezone: "Europe/Paris"
    inputs:
      resource_group: "myResourceGroup"
      vmss_name: "myVMSS"
      instances: 1

  - name: vmss-scale-instances
    managed_identity: true
    cron: "0 0 * * *"
    inputs:
      resource_group: "myResourceGroup"
      vmss_name: "myVMSS"
      instances: 2

  - name: aks-start-stop-cluster
    managed_identity: true
    cron: "0 0 * * *"
    inputs:
      resource_group: "myResourceGroup"
      cluster_name: "myAKSCluster"
      action: "start"

  - name: flexible-server-start-stop-postgresql
    managed_identity: true
    cron: "0 0 * * *"
    inputs:
      resource_group: "myResourceGroup"
      server_name: "myFlexibleServer"
      action: "start"

  - name: mongodb-atlas-start-pause-cluster
    cron: "0 0 * * *"
    inputs:
      secret_namespace: "myNamespace"
      secret_name: "mySecretName"
      organization_id: "myOrganizationId"
      project_id: "0123456789"
      cluster_name: "myClusterName"
      action: "start"

  - name: datadog-unmute-mute-monitors
    cron: "0 0 * * *"
    inputs:
      secret_namespace: "myNamespace"
      secret_name: "mySecretName"
      monitor_ids:
        - "19376544"
        - "19376545"
        - "18297988"
        - "16401040"
        - "19376546"
        - "19376547"
        - "18297286"
        - "18297988"
        - "18297285"
      action: unmute

  - name: uptimerobot-resume-pause-monitors
    cron: "0 0 * * *"
    inputs:
      secret_namespace: "myNamespace"
      secret_name: "mySecretName"
      monitor_ids:
        - "796707129"
        - "796707139"
        - "796707089"
        - "796707082"
      action: resume

  - name: slack-notification
    cron: "0 0 * * *"
    inputs:
      secret_namespace: "myNamespace"
      secret_name: "mySecretName"
      operations:
        - "aks-predev-myAKSCluster-start"
        - "flexible-predev-myFlexibleServer-start"
        - "flexible-predev-myFlexibleServer-stop"
        - "vmss-predev-myVMSS-1"
        - "mongodb-predev-0123-myClusterName-start"
        - "datadog-tenant-test-predev-unmute"
        - "uptimerobot-tenant-test-predev-resume"

  - name: apply-patches-system-services-aks-to-datadog
    managed_identity: true
    cron: "0 0 * * 6"
    inputs:
      resource_group: "myResourceGroup"
      cluster_name: "myAKSCluster"
```

## Usage for developers

If you wish to add a new operation to the chart, you need to follow these steps:

1. Add the operation name to the `operations-allowed.yaml` into values.yaml file.
2. Add the operation to the values file with the necessary inputs and schedule.
3. Add the operation-specific logic to the templates.
4. Add the operation-specific logic to the `argo-workflows-operations.dynamic-name` template.
5. Add the operation-specific logic to the `argo-workflows-operations.role` template.
6. Add the operation-specific logic to the `argo-workflows-operations.rules` template.
7. Add the operation-specific logic to the `argo-workflows-operations.parameters` template.
8. Add the operation-specific logic to the `argo-workflows-operations.workflow` template.
