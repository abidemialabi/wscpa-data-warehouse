## Data Connection to AM.NET

## Build & Create Resource

az acr build --registry acrwscpademo --image data:0.0.1 .

az containerapp logs show --name ca-data --resource-group rg-wscpa-demo --tail 30