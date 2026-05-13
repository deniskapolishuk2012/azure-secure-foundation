# Insider Risk Management — detect risky user behavior patterns
# Requires: ExchangeOnlineManagement module + M365 E5 Compliance license
# Run after: New-SensitivityLabels.ps1

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$AdminUPN
)

Connect-IPPSSession -UserPrincipalName $AdminUPN

# Policy 1 — Data theft by departing users
New-InsiderRiskPolicy `
    -Name "ASF-DataTheft-DepartingUsers" `
    -InsiderRiskScenario LeaksByDepartingUsers `
    -Description "Detect bulk downloads, USB copies, and external sharing by users who are leaving"

# Policy 2 — General data leaks
New-InsiderRiskPolicy `
    -Name "ASF-DataLeaks-General" `
    -InsiderRiskScenario GeneralDataLeaks `
    -Description "Detect unusual data exfiltration patterns across all users"

Write-Host "Insider Risk policies created:" -ForegroundColor Green
Get-InsiderRiskPolicy | Where-Object { $_.Name -like "ASF-*" } | Select-Object Name, InsiderRiskScenario, Enabled
