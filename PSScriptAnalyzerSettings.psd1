# PSScriptAnalyzer settings for this repo. 
# Reference: https://github.com/PowerShell/PSScriptAnalyzer/blob/master/README.md#settings-support-in-scriptanalyzer
@{
    Severity     = @('Information', 'Error', 'Warning')
    IncludeRules = @(
        'PSAlignAssignmentStatement', # CodeFormatting
        'PSAvoidDefaultValueSwitchParameter', # CmdletDesign, PSGallery
        'PSAvoidGlobalVars', # PSGallery
        'PSAvoidUsingCmdletAliases', # PSGallery
        'PSAvoidUsingComputerNameHardcoded', # PSGallery
        'PSAvoidUsingConvertToSecureStringWithPlainText', # ScriptSecurity
        'PSAvoidUsingEmptyCatchBlock', # PSGallery
        'PSAvoidUsingInvokeExpression', # PSGallery (consider using Invoke-Command with script block: `Invoke-Command -ScriptBlock { Write-Host "Hello" }`, instead of Invoke-Expression)
        'PSAvoidUsingPlainTextForPassword', # PSGallery
        'PSAvoidUsingPositionalParameters', # PSGallery
        'PSAvoidUsingUserNameAndPasswordParams', # ScriptSecurity
        'PSAvoidUsingWMICmdlet', # PSGallery
        # 'PSAvoidUsingWriteHost', # ScriptingStyle. No concerns using `Write-Host` because it is used as informational output in scripts and provides additional options, like color, that Write-Output and Write-Informational do not provide. 
        # 'PSDSC*', # PSGallery. Do not expect desired state config scripts to be used. Specific rule names can be found with: `Get-ScriptAnalyzerRule | Where-Object { $_.RuleName -like "PSDSC*" }`
        'PSMissingModuleManifestField', # CmdletDesign, PSGallery
        'PSPlaceCloseBrace', # CodeFormatting
        'PSPlaceOpenBrace', # CodeFormatting
        'PSProvideCommentHelp', # ScriptingStyle
        'PSReservedCmdletChar', # CmdletDesign, PSGallery
        'PSReservedParams', # CmdletDesign, PSGallery
        'PSShouldProcess', # CmdletDesign, PSGallery
        'PSUseApprovedVerbs', # CmdletDesign, PSGallery
        'PSUseCmdletCorrectly', # PSGallery
        'PSUseConsistentIndentation', # CodeFormatting
        'PSUseConsistentWhitespace', # CodeFormatting
        'PSUseCorrectCasing', # CodeFormatting
        'PSUseDeclaredVarsMoreThanAssignments', # PSGallery
        'PSUsePSCredentialType', # PSGallery
        'PSUseShouldProcessForStateChangingFunctions', # CmdletDesign, PSGallery
        'PSUseShouldProcessForStateChangingFunctions', # PSGallery
        'PSUseSingularNouns' # CmdletDesign, PSGallery
    )

    # CodeFormattingOTBS rules, a.k.a K&R
    # https://github.com/PowerShell/PSScriptAnalyzer/blob/58c44234d44dfd0db35bb532906963e08fde8621/Engine/Settings/CodeFormattingOTBS.psd1
    Rules        = @{
        PSPlaceOpenBrace           = @{
            Enable             = $true
            OnSameLine         = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }

        PSPlaceCloseBrace          = @{
            Enable             = $true
            NewLineAfter       = $false
            IgnoreOneLineBlock = $true
            NoEmptyLineBefore  = $false
        }

        PSUseConsistentIndentation = @{
            Enable              = $true
            Kind                = 'space'
            PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
            IndentationSize     = 4
        }

        PSUseConsistentWhitespace  = @{
            Enable                                  = $true
            CheckInnerBrace                         = $true
            CheckOpenBrace                          = $true
            CheckOpenParen                          = $true
            CheckOperator                           = $true
            CheckPipe                               = $true
            CheckPipeForRedundantWhitespace         = $false
            CheckSeparator                          = $true
            CheckParameter                          = $false
            IgnoreAssignmentOperatorInsideHashTable = $true
        }

        PSAlignAssignmentStatement = @{
            Enable         = $true
            CheckHashtable = $true
        }

        PSUseCorrectCasing         = @{
            Enable = $true
        }
    }
}