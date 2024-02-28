#!/bin/bash
set -e

if [ -z "${AZURE_SUBSCRIPTION}" ]; then
    echo "error no subscription is set" >&2
    exit 1
fi

if [ -z "${AZURE_RESOURCE_GROUP}" ]; then
    echo "error no resource_group is set" >&2
    exit 1
fi


if [ "$(az extension list | jq '.[] | select(.name == "bastion")')" == "" ]; then
    echo "Installing az bastion extension"
    az extension add --name bastion --allow-preview false
fi

az network bastion tunnel \
    --name ${TUNNEL_GATEWAY_HOST} \
    --subscription ${AZURE_SUBSCRIPTION} \
    --resource-group ${AZURE_RESOURCE_GROUP} \
    --target-resource-id "${TUNNEL_TARGET_HOST}" \
    --resource-port ${TUNNEL_TARGET_PORT} \
    --port ${LOCAL_PORT_SSH} &

TUNNEL_PID=$!