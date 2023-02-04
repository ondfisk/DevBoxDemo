# Dev Box Demo

Basic demo to setup and run [Microsoft Dev Box](https://azure.microsoft.com/en-us/products/dev-box/).

## Deploy

To deploy demo, update `main.parameters.json` and run:

```bash
SUBSCRIPTION=...
az account set --subscription $SUBSCRIPTION
LOCATION=...
az deployment sub create --location $LOCATION --template-file main.bicep --parameters @main.parameters.json
```

or

```powershell
$Subscription = "..."
az account set --subscription $Subscription
$Location = "..."
az deployment sub create --location $Location --template-file main.bicep --parameters main.parameters.json
```

or

```powershell
$Subscription = "..."
Set-AzContext -Subscription $Subscription
$Location = "..."
New-AzSubscriptionDeployment -Location $Location -TemplateFile .\main.bicep -TemplateParameterFile .\main.parameters.json
```

## View

As a subscription owner, go to <https://portal.azure.com/> to validate deployment.

## Manage

As a *Dev Center Project Administrator*, go to <https://aka.ms/devbox> to manage projects.

## Run

As a *Dev Center Dev Box User*, go to <https://devbox.microsoft.com/> to create and run a Dev Box.
