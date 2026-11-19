#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="CopilotDevOpsRG"
LOCATION="eastus"
PLAN_NAME="CopilotPlan"
WEB_APP_NAME="copilot-webapp-demo"
SKU="B1"

command -v az >/dev/null 2>&1 || { echo "Azure CLI (az) is required." >&2; exit 1; }
az account show >/dev/null 2>&1 || { echo "Sign in first with 'az login'." >&2; exit 1; }

az group create \
	--name "$RESOURCE_GROUP" \
	--location "$LOCATION" \
	--output none

az appservice plan create \
	--name "$PLAN_NAME" \
	--resource-group "$RESOURCE_GROUP" \
	--location "$LOCATION" \
	--sku "$SKU" \
	--output none

az webapp create \
	--name "$WEB_APP_NAME" \
	--resource-group "$RESOURCE_GROUP" \
	--plan "$PLAN_NAME" \
	--output none

echo "Created resource group '$RESOURCE_GROUP', plan '$PLAN_NAME', and web app '$WEB_APP_NAME'."
