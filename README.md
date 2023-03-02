# Dev Box Demo

Basic demo to setup and run [Microsoft Dev Box](https://azure.microsoft.com/en-us/products/dev-box/).

## Setup

Create two new users in your Azure AD:

```bash
TENANT=...
ADELE_PASSWORD=...
ALEX_PASSWORD=...

az ad user create --display-name "Adele Vance" --password $ADELE_PASSWORD --user-principal-name "adele@$TENANT.onmicrosoft.com"

az ad user create --display-name "Alex Wilber" --password $ALEX_PASSWORD --user-principal-name "alex@$TENANT.onmicrosoft.com"
```

In `main.parameters.json`:

- Add Adele's object id to `devCenterProjectAdministrators`.
- Add Alex's object id to `devCenterDevBoxUsers`.

## Deploy

To deploy demo, update `main.parameters.json` and run:

```bash
SUBSCRIPTION=...
az account set --subscription $SUBSCRIPTION
LOCATION=...
az deployment sub create --location $LOCATION --template-file main.bicep --parameters @main.parameters.json
```

## View

As a subscription owner, go to <https://portal.azure.com/> to validate deployment.

## Manage

As a *Dev Center Project Administrator*, go to <https://aka.ms/devbox> to manage projects.

## Run

As a *Dev Center Dev Box User*, go to <https://devbox.microsoft.com/> to create and run a Dev Box.
