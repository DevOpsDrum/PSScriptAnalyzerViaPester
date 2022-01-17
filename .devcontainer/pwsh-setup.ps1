Install-Module -Name PSScriptAnalyzer -Force # -Scope CurrentUser
Import-Module -Name PSScriptAnalyzer -PassThru

Install-Module -Name Pester -Force # -Scope CurrentUser
Import-Module -Name Pester -PassThru

Set-PSReadLineKeyHandler -Key tab -Function TabCompleteNext
# Get-PSReadLineKeyHandler -Key tab 

# confirm PSScriptAnalyzer module installed by running:
# Get-ScriptAnalyzerRule
