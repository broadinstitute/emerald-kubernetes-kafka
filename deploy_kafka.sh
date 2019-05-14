#!/bin/bash
set -e

#env vars
#: ${GOOGLE_CLOUD_PROJECT:?}
#: ${ENVIRONMENT:?}
#only var used is below
: ${GCLOUD_USER:?}

read -p "Do you want to delete the current namespace? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  kubectl get namespace dev 2>/dev/null && kubectl delete namespace dev
  sleep 2
  gcloud --project=broad-dsp-monster-dev compute disks list --filter k8-pvc | grep k8-pvc | awk '{print $1}' | xargs gcloud --project=broad-dsp-monster-dev compute disks delete
fi

#create namespace in k8s
kubectl apply -f 00-namespace.yml

#storage configuration for gcp
kubectl apply -f ./configure

#add your account as cluster admin
if kubectl get clusterrolebinding | grep -q ${GCLOUD_USER}; then
    echo "skipping adding your account as cluster admin"
else
    echo "adding your account to cluster admin"
    kubectl create clusterrolebinding ${GCLOUD_USER}-cluster-admin-binding --clusterrole cluster-admin --user ${GCLOUD_USER}@broadinstitute.org
    kubectl create clusterrolebinding ${GCLOUD_USER}-storage-admin-binding --clusterrole storage-admin --user ${GCLOUD_USER}@broadinstitute.org

fi

#configure podsecuritypolicies
kubectl --namespace=dev apply -f ./configure/psp

#deploy zookeeper
kubectl apply --namespace=dev -f ./zookeeper

#deploy kafka
kubectl apply --namespace=dev -f ./kafka

#expose kafka outside pods and allows readiness check for kafka
kubectl apply --namespace=dev -f ./outside-services
