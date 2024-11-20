# Dev Box Demo

Basic demo to setup and run [Microsoft Dev Box](https://azure.microsoft.com/en-us/products/dev-box/).

## Setup

Create users and optionally project admins in Entra ID.

Pick a supported location using:

```bash
az provider show --name "Microsoft.DevCenter" --query "resourceTypes[?resourceType=='devcenters'].locations"
```

Update [`main.bicepparam`](./main.bicepparam) and run:

```bash
SUBSCRIPTION=...
LOCATION=...
RESOURCE_GROUP="DevCenter"

az account set --subscription $SUBSCRIPTION
az group create --name $RESOURCE_GROUP --location $LOCATION
az deployment group create --resource-group $RESOURCE_GROUP --template-file main.bicep --parameters main.bicepparam
```

## View

As a subscription owner, go to <https://portal.azure.com/> to validate deployment.

## Manage

As a *Dev Center Project Administrator*, go to <https://portal.azure.com/> to manage your projects.

## Run

As a *Dev Center Dev Box User*, go to <https://devbox.microsoft.com/> to create and run a Dev Box.
