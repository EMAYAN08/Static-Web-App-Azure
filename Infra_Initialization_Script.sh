#!/bin/bash

RG="static-web-app-RG"
Location="canadaeast"
AccountName="staticwebappstg"
ProfileName="staticwebappcdn"
EndPoint="staticwebappendpoint"

echo "-------------------------------------"
echo "|      Creating Resource Group      |"
echo "-------------------------------------"
az group create \
  --name $RG \
  --location $Location

echo "-------------------------------------"
echo "|  Creating Azure Storage Account   |"
echo "-------------------------------------"
az storage account create \
  --name $AccountName \
  --resource-group $RG \
  --location $Location \
  --sku Standard_LRS \
  --kind StorageV2

echo "-------------------------------------"
echo "|      Enabling Static-Website      |"
echo "-------------------------------------"
az storage blob service-properties update \
  --account-name $AccountName \
  --static-website \
  --index-document "index.html" \
  --404-document "error.html"

echo "-------------------------------------"
echo "|        Creating CDN Profile       |"
echo "-------------------------------------"
az afd profile create \
  --name $ProfileName \
  --resource-group $RG \
  --sku Standard_AzureFrontDoor

echo "-------------------------------------"
echo "|     Uploading Website Files       |"
echo "-------------------------------------"
Connection_String=$(az storage account show-connection-string --name $AccountName --resource-group $RG --query connectionString -o tsv)
az storage blob upload-batch \
  -d '$web' \
  -s . \
  --connection-string $Connection_String \
  --overwrite \
  --pattern "*"

sleep 30  # Wait for upload and propagation

url=$(az storage account show --name $AccountName --resource-group $RG --query "primaryEndpoints.web" -o tsv | sed 's|^https://\([^/]*\)/$|\1|')

echo "-------------------------------------"
echo "|   Creating Origin Group & Origin  |"
echo "-------------------------------------"
az afd origin-group create \
  --profile-name $ProfileName \
  --resource-group $RG \
  --origin-group-name default \
  --sample-size 3 \
  --successful-samples-required 3

az afd origin create \
  --profile-name $ProfileName \
  --resource-group $RG \
  --origin-group-name default \
  --name storage-origin \
  --host-name $url \
  --http-port 80 \
  --https-port 443

echo "-------------------------------------"
echo "|     Creating CDN Endpoint         |"
echo "-------------------------------------"
az afd endpoint create \
  --name $EndPoint \
  --profile-name $ProfileName \
  --resource-group $RG \
  --enabled-state Enabled

echo "-------------------------------------"
echo "|        Creating Route             |"
echo "-------------------------------------"
az afd route create \
  --profile-name $ProfileName \
  --resource-group $RG \
  --endpoint-name $EndPoint \
  --route-name default \
  --origin-group default \
  --domains "afdverify.azurefd.net" \
  --patterns-to-match "/*" \
  --enabled-state Enabled

echo "------------------------------------------------------------------------------------------------------------------------------------------------"
echo "|     Wait for CDN to Configure (5-10 mins). Endpoint: https://$EndPoint.azurefd.net       |"
echo "------------------------------------------------------------------------------------------------------------------------------------------------"