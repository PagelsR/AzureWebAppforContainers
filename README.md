# AzureWebAppforContainers

## Introduction
Azure Container Apps enables you to run microservices and containerized applications on a serverless platform.  For an indepth overview, be sure to check it out at [Azure Container Apps documentation](https://learn.microsoft.com/en-us/azure/container-apps/)

## Build and Deploy Status
[![Build and Deploy Container](https://github.com/RPagels/AzureWebAppforContainers/actions/workflows/Build%20and%20Deploy%20Container.yml/badge.svg)](https://github.com/RPagels/AzureWebAppforContainers/actions/workflows/Build%20and%20Deploy%20Container.yml)

## Setup Steps
Follow the steps below for detailed instructions on how to run this in your environment.  The Build & Deployment Pipeline version below is intended for a quick setup and requires some familiarity with Azure and pipelines, you know ... the **EASY BUTTON**.

## Step 1 - Setup Resource Group
  - Login to the Azure Portal.
  - Create a resource group (pick a region which allows Containers. At the time of this edit the allowed regions were:
      - northcentralusstage
      - eastus
      - eastus2
      - northeurope
      - canadacentral
  - Copy the the Resource Group name and Region to notepad for use later.
    > Todo! insert a PS command or web url to display the regions in real-time)

## Step 2 - Create a Service Principal
  ### Option A
  #### Create a service principal with access to Resource Group
  - Open the Cloud Shell and run this PowerShell command:
  - > az ad sp create-for-rbac --name "**REPLACE WITH RG NAME**_SP_FullAccess" --role owner --scopes /subscriptions/**REPLACE WITH YOUR SUBSCRIPTION ID**/resourceGroups/**REPLACE WITH YOUR RESOURCE GROUP NAME**

  - Copy the JSON output to notepad for use later.

  ### Option B
  - From the Azure Portal home page, search for **Azure Active Directory**.
  - Click **App registrations**.
  - Click **New registration** and give it a name. (i.e. **AzureWebAppForContainers**)
  - Click **Register**
  - Copy the **Client ID** because you will need it in later steps.
  - Copy the **Tenant ID** because you will need it in later steps.
  - Copy the **Object ID** because you will need it in later steps.
  > Todo! Setup RBAC to resource group for service principal.

  > Todo! Verify these steps are correct.

  ## Step 3 - Edit Bicep file
  - Open /IaC/**main-1.bicep**
  - Edit these two lines with the object id and application id
    - // Object Id of Service Principal (i.e. **AzureWebAppForContainers**)
      - param ADOServiceprincipalObjectId string = '**Object ID**'
         - Note: use **az ad sp list --display-name** "**REPLACE WITH RG NAME**_SP_FullAccess" to find **id**. ()
    - // Application Id of Service Principal for your email alias. (i.e. **"RPagels"**).
      - param AzObjectIdEmailAlias string = '**Application ID**'
        - Note: use **az ad user show --id yourname**@**alias** to find **id**.

## Step 4 - Set Deployment Credentials - Create a GitHub Secret

  - Copy the following to notepad.
```
  {
    "clientId": "GUID",
    "clientSecret": "GUID",
    "subscriptionId": "GUID",
    "tenantId": "GUID"
  }
```

  - Replace the placeholders with your information from above step **Step 2 - Create a Service Principal**.
      - clientId
      - clientSecret
      - subscriptionId
      - tenantId
  - Copy the JSON output to notepad for use later.
  - Create the secret
    - Login to GitHub.
    - Navigate to Repo [**AzureWebAppforContainers**](https://github.com/RPagels/AzureWebAppforContainers)
    - Click on **Code** | Code - **GitHub CLI**
      - i.e. **gh repo clone RPagels/AzureWebAppforContainers**
    - Navigate to cloned repo.
    - Click **Settings** | **Secrets** | **Actions**.
    - Click on **New resository secret**.
    - In the name box, enter **AZURE_CREDENTIALS**.
    - For Secret, enter the JSON output from notepad.

```
        {
          "clientId": "**YOURGUID**",
          "clientSecret": "**YOURGUID**",
          "subscriptionId": "**YOURGUID**",
          "tenantId": "**YOURGUID**"
        }
```

  - Click **Add secret**

  > Todo! Verify these steps are correct.
  
> This is a JSON object with the role assignment credentials that provide access to your Azure Resource Group used by GitHub pipelines.

## Step 4 - Set Build & Deployment Pipeline

- This example uses Biep for Infrastructure as Code to deploy pipeline, Managed Identity is used for Azure Services and will have a unique name based on resource group name.

  - Edit /.github/workflows/**Build and Deploy Container.yml**.
  - Change **Azure_Resource_GroupName** to Azure Resource Group created in above step **Step 1 - Setup Resource Group**.
  - Change **Azure_Resource_GroupLocation** to Azure Region creted in above step **Step 1 - Setup Resource Group**.
  - **Commit Changes**.

  > This will automaticly start the pipeline.
