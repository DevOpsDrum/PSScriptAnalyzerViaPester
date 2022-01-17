<#
.SYNOPSIS
    Use Pester to run PSScriptAnalyzer
.DESCRIPTION
    Use Pester to run and publish PSScriptAnalyzer output
.EXAMPLE
    PS C:\> Invoke-Invoke-PSScriptAnalyzerViaPester -OutputFile <desired NUnitXML file path> -PesterTestsPath <Path to Pester test file(s)>
    Pester executes on file(s) in path and produced an NUnitXML file report in desired location
.OUTPUTS
    NUnit XML file in location specified by `-OutputFile`
.NOTES
    This is a hack to get an NUnitXML report for PSScriptAnalyzer output, as PSScriptAnalyzer does not produce NUnit XML output
    ~Script like a champion today~
.LINK
    https://github.com/DevOpsDrum/PSScriptAnalyzer
#>
[OutputType([System.String])]
[CmdletBinding()]
param(
    [string] $OutputFile = './output/psscriptanalyzer-nunit.xml',
    [string] $PesterTestsPath = './PSScriptAnalyzer.tests.ps1',
    [ValidateSet('NUnitXML', 'JUnitXMl')] # only 2 formats supported by Pester
    [string] $OutputFormat = 'NUnitXML',
    [ValidateSet('Diagnostic', 'Detailed', 'Normal', 'Minimal', 'None')]
    [string] $OutputVerbosity = 'Detailed'
)

begin {
    # install/import Pester module
    if ($null -eq (Get-Module -ListAvailable -Name Pester)) { Write-Output "Installing Pester module..."; Set-PSRepository PSGallery -InstallationPolicy Trusted; Install-Module -Name Pester -Scope CurrentUser -SkipPublisherCheck } else { Write-Verbose "Pester module already installed." -Verbose; Import-Module -Name Pester }
    
    # create pester configuration object using doc here: https://pester-docs.netlify.app/docs/commands/New-PesterConfiguration
    $config = New-PesterConfiguration
    $config.Run.Path = $PesterTestsPath
    $config.TestResult.Enabled = $true
    $config.TestResult.OutputFormat = $OutputFormat # default is NUnitXML
    $config.TestResult.OutputPath = $OutputFile
    $config.Output.Verbosity = $OutputVerbosity
}

process {
    # call Pester `Invoke-Pester` function, which will run PSScriptAnalyzer tests in script set in var: $PesterTestsPath
    Invoke-Pester -Configuration $config

    Write-Output "`nPester $OutputFormat report: $OutputFile`n"
}

end {}
