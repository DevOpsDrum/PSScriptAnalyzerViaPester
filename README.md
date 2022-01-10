# PSScriptAnalyzer and Pester
This repo serves as an example of how to use Pester to generate NUnit XML from PSScriptAnalyzer output. The output is published as part of the pipeline (PR/CI).

I use this method to validate that PowerShell scripts/modules in repos conform to a set of formatting rules when the pipeline runs. This validation helps the variety of folks working with the scripts by keeping a level of consistent over time.

> This hack is necessary due to PSScriptAnalyzer not supporting NUnitXML as an output, and NUnitXML is the format needed to publish test results in an Azure DevOps pipeline.

---

## Overview
The workflow is: 
* Working from the root of this repo, run script: `./Invoke-Pester.ps1`
   * This script will set Pester configuration options and have Pester run on the test file for PSScriptAnalyzer: `PSScriptAnalyzer.tests.ps1`
* The `PSScriptAnalyzer.tests.ps1` file will
   * Get the rules defined in the settings file: `./PSScriptAnalyzerSettings.psd1`
   * Run `Invoke-ScriptAnalyzer` for all PowerShell files in repo
   * Loop through results to create an array with the name and diagnostic record for any issues found
   * Pass the array into Pester `It` block to check if any rules failed
   * Generate NUnitXML report in the `output` folder

> This example uses Pester's [data driven tests model](https://pester-docs.netlify.app/docs/usage/data-driven-tests)

---

## General Pester info
* `DAMP` (or `Descriptive and Meaningful Phrases`) should be used to name tests, i.e. the test names should be *readable*. 

---

## Non-working examples
> A quick rant on the terrible non-working examples I have wasted time on

The available examples of how to use Pester with PSScriptAnalyzer this were written before Pester 5 was released and, due to the breaking changes in v5 those examples no longer work.

There is a disturbing lack of working examples out there, I can only assume because so few people actually use PSScriptAnalyzer, but hopefully this repo will help the bold few who want to increase the consistency of the scripts they write. 

I found [this thread](https://github.com/pester/Pester/issues/1564), with folks discussing their issues and resolutions, very helpful.
