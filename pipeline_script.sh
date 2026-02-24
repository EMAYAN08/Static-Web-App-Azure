#!/bin/bash

AccountName="staticwebappstg"
RG="static-web-app-rg"
ProfileName="staticwebappcdn"
EndPoint="staticwebappendpoint"

echo "--------------------------------------------------------"
echo "|   Removing previous content from CDN edge locations  |"
echo "--------------------------------------------------------"

az afd endpoint purge \
      --name $EndPoint \
      --profile-name $ProfileName \
      --resource-group $RG \
      --content-paths "/*"


echo "--------------------------------------------------------"
echo "|           Uploading to Azure Storage Account         |"
echo "--------------------------------------------------------"

Connection_String=$(az storage account show-connection-string --name $AccountName --resource-group $RG --query connectionString -o tsv)
az storage blob upload-batch \
  -d "\$web" \
  -s "website" \
  --connection-string $Connection_String \
  --overwrite \
  --pattern "*"
