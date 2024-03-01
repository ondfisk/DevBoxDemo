# Dev Box Demo

Basic demo to setup and run [Microsoft Dev Box](https://azure.microsoft.com/en-us/products/dev-box/).

## Setup

Create two new users in your Azure AD:

```powershell
$tenantName = ...
$adelePassword = ...
$alexPassword = ...

az login --tenant "$tenantName.onmicrosoft.com"
az ad user create --display-name "Adele Vance" --password $adelePassword --user-principal-name "adele@$tenantName.onmicrosoft.com"

az ad user create --display-name "Alex Wilber" --password $alexPassword --user-principal-name "alex@$tenantName.onmicrosoft.com"
```

In `main.parameters.json`:

- Add Adele's object id to `devCenterProjectAdministrators`.
- Add Alex's object id to `devCenterDevBoxUsers`.

## Deploy

Pick a supported location using:

```bash
az provider show --name "Microsoft.DevCenter" --query "resourceTypes[?resourceType=='devcenters'].locations"
```

Update `main.bicepparam` and run:

```bash
SUBSCRIPTION=...
LOCATION=...

az account set --subscription $SUBSCRIPTION
az deployment sub create --location $LOCATION --template-file main.bicep --parameters main.bicepparam
```

## View

As a subscription owner, go to <https://portal.azure.com/> to validate deployment.

## Manage

As a *Dev Center Project Administrator*, go to <https://aka.ms/devbox> to manage projects.

## Run

As a *Dev Center Dev Box User*, go to <https://devbox.microsoft.com/> to create and run a Dev Box.
