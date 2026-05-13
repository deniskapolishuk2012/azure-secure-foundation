# Sensitive Information Types (SIT) — custom patterns for ASF project
# Requires: ExchangeOnlineManagement module
# Run after: New-SensitivityLabels.ps1

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$AdminUPN
)

Connect-IPPSSession -UserPrincipalName $AdminUPN

# SIT 1 — Israel ID Number (9 digits with Luhn-like checksum)
$israelIdPattern = @"
<Entity id="a1b2c3d4-e5f6-7890-abcd-ef1234567890" patternsProximity="300" recommendedConfidence="75">
  <Pattern confidenceLevel="75">
    <IdMatch idRef="Regex_israel_id" />
    <Match idRef="Keyword_israel_id" />
  </Pattern>
</Entity>
"@

New-DlpSensitiveInformationType `
    -Name "ASF - Israel ID Number" `
    -Description "Detects Israeli national ID numbers (9-digit format)" `
    -RulePackage ([System.Text.Encoding]::Unicode.GetBytes($israelIdPattern))

# SIT 2 — Internal Project Code (ASF-XXXX-XXXX format)
$projectCodeXml = @"
<Entity id="b2c3d4e5-f6a7-8901-bcde-f12345678901" patternsProximity="300" recommendedConfidence="85">
  <Pattern confidenceLevel="85">
    <IdMatch idRef="Regex_project_code" />
  </Pattern>
</Entity>
"@

New-DlpSensitiveInformationType `
    -Name "ASF - Internal Project Code" `
    -Description "Detects internal ASF project codes in format ASF-XXXX-XXXX"

Write-Host "Custom SITs created:" -ForegroundColor Green
Get-DlpSensitiveInformationType | Where-Object { $_.Name -like "ASF -*" } | Select-Object Name, Description
