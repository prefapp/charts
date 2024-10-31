# Documentation for argo-workflows-operations Helm Chart

## Overview

The `argo-workflows-operations` Helm chart is designed to manage and automate operations on:
- Azure Kubernetes Service (AKS) clusters
- Virtual Machine Scale Sets (VMSS)

...using Argo Workflows. This chart dynamically generates Kubernetes RoleBindings, Roles, CronWorkflows, and ServiceAccounts based on the features defined in the values file.

## Features

The chart supports the following features:
- `aks-start-stop-cluster`: Start or stop an AKS cluster.
- `vmss-scale-instances`: Scale the number of instances in a VMSS.

## Values File Structure

The values file should define global configurations and a list of features. Each feature should specify the necessary inputs and schedule for the operation.

### Global Configuration

The global configuration should define the following properties:
- `managed_identity`: The managed identity properties for the Azure service principal.
  - `client_id`: The Azure service principal client ID.
  - `tenant_id`: The Azure service principal tenant ID.
- `subscription_id`: The Azure subscription ID.

### Features Configuration

The features configuration should define a list of features. Each feature should specify the following properties:
- `name`: The name of the feature.
- `cron`: The cron schedule for the operation.
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

#### Inputs Configuration for `vmss-scale-instances`

The `vmss-scale-instances` feature should define the following input parameters:
- `resource_group`: The name of the resource group containing the VMSS.
- `vmss_name`: The name of the VMSS.
- `instances`: The number of instances to scale (or descale) the VMSS to.

### Example Values File

```yaml
---
global:
  managed_identity:
    client_id: "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
    tenant_id: "YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY"
  subscription_id: "ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ"

features:
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

  - name: vmss-scale-instances
    cron: "0 0 * * *"
    inputs:
      resource_group: "myResourceGroup"
      vmss_name: "myVMSS"
      instances: 1

  - name: vmss-scale-instances
    cron: "0 0 * * *"
    inputs:
      resource_group: "myResourceGroup"
      vmss_name: "myVMSS"
      instances: 2

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
```

## Usage for developers

If you wish to add a new feature to the chart, you need to follow these steps:

1. Add the feature name to the `features-allowed.yaml` file.
2. Add the feature to the values file with the necessary inputs and schedule.
3. Add the feature-specific logic to the templates.
4. Add the feature-specific logic to the `argo-workflows-operations.rules` template.
5. Add the feature-specific logic to the `argo-workflows-operations.parameters` template.
6. Add the feature-specific logic to the `argo-workflows-operations.workflow` template.
7. Add the feature-specific logic to the `argo-workflows-operations.dynamic-name` template.
8. Add the feature-specific logic to the `argo-workflows-operations.rolebinding` template.
9. Add the feature-specific logic to the `argo-workflows-operations.role` template.
