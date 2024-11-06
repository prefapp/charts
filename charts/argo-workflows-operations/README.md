# Documentation for argo-workflows-operations Helm Chart

## Overview

The `argo-workflows-operations` Helm chart is designed to manage and automate operations on:
- Azure Kubernetes Service (AKS) clusters
- Virtual Machine Scale Sets (VMSS)
- Flexible Servers in Azure Database for PostgreSQL
- MongoDB Atlas clusters

...using Argo Workflows. This chart dynamically generates Kubernetes RoleBindings, Roles, CronWorkflows, and ServiceAccounts based on the operations defined in the values file.

## Operations

The chart supports the following operations:
- `aks-start-stop-cluster`: Start or stop an AKS cluster.
- `vmss-scale-instances_count`: Scale the number of instances_count in a VMSS.
- `flexible-server-start-stop-postgresql`: Start or stop a Flexible Server in Azure Database for PostgreSQL.
- `mongodb-atlas-start-pause-cluster`: Start or pause a MongoDB Atlas cluster.

## Values File Structure

The values file should define global configurations and a list of operations. Each feature should specify the necessary inputs and schedule for the operation.

### Global Configuration

The global configuration should define the following properties:
- `managed_identity`: The managed identity properties for the Azure service principal.
  - `client_id`: The Azure service principal client ID.
  - `tenant_id`: The Azure service principal tenant ID.
- `subscription_id`: The Azure subscription ID.
- `timezone`: The timezone for the cron schedule.

### Features Configuration

The operations configuration should define a list of operations. Each feature should specify the following properties:

- `name`: The name of the feature.
- `cron`: The cron schedule for the operation.
- `timezone` (optional, replaces the global configuration): The timezone for the cron schedule.
- `managed_identity` (optional, replaces the global configuration): The managed identity properties for the Azure service principal.
  - `client_id`: The Azure service principal client ID.
  - `tenant_id`: The Azure service principal tenant ID.
- `subscription_id` (optional, replaces the global configuration): The Azure subscription ID.
- `inputs`: The input parameters for the operation.

#### Inputs Configuration for `aks-start-stop-cluster`

The `aks-start-stop-cluster` feature should define the following input parameters:
- `resource_group`: The name of the resource group containing the AKS cluster.
- `cluster_name`: The name of the AKS cluster.
- `action`: The action to perform on the AKS cluster (`start` or `stop`).

#### Inputs Configuration for `vmss-scale-instances_count`

The `vmss-scale-instances_count` feature should define the following input parameters:
- `resource_group`: The name of the resource group containing the VMSS.
- `vmss_name`: The name of the VMSS.
- `instances_count`: The number of instances_count to scale (or descale) the VMSS to.


#### Inputs Configuration for `flexible-server-start-stop-postgresql`

The `flexible-server-start-stop-postgresql` feature should define the following input parameters:
- `resource_group`: The name of the resource group containing the Flexible Server.
- `server_name`: The name of the Flexible Server.
- `action`: The action to perform on the Flexible Server (`start` or `stop`).

#### Inputs Configuration for `mongodb-atlas-start-pause-cluster`

The `mongodb-atlas-start-pause-cluster` feature should define the following input parameters:
- `secret_namespace`: The namespace of the Kubernetes secret containing the MongoDB Atlas (public and private) API key.
- `secret_name`: The name of the Kubernetes secret containing the MongoDB Atlas (public and private) API key.
- `organization_id`: The organization ID of the MongoDB Atlas project.
- `project_id`: The project ID of the MongoDB Atlas project.
- `cluster_name`: The name of the MongoDB Atlas cluster.
- `action`: The action to perform on the MongoDB Atlas cluster (`start` or `pause`).

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
    cron: "0 0 * * *"
    inputs:
      resource_group: "myResourceGroup"
      cluster_name: "myAKSCluster"
      action: "start"

  - name: aks-start-stop-cluster
    cron: "0 0 * * *"
    inputs:
      resource_group: "myResourceGroup"
      cluster_name: "myAKSCluster"
      action: "stop"

  - name: vmss-scale-instances_count
    cron: "0 0 * * *"
    timezone: "Europe/Paris"
    inputs:
      resource_group: "myResourceGroup"
      vmss_name: "myVMSS"
      instances_count: 1

  - name: vmss-scale-instances_count
    cron: "0 0 * * *"
    inputs:
      resource_group: "myResourceGroup"
      vmss_name: "myVMSS"
      instances_count: 2

  - name: aks-start-stop-cluster
    cron: "0 0 * * *"
    subscription_id: "00000000-0000-0000-0000-000000000000"
    managed_identity:
      client_id: "00000000-0000-0000-0000-000000000000"
      tenant_id: "00000000-0000-0000-0000-000000000000"
    inputs:
      resource_group: "myResourceGroup"
      cluster_name: "myAKSCluster"
      action: "start"

  - name: flexible-server-start-stop-postgresql
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
      project_id: "myProjectId"
      cluster_name: "myClusterName"
      action: "start"
```

## Usage for developers

If you wish to add a new feature to the chart, you need to follow these steps:

1. Add the feature name to the `operations-allowed.yaml` into values.yaml file.
2. Add the feature to the values file with the necessary inputs and schedule.
3. Add the feature-specific logic to the templates.
4. Add the feature-specific logic to the `argo-workflows-operations.dynamic-name` template.
5. Add the feature-specific logic to the `argo-workflows-operations.role` template.
6. Add the feature-specific logic to the `argo-workflows-operations.rules` template.
7. Add the feature-specific logic to the `argo-workflows-operations.parameters` template.
8. Add the feature-specific logic to the `argo-workflows-operations.workflow` template.
