# Requires: ExchangeOnlineManagement module
# Install: Install-Module ExchangeOnlineManagement -Force
# Run after New-SensitivityLabels.ps1

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$AdminUPN
)

Connect-IPPSSession -UserPrincipalName $AdminUPN

# Policy 1 — Block sharing of Credit Card numbers
New-DlpCompliancePolicy `
    -Name "ASF-Block-Credit-Cards" `
    -Comment "Block sharing of credit card numbers - AZ-500/SC-401" `
    -SharePointLocation All `
    -OneDriveLocation All `
    -ExchangeLocation All `
    -Mode Enable

New-DlpComplianceRule `
    -Name "ASF-Block-Credit-Card-Rule" `
    -Policy "ASF-Block-Credit-Cards" `
    -ContentContainsSensitiveInformation @{
        Name     = "Credit Card Number"
        minCount = "1"
    } `
    -BlockAccess $true `
    -NotifyUser Owner `
    -GenerateAlert $true

# Policy 2 — Block sharing of Highly Confidential labelled files externally
New-DlpCompliancePolicy `
    -Name "ASF-Block-HighlyConfidential-External" `
    -Comment "Block external sharing of Highly Confidential files - SC-401" `
    -SharePointLocation All `
    -OneDriveLocation All `
    -Mode Enable

New-DlpComplianceRule `
    -Name "ASF-Block-HighlyConfidential-Rule" `
    -Policy "ASF-Block-HighlyConfidential-External" `
    -ContentContainsSensitiveInformation @{
        Name     = "ASF - Israel ID Number"
        minCount = "1"
    } `
    -BlockAccess $true `
    -NotifyUser Owner

Write-Host "DLP policies created successfully" -ForegroundColor Green
Get-DlpCompliancePolicy | Where-Object { $_.Name -like "ASF-*" } | Select-Object Name, Mode, Enabled
