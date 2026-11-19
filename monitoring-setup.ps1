<#
.SYNOPSIS
Creates a Log Analytics workspace and Azure Monitor CPU alerts for Azure VMs.
.NOTES
Requires the Az.Accounts, Az.Resources, Az.OperationalInsights, and Az.Monitor modules.
#>
[CmdletBinding()]
param(
	[Parameter(Mandatory)]
	[string]$ResourceGroupName,

	[Parameter(Mandatory)]
	[string]$Location,

	[Parameter(Mandatory)]
	[string[]]$VirtualMachineResourceId,

	[string]$WorkspaceName = "$ResourceGroupName-monitoring",
	[string[]]$ActionGroupId = @(),
	[ValidateRange(1, 100)]
	[double]$CpuThreshold = 80,
	[ValidateRange(0, 4)]
	[int]$Severity = 2
)

$ErrorActionPreference = 'Stop'

foreach ($module in 'Az.Accounts', 'Az.Resources', 'Az.OperationalInsights', 'Az.Monitor') {
	if (-not (Get-Module -ListAvailable -Name $module)) {
		throw "Required module '$module' is missing. Install it with Install-Module $module -Scope CurrentUser."
	}
	Import-Module $module -ErrorAction Stop
}

if (-not (Get-AzContext)) {
	Connect-AzAccount | Out-Null
}

$null = Get-AzResourceGroup -Name $ResourceGroupName
$workspace = Get-AzOperationalInsightsWorkspace `
	-ResourceGroupName $ResourceGroupName -Name $WorkspaceName -ErrorAction SilentlyContinue
if (-not $workspace) {
	$workspace = New-AzOperationalInsightsWorkspace `
		-ResourceGroupName $ResourceGroupName `
		-Name $WorkspaceName `
		-Location $Location `
		-Sku 'PerGB2018' `
		-RetentionInDays 30
}

foreach ($vmId in $VirtualMachineResourceId) {
	$vm = Get-AzResource -ResourceId $vmId
	if ($vm.ResourceType -ne 'Microsoft.Compute/virtualMachines') {
		throw "Resource is not an Azure virtual machine: $vmId"
	}

	$criteria = New-AzMetricAlertRuleV2Criteria `
		-MetricName 'Percentage CPU' `
		-MetricNamespace 'Microsoft.Compute/virtualMachines' `
		-TimeAggregation Average `
		-Operator GreaterThan `
		-Threshold $CpuThreshold

	$parameters = @{
		Name                 = "cpu-high-$($vm.Name)"
		ResourceGroupName    = $ResourceGroupName
		TargetResourceId     = $vm.ResourceId
		TargetResourceType   = 'Microsoft.Compute/virtualMachines'
		TargetResourceRegion = $vm.Location
		WindowSize           = New-TimeSpan -Minutes 5
		Frequency            = New-TimeSpan -Minutes 1
		Condition            = $criteria
		Severity             = $Severity
		Description          = "Average VM CPU exceeds $CpuThreshold percent for five minutes."
		Enabled              = $true
	}
	if ($ActionGroupId.Count -gt 0) {
		$parameters.ActionGroupId = $ActionGroupId
	}

	New-AzMetricAlertRuleV2 @parameters | Out-Null
	Write-Output "Configured CPU alert for $($vm.Name)."
}

Write-Output "Monitoring workspace '$($workspace.Name)' is ready."
