<#
.SYNOPSIS
    Pester test to publish PSScriptAnalyzer results
.DESCRIPTION
    Run PSScriptAnalyzer on all PS files in working folder, then use Pester to generate proper test output
.NOTES
    PSScriptAnalyzer does not output NUnit XML, so Pester is used to generate that report
.LINK
    https://github.com/DevOpsDrum/PSScriptAnalyzer
#>

# PSScriptAnalyzer suppression items:
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Justification = 'Suppressing because Invoke-Expression is needed to read in PSScriptAnalyzer settings file properly.')]
[CmdletBinding()]
param() # needed to prevent suppression message attribute from causing error

begin {
    # install/import PSScriptAnalyzer module
    if ($null -eq (Get-Module -ListAvailable -Name PSScriptAnalyzer)) { Write-Output "Installing PSScriptAnalyzer module..."; Set-PSRepository PSGallery -InstallationPolicy Trusted; Install-Module -Name PSScriptAnalyzer -Scope CurrentUser } else { Write-Verbose "PSScriptAnalyzer module already installed." -Verbose; Import-Module -Name PSScriptAnalyzer }
    
    $pssaSettingsFile = './PSScriptAnalyzerSettings.psd1'
    if ((Test-Path $pssaSettingsFile) -eq $false) { throw "PS Script Analyzer settings not found at $pssaSettingsFile" }
    
    # get rules from settings file instead of `Get-ScriptAnalyzerRule`, which gets all rules, whether they're used or not.
    $pssaSettingsData = Get-Content -Path $pssaSettingsFile -Raw # get rules file content as string, which is a hash table
    $pssaSettingsHashtable = Invoke-Expression -Command $pssaSettingsData # convert string into hashtable object
    $pssaSettingsRules = $pssaSettingsHashtable.IncludeRules # use list of included rules when looping through rules below
    
    # run PSScriptAnalyzer with settings file, recursively in repo files, and store results in $analysis var
    $analysis = Invoke-ScriptAnalyzer -Path . -Recurse -Settings $pssaSettingsFile # -IncludeSuppressed
    
    # build TestCases array to pass into `It` block
    $testCases = @() # instantiate array to store test cases
    foreach ($settingsRule in $pssaSettingsRules) {
        if (($analysis.RuleName) -contains $settingsRule) {
            # one or more issues were found for this rule, so save the items that match the rule name to $record
            $record = $analysis | Where-Object { $_.RuleName -like $settingsRule }
        }
        
        # add rule name and record object (as JSON) to $testCases array
        $testCases += @{
            rule   = $settingsRule # rule name
            record = if ($null -ne $record) { $record | ConvertTo-Json -Depth 4 }  # diagnostic record stored as JSON if not null, otherwise null/empty
        }
        
        # reset to null after each loop
        $record = $null
    }
}

process {
    # pester blocks
    Describe 'PSScriptAnalyzer' {
        Context 'OTBS (K&R) and PSGallery Formatting' {
            It "Should not get results for rule: <_.rule>" -TestCases $testCases {
                $_.record | Should -BeNullOrEmpty
            }
        }
    }
}

end {}
