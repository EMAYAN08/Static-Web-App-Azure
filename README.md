# Static Website Hosting with CI/CD-Automation
> Static Website Hosting on Azure Cloud and CI/CD with Azure DevOps

### 📌Overview
This project is a demonstration of hosting a static website on Azure Cloud by using Azure Blob Storage, Azure CDN for global content delivery, and Azure DevOps to automate the deployment process through a CI/CD pipeline that purges the CDN cache and uploads the latest website content to Azure Storage.

### 🏗️Setup Architecture
![demo](images/az-static-web_demo.png)

### 📋Prerequisites
- *An active Azure Subscription with sufficient permissions.*

- *An App Registration with a Service Principal configured in Microsoft entra ID.*
![app](images/AppReg.png) ![serv principal](images/ServPrinciple.png)

 - *A Service Connection set up in Azure DevOps linked to your Azure Subscription.*
![service connection](images/ServConnection.png)

- *An Azure Blob Storage Account with static website hosting enabled.*
![url page](images/staticwebsite_urlpage.png)

- *An Azure CDN Profile and Endpoint connected to the Storage Account.*
![CDN](images/CDN.png)

- *A Self-hosted Azure DevOps Agent configured and running.*
![agent](images/Agent_VIBI_online.png)




### ⚙️How It Works
- **Push code**  — Developer pushes the latest website code.
- **Trigger Pipeline** — Azure DevOps pulls it and the pipeline gets triggered automatically upon every push.
- **Deploy** — The pipeline deploys the static assets to the Azure Storage Account.
- **Azure CDN** —  pulls the latest content from the Storage Account and serves the website content globally to end users.


### 🪧Demonstration

#### *Pipeline Success*
![pipeline success](images/pipeline_succeeded.png)

#### *Web Interface*
![web](images/webinterface.png)



