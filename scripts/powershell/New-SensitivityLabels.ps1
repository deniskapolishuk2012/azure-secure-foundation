# Requires: ExchangeOnlineManagement module
# Install: Install-Module ExchangeOnlineManagement -Force
# Run: Connect-IPPSSession first

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$AdminUPN
)

Connect-IPPSSession -UserPrincipalName $AdminUPN

# Public — no restrictions
New-Label `
    -Name "ASF-Public" `
    -DisplayName "Public" `
    -Tooltip "Information approved for public use" `
    -ContentType "File, Email"

# Internal — internal use only
New-Label `
    -Name "ASF-Internal" `
    -DisplayName "Internal" `
    -Tooltip "Internal use only - do not share externally" `
    -ContentType "File, Email"

# Confidential — sensitive business data
New-Label `
    -Name "ASF-Confidential" `
    -DisplayName "Confidential" `
    -Tooltip "Sensitive data - restricted access required" `
    -ContentType "File, Email"

# Highly Confidential — most restricted
New-Label `
    -Name "ASF-HighlyConfidential" `
    -DisplayName "Highly Confidential" `
    -Tooltip "Highly sensitive data - executives only" `
    -ContentType "File, Email"

Write-Host "Sensitivity labels created successfully" -ForegroundColor Green
Get-Label | Where-Object { $_.Name -like "ASF-*" } | Select-Object Name, DisplayName, Priority
