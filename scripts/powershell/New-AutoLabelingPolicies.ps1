# Auto-labeling Policies — automatically apply sensitivity labels based on SIT matches
# Requires: ExchangeOnlineManagement module
# Run after: New-SensitivityLabels.ps1 and New-CustomSITs.ps1

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$AdminUPN
)

Connect-IPPSSession -UserPrincipalName $AdminUPN

# Policy 1 — Auto-label Confidential when Credit Card detected
New-AutoSensitivityLabelPolicy `
    -Name "ASF-AutoLabel-Confidential" `
    -Comment "Auto-apply Confidential label when credit card numbers detected" `
    -ApplySensitivityLabel "Confidential" `
    -SharePointLocation All `
    -OneDriveLocation All `
    -ExchangeLocation All `
    -Mode TestWithoutNotifications

New-AutoSensitivityLabelRule `
    -Name "ASF-AutoLabel-Confidential-Rule" `
    -Policy "ASF-AutoLabel-Confidential" `
    -Workload SharePoint, OneDriveForBusiness, Exchange `
    -ContentContainsSensitiveInformation @(
        @{ Name = "Credit Card Number"; minCount = "1" }
    )

# Policy 2 — Auto-label Highly Confidential when multiple SITs detected
New-AutoSensitivityLabelPolicy `
    -Name "ASF-AutoLabel-HighlyConfidential" `
    -Comment "Auto-apply Highly Confidential label when multiple sensitive types detected" `
    -ApplySensitivityLabel "Highly Confidential" `
    -SharePointLocation All `
    -OneDriveLocation All `
    -Mode TestWithoutNotifications

New-AutoSensitivityLabelRule `
    -Name "ASF-AutoLabel-HighlyConfidential-Rule" `
    -Policy "ASF-AutoLabel-HighlyConfidential" `
    -Workload SharePoint, OneDriveForBusiness, Exchange `
    -ContentContainsSensitiveInformation @(
        @{ Name = "Credit Card Number"; minCount = "1" }
        @{ Name = "ASF - Israel ID Number"; minCount = "1" }
    )

Write-Host "Auto-labeling policies created:" -ForegroundColor Green
Get-AutoSensitivityLabelPolicy | Where-Object { $_.Name -like "ASF-*" } | Select-Object Name, Mode, ApplySensitivityLabel
