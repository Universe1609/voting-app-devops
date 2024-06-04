#!/bin/bash

NAMESPACE=argo-cd
RELEASE_NAME=argo

echo " Crea el namespace para argo "
   kubectl create namespace ${NAMESPACE} || true

   echo " Desplegando Argo con Helm "
   helm repo add argo https://argoproj.github.io/argo-helm
   helm repo update
   helm install ${RELEASE_NAME} argo/argo-cd -n ${NAMESPACE} || true

   echo " Esperando a que los Pods esten READY "
   sleep 2m

   echo " Argocd service a Load Balancer "
   kubectl patch svc ${RELEASE_NAME}-argocd-server -n ${NAMESPACE} -p '{"spec": {"type": "LoadBalancer"}}'

   echo "--------------------IP-Externa--------------------"
   sleep 10s

   echo "--------------------Argocd Ex-URL--------------------"
   kubectl get service ${RELEASE_NAME}-argocd-server -n ${NAMESPACE} | awk '{print $4}'

   echo "--------------------ArgoCD UI Password--------------------"
   echo "Username: admin"
   kubectl -n ${NAMESPACE} get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argo-pass.txt