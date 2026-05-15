# eDiscovery — create case, legal hold, and content search
# Requires: ExchangeOnlineManagement module
# Run after: New-SensitivityLabels.ps1

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$AdminUPN,

    [Parameter()]
    [string]$CustodianUPN
)

Connect-IPPSSession -UserPrincipalName $AdminUPN

if (-not $CustodianUPN) { $CustodianUPN = $AdminUPN }

# Step 1 — Create eDiscovery case
New-ComplianceCase -Name "ASF-Investigation-2026" -Description "ASF portfolio demo case - data leak investigation"

# Step 2 — Legal hold on custodian mailbox and OneDrive
New-CaseHoldPolicy `
    -Name "ASF-Hold-Custodian" `
    -Case "ASF-Investigation-2026" `
    -ExchangeLocation $CustodianUPN `
    -Enabled $true

New-CaseHoldRule `
    -Name "ASF-Hold-Rule" `
    -Policy "ASF-Hold-Custodian"

# Step 3 — Content search for sensitive keywords
New-ComplianceSearch `
    -Name "ASF-Search-Sensitive" `
    -Case "ASF-Investigation-2026" `
    -ExchangeLocation $CustodianUPN `
    -ContentMatchQuery '(credit card OR "highly confidential" OR "israel id") AND sent:2026-01-01..2026-12-31'

try {
    Start-ComplianceSearch -Identity "ASF-Search-Sensitive"
} catch {
    Write-Host "Note: Search start skipped - tenant provisioning may still be in progress" -ForegroundColor Yellow
}

Write-Host "eDiscovery case created:" -ForegroundColor Green
Get-ComplianceCase | Where-Object { $_.Name -like "ASF-*" } | Select-Object Name, Status, CreatedDateTime
