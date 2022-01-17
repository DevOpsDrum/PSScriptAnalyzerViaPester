# 🕵️ PSScriptAnalyzer via Pester
PSScriptAnalyzer is used to `lint` PowerShell scripts, which means to check for programmatic and stylistic issues. It is good practice to perform these checks on a regular basis and in an automated fashion, like when checking in code or on pull requests.

The objective of this repo is to serve as example of how to lint PowerShell scripts in a repo as part of a CI/CD pipeline and publish those results in NUnit XML format (a standard test report format). Since PSScriptAnalyzer does not have the capability to produce NUnit XML, Pester is used to meet this requirement. Is is not as straight forward as I originally thought use Pester for this purpose as many examples available are **not** compatible with Pester 5, so this repo was created to serve as an example resource for myself and others. 

---

## ⚙️ Getting Started
This repo implements [dev containers](https://code.visualstudio.com/docs/remote/containers-tutorial), with recommended extensions and settings for working with this project. 

> Note: Only the prescribed extensions will be loaded, but your user settings will override the project settings if there is overlap.

To run the prescribed dev container:
* Press `F1` to open command pallet
* Type: `Remote-Containers: Open Folder in Container`, and select the option
* Select the repo folder: `PSScriptAnalyzerViaPester`, and the container will load in a minute or so. 

---

## 🌄 Overview
The workflow is: 
* Working from the root of this repo, run script: `./Invoke-PSScriptAnalyzerViaPester.ps1`
   * This script will set Pester configuration options and have Pester run on the test file for PSScriptAnalyzer: `PSScriptAnalyzer.tests.ps1`
* The `PSScriptAnalyzer.tests.ps1` file will
   * Get the rules defined in the settings file: `./PSScriptAnalyzerSettings.psd1`
   * Run `Invoke-ScriptAnalyzer` for all PowerShell files in repo
   * Loop through results to create an array with the name and diagnostic record for any issues found
   * Pass the array into Pester `It` block to check if any rules failed
   * Generate NUnitXML report in the `output` folder

> This example uses Pester's [data driven tests model](https://pester-docs.netlify.app/docs/usage/data-driven-tests)

### 🧪 bad-script.ps1
The `./bad-script.ps1` file has a example of a script that will fail the lint/PSScriptAnalyzer test due to the use of an alias `echo` instead of the full function name `Write-Output`. 

A GitHub action is triggered on push and it fails due to the `./bad-script.ps1` file. To get the action to complete successfully, I have commented out the "bad" command and added the proper version below, so the test completes successfully now.

---

## 😞 Non-working examples
> A quick rant on the terrible non-working examples I have wasted time on

The available examples of how to use Pester with PSScriptAnalyzer this were written before Pester 5 was released and, due to the breaking changes in v5, those examples no longer work.

There is a disturbing lack of working examples out there, I can only assume because so few people actually use PSScriptAnalyzer, but hopefully this repo will help the bold few who want to increase the consistency of the scripts they write. 

I found [this thread](https://github.com/pester/Pester/issues/1564), with folks discussing their issues and resolutions, very helpful.

---

## 📒 TODO
* Add some examples of PowerShell scripts and legit Pester tests, not just linting with PSScriptAnalyzer
* Create separate doc for Pester notes and include this:
  * `DAMP` (or `Descriptive and Meaningful Phrases`) should be used to name tests, i.e. the test names should be *readable*. 
