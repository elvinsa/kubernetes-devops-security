#!/bin/bash

#k8s-deployment.sh

sed -i 's#replace#replace#${imageName}#g' k8s_deployment_service.yaml
kubectl -n default get deployment ${deploymentName} > /dev/null