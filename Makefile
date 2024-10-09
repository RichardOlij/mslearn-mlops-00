LOCATION='westeurope'
RESOURCE_GROUP_NAME = 'rg-makefile-ms-course-4'
WORKSPACE_NAME = 'mlws-makefile-ms-course'
SERVICE_PRINCIPAL_NAME_EXPERIMENT = 'sp-ms-course-exp'
SERVICE_PRINCIPAL_NAME_PRODUCTION = 'sp-ms-course-prod'
SUBSCRIPTION_ID = 'cf8cebc1-45e2-4a8e-a4ec-b01521fed8e3'

all: resourcegroup workspace cluster create-service-principals
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

create-service-principals:
	az ad sp create-for-rbac \
		--name ${SERVICE_PRINCIPAL_NAME_EXPERIMENT} \
		--role contributor \
		--scopes /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME} \
        --sdk-auth
	az ad sp create-for-rbac \
		--name ${SERVICE_PRINCIPAL_NAME_PRODUCTION} \
		--role contributor \
		--scopes /subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP_NAME} \
        --sdk-auth

# job:
# 	az ml job create \
# 		--file src/job.yml \
# 		--resource-group ${RESOURCE_GROUP_NAME} \
# 		--workspace-name ${WORKSPACE_NAME}
job-experiment:
	az ml job create \
		--stream \
		--file src/job_experiment.yml \
		--resource-group ${RESOURCE_GROUP_NAME} \
		--workspace-name ${WORKSPACE_NAME}
job-production:
	az ml job create \
		--stream \
		--file src/job_production.yml \
		--resource-group ${RESOURCE_GROUP_NAME} \
		--workspace-name ${WORKSPACE_NAME}
