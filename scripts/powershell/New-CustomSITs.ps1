# Sensitive Information Types (SIT) — custom patterns for ASF project
# Requires: ExchangeOnlineManagement module
# Run after: New-SensitivityLabels.ps1

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$AdminUPN
)

Connect-IPPSSession -UserPrincipalName $AdminUPN

$rulePackageXml = @"
<?xml version="1.0" encoding="utf-16"?>
<RulePackage xmlns="http://schemas.microsoft.com/office/2011/mce">
  <RulePack id="a1b2c3d4-e5f6-7890-abcd-ef1234567890">
    <Version major="1" minor="0" build="0" revision="0" />
    <Publisher id="b2c3d4e5-f6a7-8901-bcde-f12345678901" />
    <Details defaultLangCode="en">
      <LocalizedDetails langcode="en">
        <PublisherName>ASF</PublisherName>
        <Name>ASF Custom SITs</Name>
        <Description>Custom Sensitive Information Types for Azure Secure Foundation</Description>
      </LocalizedDetails>
    </Details>
  </RulePack>
  <Rules>
    <Entity id="c3d4e5f6-a7b8-9012-cdef-123456789012" patternsProximity="300" recommendedConfidence="75">
      <Pattern confidenceLevel="75">
        <IdMatch idRef="Regex_israel_id" />
        <Any minMatches="1">
          <Match idRef="Keyword_israel_id" />
        </Any>
      </Pattern>
    </Entity>
    <Regex id="Regex_israel_id">\b\d{9}\b</Regex>
    <Keyword id="Keyword_israel_id">
      <Group matchStyle="word">
        <Term>Israel ID</Term>
        <Term>ID number</Term>
        <Term>identity number</Term>
      </Group>
    </Keyword>
    <LocalizedStrings>
      <Resource idRef="c3d4e5f6-a7b8-9012-cdef-123456789012">
        <Name default="true" langcode="en-us">ASF - Israel ID Number</Name>
        <Description default="true" langcode="en-us">Detects Israeli national ID numbers (9-digit format)</Description>
      </Resource>
    </LocalizedStrings>
  </Rules>
</RulePackage>
"@

$rulePackageBytes = [System.Text.Encoding]::Unicode.GetBytes($rulePackageXml)

try {
    New-DlpSensitiveInformationTypeRulePackage -FileData $rulePackageBytes
    Write-Host "Custom SITs created successfully" -ForegroundColor Green
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
}

Write-Host "`nCustom SITs in tenant:" -ForegroundColor Cyan
Get-DlpSensitiveInformationType | Where-Object { $_.Name -like "ASF -*" } | Select-Object Name, Description
