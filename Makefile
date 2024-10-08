LOCATION='westeurope'
RESOURCE_GROUP_NAME = 'rg-makefile-ms-course-2'
WORKSPACE_NAME = 'mlws-makefile-ms-course'
SERVICE_PRINCIPAL_NAME = 'sp-ms-course'
SUBSCRIPTION_ID = 'cf8cebc1-45e2-4a8e-a4ec-b01521fed8e3'

all: resourcegroup workspace instance job
delete: resourcegroup-delete

login:
	az login

resourcegroup:
	az group create \
		--location ${LOCATION} \
		--name ${RESOURCE_GROUP_NAME}

resourcegroup-delete:
	az group delete \
		--name ${RESOURCE_GROUP_NAME}

workspace:
	az ml workspace create \
		--resource-group ${RESOURCE_GROUP_NAME} \
		--location ${LOCATION} \
		--name ${WORKSPACE_NAME}

# instance:
# 	az ml compute create \
# 		--file configuration/compute-instance-config.yml \
# 		--resource-group ${RESOURCE_GROUP_NAME} \
# 		--workspace-name ${WORKSPACE_NAME} \
# 		--location ${LOCATION} \
# 		--name custom-aml-instance

cluster: # For github a cluster is needed.
	az ml compute create \
		--file configuration/compute-cluster-config.yml \
		--resource-group ${RESOURCE_GROUP_NAME} \
		--workspace-name ${WORKSPACE_NAME} \
		--location ${LOCATION} \
		--name custom-aml-cluster

job:
	az ml job create \
		--file src/job.yml \
		--resource-group ${RESOURCE_GROUP_NAME} \
		--workspace-name ${WORKSPACE_NAME}

create-service-principal:
	az ad sp create-for-rbac \
		--name ${SERVICE_PRINCIPAL_NAME} \
		--role contributor \
		--scopes /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME} \
        --sdk-auth