#!/bin/bash

#AWS ECR Login

#VARIABLES:
REGION=us-east-2
ACCOUNTID=844646036290
NAMESPACE="three-tier"


echo "AWS ECR Login"
if ! aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNTID}.dkr.ecr.${REGION}.amazonaws.com; then
  echo "Failed to login to AWS ECR"
  exit 1
fi
echo "Successfully logged in AWS ECR"

echo "Comprobando si existe el namespace ${NAMESPACE}"
if kubectl get namespace ${NAMESPACE} > /dev/null 2>&1; then
    echo "Namespace ${NAMESPACE} ya existe"
else
    echo "Creando Kubernetes namespace: ${NAMESPACE}"
    kubectl create namespace ${NAMESPACE} || {
        echo "Error: Fallo al crear el namespace ${NAMESPACE}"
        exit 1
        }
    echo "Namespace ${NAMESPACE} creado exitosamente"
fi

echo "Creando secret para conexión con AWS ECR"
kubectl create secret generic ecr-registry-secret \
    --from-file=.dockerconfigjson="${HOME}/.docker/config.json" \
    --type=kubernetes.io/dockerconfigjson --namespace ${NAMESPACE} || {
        echo "Error: Fallo al crear el secret"
        exit 1
        }
echo "Secret creado exitosamente"

#Mostrando los secretos en el namespace
echo "secrets en el namespace ${NAMESPACE}"
kubectl get secrets -n ${NAMESPACE}