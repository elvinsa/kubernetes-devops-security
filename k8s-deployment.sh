#!/bin/bash

#k8s-deployment.sh

sed -i 's#replace#replace#elvinsa/numeric-app#g' k8s_deployment_service.yaml
kubectl -n default apply -f k8s_deployment_service.yaml