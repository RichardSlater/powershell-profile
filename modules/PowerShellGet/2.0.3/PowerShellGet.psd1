@{
RootModule = 'PSModule.psm1'
ModuleVersion = '2.0.3'
GUID = '1d73a601-4a6c-43c5-ba3f-619b18bbb404'
Author = 'Microsoft Corporation'
CompanyName = 'Microsoft Corporation'
Copyright = '(c) Microsoft Corporation. All rights reserved.'
Description = 'PowerShell module with commands for discovering, installing, updating and publishing the PowerShell artifacts like Modules, DSC Resources, Role Capabilities and Scripts.'
PowerShellVersion = '3.0'
FormatsToProcess = 'PSGet.Format.ps1xml'
FunctionsToExport = @(
	'Find-Command',
	'Find-DSCResource',
	'Find-Module',
	'Find-RoleCapability',
	'Find-Script',
	'Get-InstalledModule',
	'Get-InstalledScript',
	'Get-PSRepository',
	'Install-Module',
	'Install-Script',
	'New-ScriptFileInfo',
	'Publish-Module',
	'Publish-Script',
	'Register-PSRepository',
	'Save-Module',
	'Save-Script',
	'Set-PSRepository',
	'Test-ScriptFileInfo',
	'Uninstall-Module',
	'Uninstall-Script',
	'Unregister-PSRepository',
	'Update-Module',
	'Update-ModuleManifest',
	'Update-Script',
	'Update-ScriptFileInfo')

VariablesToExport = "*"
AliasesToExport = @('inmo','fimo','upmo','pumo')
FileList = @('PSModule.psm1',
             'PSGet.Format.ps1xml',
             'PSGet.Resource.psd1')
RequiredModules = @(@{ModuleName='PackageManagement';ModuleVersion='1.1.7.0'})
PrivateData = @{
                "PackageManagementProviders" = 'PSModule.psm1'
                 "SupportedPowerShellGetFormatVersions" = @('1.x','2.x')
    PSData = @{
        Tags = @('Packagemanagement',
                 'Provider',
                 'PSEdition_Desktop',                 
		         'PSEdition_Core',
                 'Linux',
                 'Mac')
        ProjectUri = 'https://go.microsoft.com/fwlink/?LinkId=828955'
        LicenseUri = 'https://go.microsoft.com/fwlink/?LinkId=829061'
        ReleaseNotes = @'
## 2.0.3

Bug fixes and Improvements
* Fix CommandAlreadyAvailable error for PackageManagement module (#333)
* Remove trailing whitespace when value is not provided for Get-PSScriptInfoString (#337) (Thanks @thomasrayner)
* Expanded aliases for improved readability (#338) (Thanks @lazywinadmin)
* Improvements for Catalog tests (#343)
* Fix Update-ScriptInfoFile to preserve PrivateData (#346) (Thanks @tnieto88)
* Import modules with many commands faster (#351)

New Features
* Tab completion for -Repository parameter (#339) and for Publish-Module -Name (#359) (Thanks @matt9ucci)

## 2.0.1

Bug fixes
- Resolved Publish-Module doesn't report error but fails to publish module (#316)
- Resolved CommandAlreadyAvailable error while installing the latest version of PackageManagement module (#333)

## 2.0.0

Breaking Change
- Default installation scope for Install-Module, Install-Script, and Install-Package has changed. For Windows PowerShell (version 5.1 or below), the default scope is AllUsers when running in an elevated session, and CurrentUser at all other times.
  For PowerShell version 6.0.0 and above, the default installation scope is always CurrentUser.

## 1.6.7

Bug fixes
- Resolved Install/Save-Module error in PSCore 6.1.0-preview.4 on Ubuntu 18.04 OS (WSL/Azure) (#313)
- Updated error message in Save-Module cmdlet when the specified path is not accessible (#313)
- Added few additional verbose messages (#313)

## 1.6.6

Dependency Updates
* Add dependency on version 4.1.0 or newer of NuGet.exe
* Update NuGet.exe bootstrap URL to https://aka.ms/psget-nugetexe

Build and Code Cleanup Improvements
* Improved error handling in network connectivity tests.

Bug fixes
- Change Update-ModuleManifest so that prefix is not added to CmdletsToExport.
- Change Update-ModuleManifest so that parameters will not reset to default values.
- Specify AllowPrereleseVersions provider option only when AllowPrerelease is specified on the PowerShellGet cmdlets.

## 1.6.5

New features
* Allow Pester/PSReadline installation when signed by non-Microsoft certificate (#258)
  - Whitelist installation of non-Microsoft signed Pester and PSReadline over Microsoft signed Pester and PSReadline.

Build and Code Cleanup Improvements
* Splitting of functions (#229) (Thanks @Benny1007)
  - Moves private functions into respective private folder.
  - Moves public functions as defined in PSModule.psd1 into respective public folder.
  - Removes all functions from PSModule.psm1 file.
  - Dot sources the functions from PSModule.psm1 file.
  - Uses Export-ModuleMember to export the public functions from PSModule.psm1 file.

* Add build step to construct a single .psm1 file (#242) (Thanks @Benny1007)
  - Merged public and private functions into one .psm1 file to increase load time performance.

Bug fixes
- Fix null parameter error caused by MinimumVersion in Publish-PackageUtility (#201)
- Change .ExternalHelp link from PSGet.psm1-help.xml to PSModule-help.xml in PSModule.psm1 file (#215)
- Change Publish-* to allow version comparison instead of string comparison (#219)
- Ensure Get-InstalledScript -RequiredVersion works when versions have a leading 0 (#260)
- Add positional path to Save-Module and Save-Script (#264, #266)
- Ensure that Get-AuthenticodePublisher verifies publisher and that installing or updating a module checks for approprite catalog signature (#272)
- Update HelpInfoURI to 'http://go.microsoft.com/fwlink/?linkid=855963' (#274)


## 1.6.0

New features
* Prerelease Version Support (#185)
  - Implemented prerelease versions functionality in PowerShellGet cmdlets.
  - Enables publishing, discovering, and installing the prerelease versions of modules and scripts from the PowerShell Gallery.
  - [Documentation](https://docs.microsoft.com/en-us/powershell/gallery/psget/module/PrereleaseModule)

* Enabled publish cmdlets on PWSH and Nano Server (#196)
  - Dotnet command version 2.0.0 or newer should be installed by the user prior to using the publish cmdlets on PWSH and Windows Nano Server.
  - Users can install the dotnet command by following the instructions specified at https://aka.ms/dotnet-install-script.
  - On Windows, users can install the dotnet command by running *Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile '.\dotnet-install.ps1'; & '.\dotnet-install.ps1' -Channel Current -Version '2.0.0'*
  - Publish cmdlets on Windows PowerShell supports using the dotnet command for publishing operations.

Breaking Change
- PWSH: Changed the installation location of AllUsers scope to the parent of $PSHOME instead of $PSHOME. It is the SHARED_MODULES folder on PWSH.

Bug fixes
- Update HelpInfoURI to 'https://go.microsoft.com/fwlink/?linkid=855963' (#195)
- Ensure MyDocumentsPSPath path is correct (#179) (Thanks @lwsrbrts)


## 1.5.0.0

New features
* Added support for modules requiring license acceptance (#150)
  - [Documentation](https://docs.microsoft.com/en-us/powershell/gallery/psget/module/RequireLicenseAcceptance)

* Added version for REQUIREDSCRIPTS (#162)
  - Enabled following scenarios for REQUIREDSCRIPTS
    - [1.0] - RequiredVersion
    - [1.0,2.0] - Min and Max Version
    - (,1.0] - Max Version
    - 1.0 - Min Version

Bug fixes
* Fixed empty version value in nuspec (#157)


## 1.1.3.2
* Disabled PowerShellGet Telemetry on PS Core as PowerShell Telemetry APIs got removed in PowerShell Core beta builds. (#153)
* Fixed for DateTime format serialization issue. (#141)
* Update-ModuleManifest should add ExternalModuleDependencies value as a collection. (#129)

## 1.1.3.1

New features
* Added `PrivateData` field to ScriptFileInfo. (#119)

Bug fixes
* Fixed Add-Type issue in v6.0.0-beta.1 release of PowerShellCore. (#125, #124)
* Install-Script -Scope CurrentUser PATH changes should not require a reboot for new PS processes. (#124)
    - Made changes to broadcast the Environment variable changes, so that other processes pick changes to Environment variables without having to reboot or logoff/logon.
* Changed `Get-EnvironmentVariable` to get the unexpanded version of `%path%`. (#117)
* Refactor credential parameter propagation to sub-functions. (#104)
* Added credential parameter to subsequent calls of `Publish-Module/Script`. (#93)
    - This is needed when a module is published that has the RequiredModules attribute in the manifest on a repository that does not have anonymous access because the required module lookups will fail.

## 1.1.2.0

Bug fixes
* Renamed `PublishModuleIsNotSupportedOnNanoServer` errorid to `PublishModuleIsNotSupportedOnPowerShellCoreEdition`. (#44)
    - Also renamed `PublishScriptIsNotSupportedOnNanoServer` to `PublishScriptIsNotSupportedOnPowerShellCoreEdition`.
* Fixed an issue in `Update-Module` and `Update-Script` cmdlets to show proper version of current item being updated in `Confirm`/`WhatIf` message. (#44)
* Updated `Test-ModuleInstalled` function to return single module instead of multiple modules. (#44)
* Updated `ModuleCommandAlreadyAvailable` error message to include all conflicting commands instead of one.  (#44)
    - Corresponding changes to collect the complete set of conflicting commands from the being installed.
    - Also ensured that conflicting commands from PSModule.psm1 are ignored in the command collision analysis as Get-Command includes the commands from current local scope as well.

* Fixed '[Test-ScriptFileInfo] Fails on *NIX newlines (LF vs. CRLF)' (#18)


## 1.1.1.0

Bug fixes
* Fixed 'Update-Module fails with `ModuleAuthenticodeSignature` error for modules with signed PSD1'. (#12) (#8)
* Fixed 'Properties of `AdditionalMetadata` are case-sensitive'. #7
* Changed `ErrorAction` to `Ignore` for few cmdlet usages as they should not show up in ErrorVariable.
    - For example, error returned by `Get-Command Test-FileCatalog` should be ignored.


## 1.1.0.0

* Initial release from GitHub.
* PowerShellCore support.
* Security enhancements including the enforcement of catalog-signed modules during installation.
* Authenticated Repository support.
* Proxy Authentication support.
* Responses to a number of user requests and issues.
'@
    }
}

HelpInfoURI = 'http://go.microsoft.com/fwlink/?linkid=855963'
}


# SIG # Begin signature block
# MIIjlAYJKoZIhvcNAQcCoIIjhTCCI4ECAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAc02JJpxxoi47D
# tI216exTVcSpmY5nJhKBJH9R+n+HRKCCDYEwggX/MIID56ADAgECAhMzAAABA14l
# HJkfox64AAAAAAEDMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMTgwNzEyMjAwODQ4WhcNMTkwNzI2MjAwODQ4WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDRlHY25oarNv5p+UZ8i4hQy5Bwf7BVqSQdfjnnBZ8PrHuXss5zCvvUmyRcFrU5
# 3Rt+M2wR/Dsm85iqXVNrqsPsE7jS789Xf8xly69NLjKxVitONAeJ/mkhvT5E+94S
# nYW/fHaGfXKxdpth5opkTEbOttU6jHeTd2chnLZaBl5HhvU80QnKDT3NsumhUHjR
# hIjiATwi/K+WCMxdmcDt66VamJL1yEBOanOv3uN0etNfRpe84mcod5mswQ4xFo8A
# DwH+S15UD8rEZT8K46NG2/YsAzoZvmgFFpzmfzS/p4eNZTkmyWPU78XdvSX+/Sj0
# NIZ5rCrVXzCRO+QUauuxygQjAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUR77Ay+GmP/1l1jjyA123r3f3QP8w
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDM3OTY1MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAn/XJ
# Uw0/DSbsokTYDdGfY5YGSz8eXMUzo6TDbK8fwAG662XsnjMQD6esW9S9kGEX5zHn
# wya0rPUn00iThoj+EjWRZCLRay07qCwVlCnSN5bmNf8MzsgGFhaeJLHiOfluDnjY
# DBu2KWAndjQkm925l3XLATutghIWIoCJFYS7mFAgsBcmhkmvzn1FFUM0ls+BXBgs
# 1JPyZ6vic8g9o838Mh5gHOmwGzD7LLsHLpaEk0UoVFzNlv2g24HYtjDKQ7HzSMCy
# RhxdXnYqWJ/U7vL0+khMtWGLsIxB6aq4nZD0/2pCD7k+6Q7slPyNgLt44yOneFuy
# bR/5WcF9ttE5yXnggxxgCto9sNHtNr9FB+kbNm7lPTsFA6fUpyUSj+Z2oxOzRVpD
# MYLa2ISuubAfdfX2HX1RETcn6LU1hHH3V6qu+olxyZjSnlpkdr6Mw30VapHxFPTy
# 2TUxuNty+rR1yIibar+YRcdmstf/zpKQdeTr5obSyBvbJ8BblW9Jb1hdaSreU0v4
# 6Mp79mwV+QMZDxGFqk+av6pX3WDG9XEg9FGomsrp0es0Rz11+iLsVT9qGTlrEOla
# P470I3gwsvKmOMs1jaqYWSRAuDpnpAdfoP7YO0kT+wzh7Qttg1DO8H8+4NkI6Iwh
# SkHC3uuOW+4Dwx1ubuZUNWZncnwa6lL2IsRyP64wggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVaTCCFWUCAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAQNeJRyZH6MeuAAAAAABAzAN
# BglghkgBZQMEAgEFAKCBvDAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgdIvIDCZU
# fNtp6LGJqAPJSnDSnXvakXBB8Ks5R2SU5OMwUAYKKwYBBAGCNwIBDDFCMECgFoAU
# AFAAbwB3AGUAcgBTAGgAZQBsAGyhJoAkaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L1Bvd2VyU2hlbGwgMA0GCSqGSIb3DQEBAQUABIIBALhodpLyD7rzeHRi2hLFeVgT
# OdXsTG3OHuMSTF9193Z8psxQDTnpG2EyDabT3svcJNjY6ze9oWXd+7jRjcgG5ncl
# M3UqIsJrUWu5EwmL7WCYAgG2XRf+ZFPA3huF7+BAHfEg9X0/AMXQJJyKIBuYYLP5
# 1v/2exoOM4JDgC6w7ZxFoQPafe++C48dkzXK9ijBf2uAyznhOHWp+Uw03uxQAmGD
# NZXNZovd1g8vE0VdYGwSGOwM23eelzwGVleW3EWYVA2xVn+RbKb4sZzU10M6QQKx
# HSbjvXvkd6M4mwXPzzS+hM6gAg+JJqzEdLNKIbtkmwKtVfpM1MfiaYC5uBw25wSh
# ghLlMIIS4QYKKwYBBAGCNwMDATGCEtEwghLNBgkqhkiG9w0BBwKgghK+MIISugIB
# AzEPMA0GCWCGSAFlAwQCAQUAMIIBUQYLKoZIhvcNAQkQAQSgggFABIIBPDCCATgC
# AQEGCisGAQQBhFkKAwEwMTANBglghkgBZQMEAgEFAAQgk+RR5/+2jQp7hICNOYsh
# qwJzlqtNv64MesIbAJNrFiYCBlvbJyxVzBgTMjAxODExMTkyMDA3MjkuNjIyWjAE
# gAIB9KCB0KSBzTCByjELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAldBMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xLTArBgNV
# BAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJhdGlvbnMgTGltaXRlZDEmMCQGA1UE
# CxMdVGhhbGVzIFRTUyBFU046RTA0MS00QkVFLUZBN0UxJTAjBgNVBAMTHE1pY3Jv
# c29mdCBUaW1lLVN0YW1wIHNlcnZpY2Wggg48MIIE8TCCA9mgAwIBAgITMwAAANae
# ZYGODRijOwAAAAAA1jANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFt
# cCBQQ0EgMjAxMDAeFw0xODA4MjMyMDI2NDlaFw0xOTExMjMyMDI2NDlaMIHKMQsw
# CQYDVQQGEwJVUzELMAkGA1UECBMCV0ExEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IEly
# ZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVT
# TjpFMDQxLTRCRUUtRkE3RTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# c2VydmljZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANXPwF6FmwIH
# 72hpry/7CeAQiFCp7TaYgDnuaYVJ4TT7gjzEA2E6PgwHNX3LSWk6nbOBAR54gU/e
# UZun2tXo7NwLD5O8VGwZI8ZgtTwDO4N1BGjyw1vAmX5r8fANFL5DlAblpKr6oxa1
# WsFF/4Rm5iUgtpY47Ka4syZoEn41p0x5HQI/soYlXmHAHoTTjLKdUenLaYUQ8BPi
# n4/bAGqwN48R1Toxu1sULyAVw4GEns0FBLV/NFPx5zEy4vrQ91tAgL31+9ozn6UK
# fX1IPCYfFohs5ZdNrDYYnJjN4FeCuJDwmkzVY2cofJHMou+uTn3dyCSVINzQ8aDy
# BgA41jo024kCAwEAAaOCARswggEXMB0GA1UdDgQWBBRnVDCT4EkxGn72ThccpxE4
# N4+I+DAfBgNVHSMEGDAWgBTVYzpcijGQ80N7fEYbxTNoWoVtVTBWBgNVHR8ETzBN
# MEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0
# cy9NaWNUaW1TdGFQQ0FfMjAxMC0wNy0wMS5jcmwwWgYIKwYBBQUHAQEETjBMMEoG
# CCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01p
# Y1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQM
# MAoGCCsGAQUFBwMIMA0GCSqGSIb3DQEBCwUAA4IBAQBP0oWAiZvlpcPgkbXFLf5m
# t/q59K5YhD1xtnAcN32jGY2iU37N0vVj8PI1bGIIFQbvXsRiYoFoplsWP/Q0fqdt
# bQfl8BvIk0H4sAAlioixow7uA38IV+eL/8ggFU7AIvm8RaJW4r0dOu389DR8LmQL
# m6nbeGtytvgIZ/HLACZhc5BfnPLS04ChbordM6ZwSCGXOfdTTqCur2Ep/gXtK7YC
# YY3hXomQdoaR6Arw7etnslyybOiSJXijVxHBoTY6TJU+mxufq9lV78dBLHE02gFW
# MKBOi/N1QIDQGhIf5Ptc7pvCG1TcnrOSN/7eFj1FhcfEejI34vtrlinQhkCPvCa/
# MIIGcTCCBFmgAwIBAgIKYQmBKgAAAAAAAjANBgkqhkiG9w0BAQsFADCBiDELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9z
# b2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMTAwNzAxMjEz
# NjU1WhcNMjUwNzAxMjE0NjU1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKkdDbx3EYo6IOz8E5f1
# +n9plGt0VBDVpQoAgoX77XxoSyxfxcPlYcJ2tz5mK1vwFVMnBDEfQRsalR3OCROO
# fGEwWbEwRA/xYIiEVEMM1024OAizQt2TrNZzMFcmgqNFDdDq9UeBzb8kYDJYYEby
# WEeGMoQedGFnkV+BVLHPk0ySwcSmXdFhE24oxhr5hoC732H8RsEnHSRnEnIaIYqv
# S2SJUGKxXf13Hz3wV3WsvYpCTUBR0Q+cBj5nf/VmwAOWRH7v0Ev9buWayrGo8noq
# CjHw2k4GkbaICDXoeByw6ZnNPOcvRLqn9NxkvaQBwSAJk3jN/LzAyURdXhacAQVP
# Ik0CAwEAAaOCAeYwggHiMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBTVYzpc
# ijGQ80N7fEYbxTNoWoVtVTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNV
# HQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo
# 0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29m
# dC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5j
# cmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jv
# c29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDCB
# oAYDVR0gAQH/BIGVMIGSMIGPBgkrBgEEAYI3LgMwgYEwPQYIKwYBBQUHAgEWMWh0
# dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9QS0kvZG9jcy9DUFMvZGVmYXVsdC5odG0w
# QAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AUABvAGwAaQBjAHkAXwBTAHQA
# YQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAAfmiFEN4sbgmD+B
# cQM9naOhIW+z66bM9TG+zwXiqf76V20ZMLPCxWbJat/15/B4vceoniXj+bzta1RX
# CCtRgkQS+7lTjMz0YBKKdsxAQEGb3FwX/1z5Xhc1mCRWS3TvQhDIr79/xn/yN31a
# PxzymXlKkVIArzgPF/UveYFl2am1a+THzvbKegBvSzBEJCI8z+0DpZaPWSm8tv0E
# 4XCfMkon/VWvL/625Y4zu2JfmttXQOnxzplmkIz/amJ/3cVKC5Em4jnsGUpxY517
# IW3DnKOiPPp/fZZqkHimbdLhnPkd/DjYlPTGpQqWhqS9nhquBEKDuLWAmyI4ILUl
# 5WTs9/S/fmNZJQ96LjlXdqJxqgaKD4kWumGnEcua2A5HmoDF0M2n0O99g/DhO3EJ
# 3110mCIIYdqwUB5vvfHhAN/nMQekkzr3ZUd46PioSKv33nJ+YWtvd6mBy6cJrDm7
# 7MbL2IK0cs0d9LiFAR6A+xuJKlQ5slvayA1VmXqHczsI5pgt6o3gMy4SKfXAL1Qn
# IffIrE7aKLixqduWsqdCosnPGUFN4Ib5KpqjEWYw07t0MkvfY3v1mYovG8chr1m1
# rtxEPJdQcdeh0sVV42neV8HR3jDA/czmTfsNv11P6Z0eGTgvvM9YBS7vDaBQNdrv
# CScc1bN+NR4Iuto229Nfj950iEkSoYICzjCCAjcCAQEwgfihgdCkgc0wgcoxCzAJ
# BgNVBAYTAlVTMQswCQYDVQQIEwJXQTEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNO
# OkUwNDEtNEJFRS1GQTdFMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBz
# ZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQAPVF9Kvy/rYTCV9K6Mz7e9kCAV0aCBgzCB
# gKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBBQUA
# AgUA351gVjAiGA8yMDE4MTEyMDAwMTYyMloYDzIwMTgxMTIxMDAxNjIyWjB3MD0G
# CisGAQQBhFkKBAExLzAtMAoCBQDfnWBWAgEAMAoCAQACAiEHAgH/MAcCAQACAhFz
# MAoCBQDfnrHWAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAI
# AgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQEFBQADgYEAMku/JFBPRdVD
# L5YVnmLohgtr85GfdRaF9RPPVflRKySwT2a5pHiZA0EQd3+ozYnUok4BsKFgb2jl
# expuyl21QD9M7xtKiACpz14FpgDfUXGBvgRWkqXNITChTbbIHaF4MaXLEkfxkoAq
# RG9ax+UzKknVo51qKO0uEGH6LDLDrwkxggMNMIIDCQIBATCBkzB8MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
# VGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAANaeZYGODRijOwAAAAAA1jANBglghkgB
# ZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3
# DQEJBDEiBCBv8HaNa47qhT4/QwQQd2EgrAF6e2ExYw0DGcVrCfECZzCB+gYLKoZI
# hvcNAQkQAi8xgeowgecwgeQwgb0EIAynFxsvOT6psZreZEU3LDqho3HjsXblW/7R
# mCculEjOMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMA
# AADWnmWBjg0YozsAAAAAANYwIgQgTM2Ldtv6AegahC92Z/S/RMN3Pv69In+GjmKm
# SVu4c/owDQYJKoZIhvcNAQELBQAEggEAkNoxeyH5DusXRi4Ibdn2NguzyOkCj9Qf
# cSGyhF6UsRuDaz+cIvp6hfpFH0MWbG/oNHFLNDFQQpHQnO5/E0louKFw1dsjP6D1
# ugvZNJqeNzoDpFTfqTCsjKgOF+s3TOe/5hl4UjtPfCLfVBXJ0AlPFmuRydY2m5US
# yxEmTOAZT7vbZ/LxVr0dMBuoyp1LjDjlPRqusYWbKk/dShY97eSwzAOW7KdUfvqo
# zUsZOgBuba40z8bJQ4jUYeASluVCelq8iPVin/nAn4w2ufUVXI9Bald6710cfxIH
# Lw6JxC3nI/khmE+w7f+UZFLBK+MMYXNWMKOmPYrlVcXscEXPIUrQIQ==
# SIG # End signature block
