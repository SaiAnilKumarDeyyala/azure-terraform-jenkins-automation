pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS = 'Azure-jenkins-sp'
        TF_STATE_RG = 'jenkins-rg' 
        TF_STATE_STORAGE = 'tfstate-storage'
        TF_STATE_CONTAINER = 'tfstate' 
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/SaiAnilKumarDeyyala/azure-terraform-jenkins-automation.git' 
            }
        }

        stage('Deploy Terraform State Storage (First Run Only)') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS, subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID', clientIdVariable: 'AZURE_CLIENT_ID', clientSecretVariable: 'AZURE_CLIENT_SECRET', tenantIdVariable: 'AZURE_TENANT_ID')]) {
                    script {
                        // Ensure login is done using the service principal
                        sh '''
                            az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                        '''

                        // Check if the storage account exists
                        def storageAccountExists = sh(script: "az storage account show --name $TF_STATE_STORAGE --resource-group $TF_STATE_RG --query id -o tsv", returnStdout: true).trim()
                        
                        if (!storageAccountExists) {
                            echo "Creating new storage account for Terraform state."
                            // Create resource group, storage account, and container for Terraform state
                            sh '''
                                az group create --name $TF_STATE_RG --location eastus || true
                                az storage account create --name $TF_STATE_STORAGE --resource-group $TF_STATE_RG --sku Standard_LRS
                                az storage container create --name $TF_STATE_CONTAINER --account-name $TF_STATE_STORAGE --account-key $(az storage account keys list --account-name $TF_STATE_STORAGE --resource-group $TF_STATE_RG --query "[0].value" -o tsv)
                            '''
                        } else {
                            echo "Terraform state storage already exists. Skipping creation."
                        }
                    }
                }
            }
        }


        stage('Terraform Validate and Format') {
            steps {
                sh 'terraform fmt -check=true'
                sh 'terraform validate'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS, subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID', clientIdVariable: 'AZURE_CLIENT_ID', clientSecretVariable: 'AZURE_CLIENT_SECRET', tenantIdVariable: 'AZURE_TENANT_ID')]) {
                    sh '''
                        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                        terraform init -backend-config="resource_group_name=$TF_STATE_RG" -backend-config="storage_account_name=$TF_STATE_STORAGE" -backend-config="container_name=$TF_STATE_CONTAINER" -backend-config="key=terraform.tfstate"
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS, subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID', clientIdVariable: 'AZURE_CLIENT_ID', clientSecretVariable: 'AZURE_CLIENT_SECRET', tenantIdVariable: 'AZURE_TENANT_ID')]) {
                    sh '''
                        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                        terraform plan -out=tfplan
                    '''
                }
                archiveArtifacts artifacts: 'tfplan'
            }
        }

        stage('Manual Approval') {
            steps {
                input message: 'Approve Terraform Plan?'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS, subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID', clientIdVariable: 'AZURE_CLIENT_ID', clientSecretVariable: 'AZURE_CLIENT_SECRET', tenantIdVariable: 'AZURE_TENANT_ID')]) {
                    sh '''
                        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                        terraform apply tfplan
                    '''
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                branch 'destroy' // Only runs on the 'destroy' branch
            }
            steps {
                withCredentials([azureServicePrincipal(credentialsId: AZURE_CREDENTIALS, subscriptionIdVariable: 'AZURE_SUBSCRIPTION_ID', clientIdVariable: 'AZURE_CLIENT_ID', clientSecretVariable: 'AZURE_CLIENT_SECRET', tenantIdVariable: 'AZURE_TENANT_ID')]) {
                    sh '''
                        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                        terraform destroy -auto-approve
                    '''
                }
            }
        }
    }
}