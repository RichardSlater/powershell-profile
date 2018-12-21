#
# Copyright (c) Microsoft Corporation.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# This PS DSC resource enables installing a package. The resource uses Install-Package cmdlet
# to install the package from various providers/sources.

Import-LocalizedData -BindingVariable LocalizedData -filename MSFT_PackageManagement.strings.psd1

Import-Module -Name "$PSScriptRoot\..\PackageManagementDscUtilities.psm1"

function Get-TargetResource
{
    <#
    .SYNOPSIS

    This DSC resource provides a mechanism to download and install packages on a computer. 

    Get-TargetResource returns the current state of the resource.

    .PARAMETER Name
    Specifies the name of the Package to be installed or uninstalled.

    .PARAMETER Source
    Specifies the name of the package source where the package can be found.
    This can either be a URI or a source registered with Register-PackageSource cmdlet.
    The DSC resource MSFT_PackageManagementSource can also register a package source.
    
    .PARAMETER RequiredVersion
    Specifies the exact version of the package that you want to install. If you do not specify this parameter, 
    this DSC resource installs the newest available version of the package that also satisfies any
    maximum version specified by the MaximumVersion parameter.

    .PARAMETER MaximumVersion
    Specifies the maximum allowed version of the package that you want to install. If you do not specify this parameter, 
    this DSC resource installs the highest-numbered available version of the package.

    .PARAMETER MinimumVersion
    Specifies the minimum allowed version of the package that you want to install. If you do not add this parameter, 
    this DSC resource intalls the highest available version of the package that also satisfies any maximum 
    specified version specified by the MaximumVersion parameter.

    .PARAMETER SourceCredential
    Specifies a user account that has rights to install a package for a specified package provider or source.

    .PARAMETER ProviderName
    Specifies a package provider name to which to scope your package search. You can get package provider names 
    by running the Get-PackageProvider cmdlet.

    .PARAMETER AdditionalParameters
    Provider specific parameters that are passed as an Hashtable. For example, for NuGet provider you can
    pass additional parameters like DestinationPath.
    #>

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $RequiredVersion,
        
        [Parameter()]
        [System.String]
        $MinimumVersion,

        [Parameter()]
        [System.String]
        $MaximumVersion,

        [Parameter()]
        [System.String]
        $Source,

        [Parameter()]
        [PSCredential] $SourceCredential,

        [Parameter()]
        [System.String]
        $ProviderName,
        
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]$AdditionalParameters        
    )
    
    $ensure = "Absent"
    $null = $PSBoundParameters.Remove("Source")
    $null = $PSBoundParameters.Remove("SourceCredential")

    if ($AdditionalParameters)
    {
         foreach($instance in $AdditionalParameters)
         {
             Write-Verbose ('AdditionalParameter: {0}, AdditionalParameterValue: {1}' -f $instance.Key, $instance.Value)
             $null = $PSBoundParameters.Add($instance.Key, $instance.Value)
         }
    }
    $null = $PSBoundParameters.Remove("AdditionalParameters")
    
    $verboseMessage =$localizedData.StartGetPackage -f (GetMessageFromParameterDictionary $PSBoundParameters),$env:PSModulePath
    Write-Verbose -Message $verboseMessage
    $result = PackageManagement\Get-Package @PSBoundParameters -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
        

    if ($result.count -eq 1)
    {
        Write-Verbose -Message ($localizedData.PackageFound -f $Name)
        $ensure = "Present"
    }
    elseif ($result.count -gt 1)
    {
        Write-Verbose -Message ($localizedData.MultiplePackagesFound -f $Name)
        $ensure = "Present"
    }
    else
    {
        Write-Verbose -Message ($localizedData.PackageNotFound -f $($Name))
    }

    Write-Debug -Message "Source $($Name) is $($ensure)"
                         
    
    if ($ensure -eq 'Absent')
    {
        return @{
            Ensure       = $ensure
            Name         = $Name
            ProviderName = $ProviderName
            RequiredVersion = $RequiredVersion
            MinimumVersion = $MinimumVersion
            MaximumVersion = $MaximumVersion
        }
    }
    else
    {
        if ($result.Count -gt 1)
        {
          $result = $result[0]
        }

        return  @{
                Ensure             = $ensure
                Name               = $result.Name
                ProviderName       = $result.ProviderName
                Source             = $result.source
                RequiredVersion    = $result.Version
            } 
    } 
}

function Test-TargetResource
{
    <#
    .SYNOPSIS

    This DSC resource provides a mechanism to download and install packages on a computer. 

    Test-TargetResource returns a boolean which determines whether the resource is in
    desired state or not.

    .PARAMETER Name
    Specifies the name of the Package to be installed or uninstalled.

    .PARAMETER Source
    Specifies the name of the package source where the package can be found.
    This can either be a URI or a source registered with Register-PackageSource cmdlet.
    The DSC resource MSFT_PackageManagementSource can also register a package source.
    
    .PARAMETER RequiredVersion
    Specifies the exact version of the package that you want to install. If you do not specify this parameter, 
    this DSC resource installs the newest available version of the package that also satisfies any
    maximum version specified by the MaximumVersion parameter.

    .PARAMETER MaximumVersion
    Specifies the maximum allowed version of the package that you want to install. If you do not specify this parameter, 
    this DSC resource installs the highest-numbered available version of the package.

    .PARAMETER MinimumVersion
    Specifies the minimum allowed version of the package that you want to install. If you do not add this parameter, 
    this DSC resource intalls the highest available version of the package that also satisfies any maximum 
    specified version specified by the MaximumVersion parameter.

    .PARAMETER SourceCredential
    Specifies a user account that has rights to install a package for a specified package provider or source.

    .PARAMETER ProviderName
    Specifies a package provider name to which to scope your package search. You can get package provider names 
    by running the Get-PackageProvider cmdlet.

    .PARAMETER AdditionalParameters
    Provider specific parameters that are passed as an Hashtable. For example, for NuGet provider you can
    pass additional parameters like DestinationPath.
    #>

    [CmdletBinding()]
    [OutputType([bool])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $RequiredVersion,
        
        [Parameter()]
        [System.String]
        $MinimumVersion,

        [Parameter()]
        [System.String]
        $MaximumVersion,

        [Parameter()]
        [System.String]
        $Source,

        [Parameter()]
        [PSCredential] $SourceCredential,
                
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure="Present",

        [Parameter()]
        [System.String]
        $ProviderName,
        
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]$AdditionalParameters         
    )

    
    Write-Verbose -Message ($localizedData.StartTestPackage -f (GetMessageFromParameterDictionary $PSBoundParameters))
    $null = $PSBoundParameters.Remove("Ensure")
    
    $temp = Get-TargetResource @PSBoundParameters

    if ($temp.Ensure -eq $ensure)
    {
        Write-Verbose -Message ($localizedData.InDesiredState -f $Name, $Ensure, $temp.Ensure)            
        return $True 
    }
    else
    {
        Write-Verbose -Message ($localizedData.NotInDesiredState -f $Name,$ensure,$temp.ensure)            
        return [bool] $False
    }    
}

function Set-TargetResource
{
    <#
    .SYNOPSIS

    This DSC resource provides a mechanism to download and install packages on a computer. 

    Set-TargetResource either intalls or uninstall a package as defined by the vaule of Ensure parameter.

    .PARAMETER Name
    Specifies the name of the Package to be installed or uninstalled.

    .PARAMETER Source
    Specifies the name of the package source where the package can be found.
    This can either be a URI or a source registered with Register-PackageSource cmdlet.
    The DSC resource MSFT_PackageManagementSource can also register a package source.
    
    .PARAMETER RequiredVersion
    Specifies the exact version of the package that you want to install. If you do not specify this parameter, 
    this DSC resource installs the newest available version of the package that also satisfies any
    maximum version specified by the MaximumVersion parameter.

    .PARAMETER MaximumVersion
    Specifies the maximum allowed version of the package that you want to install. If you do not specify this parameter, 
    this DSC resource installs the highest-numbered available version of the package.

    .PARAMETER MinimumVersion
    Specifies the minimum allowed version of the package that you want to install. If you do not add this parameter, 
    this DSC resource intalls the highest available version of the package that also satisfies any maximum 
    specified version specified by the MaximumVersion parameter.

    .PARAMETER SourceCredential
    Specifies a user account that has rights to install a package for a specified package provider or source.

    .PARAMETER ProviderName
    Specifies a package provider name to which to scope your package search. You can get package provider names 
    by running the Get-PackageProvider cmdlet.

    .PARAMETER AdditionalParameters
    Provider specific parameters that are passed as an Hashtable. For example, for NuGet provider you can
    pass additional parameters like DestinationPath.
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $RequiredVersion,
        
        [Parameter()]
        [System.String]
        $MinimumVersion,

        [Parameter()]
        [System.String]
        $MaximumVersion,

        [Parameter()]
        [System.String]
        $Source,

        [Parameter()]
        [PSCredential] $SourceCredential,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure="Present",

        [Parameter()]
        [System.String]
        $ProviderName,
        
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]$AdditionalParameters        
    )

    Write-Verbose -Message ($localizedData.StartSetPackage -f (GetMessageFromParameterDictionary $PSBoundParameters))
    
    $null = $PSBoundParameters.Remove("Ensure")

    if ($PSBoundParameters.ContainsKey("SourceCredential"))
    {
        $PSBoundParameters.Add("Credential", $SourceCredential)
        $null = $PSBoundParameters.Remove("SourceCredential")
    }
    
    if ($AdditionalParameters)
    {
         foreach($instance in $AdditionalParameters)
         {
             Write-Verbose ('AdditionalParameter: {0}, AdditionalParameterValue: {1}' -f $instance.Key, $instance.Value)
             $null = $PSBoundParameters.Add($instance.Key, $instance.Value)
         }
    }

    $PSBoundParameters.Remove("AdditionalParameters")

       
        # We do not want others to control the behavior of ErrorAction
        # while calling Install-Package/Uninstall-Package.
        $PSBoundParameters.Remove("ErrorAction")
        if ($Ensure -eq "Present")
        {
            PackageManagement\Install-Package @PSBoundParameters -ErrorAction Stop
        }   
        else
        {
            # we dont source location for uninstalling an already
            # installed package
            $PSBoundParameters.Remove("Source")
            # Ensure is Absent
            PackageManagement\Uninstall-Package @PSBoundParameters -ErrorAction Stop
        }
 }
 
 function GetMessageFromParameterDictionary
 {
    <#
        Returns a strng of form "ParameterName:ParameterValue"
        Used with Write-Verbose message. The input is mostly $PSBoundParameters
    #>
    param([System.Collections.IDictionary] $paramDictionary)

    $returnValue = ""
    $paramDictionary.Keys | ForEach-Object { $returnValue += "-{0} {1} " -f $_,$paramDictionary[$_] }
    return $returnValue
 }

Export-ModuleMember -function Get-TargetResource, Set-TargetResource, Test-TargetResource


# SIG # Begin signature block
# MIIkfQYJKoZIhvcNAQcCoIIkbjCCJGoCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA14ax2UFs7ys6v
# QQSG1uOnTAz+BzEZBkvGfX8UfrKELKCCDYEwggX/MIID56ADAgECAhMzAAABA14l
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
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIWUjCCFk4CAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAQNeJRyZH6MeuAAAAAABAzAN
# BglghkgBZQMEAgEFAKCBvDAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQg+jYTRmu2
# gU1q6sWIoMCx9xSq2HdDcKd8d0cdid2cct4wUAYKKwYBBAGCNwIBDDFCMECgFoAU
# AFAAbwB3AGUAcgBTAGgAZQBsAGyhJoAkaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L1Bvd2VyU2hlbGwgMA0GCSqGSIb3DQEBAQUABIIBALRSTL4zxgJ86gqlzyoFLj4e
# bGCWHlUFCnROlOqblB1QpNCQbvAx5TU9UvCxL86azXxvrADoOltNaIV8AhiKyw/4
# ViglXNU2ErV1YZ1n4KrS/3LbvztFvbh88cY/Aj9GV/DRSRiJVSsOTbMT+9SPeBs8
# P2yuLvR7/kxq6lbaKELRJ0SDGoJAHa34z7oCDQ1wVJQg6GGNz6bRJGVRPlvy9v3Q
# 8HTZm/kLjr3AB5yroS8DEQq3wlhXb4C/CL77Q7918iUTT022D5ugS0e2uJVM0TCa
# wA6zO4ajsm1o5ne1rJPErnXfL1n3mRaYrbr8Lp5B5aUHdU2bBmIf2zDgOrKZq3eh
# ghPOMIITygYKKwYBBAGCNwMDATGCE7owghO2BgkqhkiG9w0BBwKgghOnMIITowIB
# AzEPMA0GCWCGSAFlAwQCAQUAMIIBWAYLKoZIhvcNAQkQAQSgggFHBIIBQzCCAT8C
# AQEGCisGAQQBhFkKAwEwMTANBglghkgBZQMEAgEFAAQgfg/QrN0MFt+Qdo7xjSin
# VhVQMkSQmV6JH3Xi4ZMIacMCBlv9dxvKwxgTMjAxODEyMDEwMDMzMDQuNDkzWjAH
# AgEBgAIB9KCB1KSB0TCBzjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEpMCcGA1UECxMgTWljcm9zb2Z0IE9wZXJhdGlvbnMgUHVlcnRvIFJpY28x
# JjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOjk4RkQtQzYxRS1FNjQxMSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIPHjCCBPUwggPdoAMCAQIC
# EzMAAADLX3jLIw6Ul8MAAAAAAMswDQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTAwHhcNMTgwODIzMjAyNjI0WhcNMTkxMTIzMjAyNjI0
# WjCBzjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEpMCcGA1UE
# CxMgTWljcm9zb2Z0IE9wZXJhdGlvbnMgUHVlcnRvIFJpY28xJjAkBgNVBAsTHVRo
# YWxlcyBUU1MgRVNOOjk4RkQtQzYxRS1FNjQxMSUwIwYDVQQDExxNaWNyb3NvZnQg
# VGltZS1TdGFtcCBTZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
# AQEAxXjIHe/wHUFwHG00Sj9UAsoaeLMDVYIQhTbYMKnLLzfw7RWVbsPcpSiZk8hT
# eezHczFpBelqLQ6JWz4M+4ep2gq2y5gJozF4MeGh0KA9Z09P003SGeCcLTtHacMH
# Y2G+1EGmvhXfrv3U+qLcKywoN0uMGs5BSGoSfxLRU/nGV0NA98wimpEVB0/pS3h2
# 9oj8y9rl7zodtrAnF0YqtN0enss5p7dgdfbmSFuG41q2qnd0O7cOjrEMTUEhrYa5
# QZlrigdU3BYhaTdJnjFmVqtPd4CLvXbJbJ5OuMa/npHKN7zIOIG137VQKfru3RPB
# ClNr5rZk8/a/wfJDFB6Bz71OFQIDAQABo4IBGzCCARcwHQYDVR0OBBYEFCjk8ub2
# ydFNrm7I2yqWvzHD+9l2MB8GA1UdIwQYMBaAFNVjOlyKMZDzQ3t8RhvFM2hahW1V
# MFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kv
# Y3JsL3Byb2R1Y3RzL01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNybDBaBggrBgEF
# BQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9w
# a2kvY2VydHMvTWljVGltU3RhUENBXzIwMTAtMDctMDEuY3J0MAwGA1UdEwEB/wQC
# MAAwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJKoZIhvcNAQELBQADggEBAIv0YYWD
# BWJsyxSUl8PpJQNscrEv2k3plgyD5o5MTwDIKH2gPody6KdSOSPpp9BTrdO+BVFY
# TFgkvOtAHKwCHYaBsaQog+11XrJBAyUnFyVelHjy3WNLVW8FfQqSxHkGr/j/R7nz
# 6Ne9RpTYlxRBXDeUef0j9i1Al64C+c18sQ3EkoTcDsU6M4DD58Qfj04YrUgFH3KF
# dL6voeyUW4Ut+MrsNTz34K7XMCD0lMIKuqVZLJ1YCkBiH8AIic40scen05l2KULj
# bMaMHxGj/TtiowCM+Ertl7XaVZOGJkgWpzl9lPEKLcvZPylAj3X83G7gKekjMtdT
# BJdTGQil9I2wrs4wggZxMIIEWaADAgECAgphCYEqAAAAAAACMA0GCSqGSIb3DQEB
# CwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMTIwMAYD
# VQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAxMDAe
# Fw0xMDA3MDEyMTM2NTVaFw0yNTA3MDEyMTQ2NTVaMHwxCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0
# YW1wIFBDQSAyMDEwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqR0N
# vHcRijog7PwTl/X6f2mUa3RUENWlCgCChfvtfGhLLF/Fw+Vhwna3PmYrW/AVUycE
# MR9BGxqVHc4JE458YTBZsTBED/FgiIRUQwzXTbg4CLNC3ZOs1nMwVyaCo0UN0Or1
# R4HNvyRgMlhgRvJYR4YyhB50YWeRX4FUsc+TTJLBxKZd0WETbijGGvmGgLvfYfxG
# wScdJGcSchohiq9LZIlQYrFd/XcfPfBXday9ikJNQFHRD5wGPmd/9WbAA5ZEfu/Q
# S/1u5ZrKsajyeioKMfDaTgaRtogINeh4HLDpmc085y9Euqf03GS9pAHBIAmTeM38
# vMDJRF1eFpwBBU8iTQIDAQABo4IB5jCCAeIwEAYJKwYBBAGCNxUBBAMCAQAwHQYD
# VR0OBBYEFNVjOlyKMZDzQ3t8RhvFM2hahW1VMBkGCSsGAQQBgjcUAgQMHgoAUwB1
# AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaA
# FNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9j
# cmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8y
# MDEwLTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6
# Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAt
# MDYtMjMuY3J0MIGgBgNVHSABAf8EgZUwgZIwgY8GCSsGAQQBgjcuAzCBgTA9Bggr
# BgEFBQcCARYxaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL1BLSS9kb2NzL0NQUy9k
# ZWZhdWx0Lmh0bTBABggrBgEFBQcCAjA0HjIgHQBMAGUAZwBhAGwAXwBQAG8AbABp
# AGMAeQBfAFMAdABhAHQAZQBtAGUAbgB0AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEA
# B+aIUQ3ixuCYP4FxAz2do6Ehb7Prpsz1Mb7PBeKp/vpXbRkws8LFZslq3/Xn8Hi9
# x6ieJeP5vO1rVFcIK1GCRBL7uVOMzPRgEop2zEBAQZvcXBf/XPleFzWYJFZLdO9C
# EMivv3/Gf/I3fVo/HPKZeUqRUgCvOA8X9S95gWXZqbVr5MfO9sp6AG9LMEQkIjzP
# 7QOllo9ZKby2/QThcJ8ySif9Va8v/rbljjO7Yl+a21dA6fHOmWaQjP9qYn/dxUoL
# kSbiOewZSnFjnXshbcOco6I8+n99lmqQeKZt0uGc+R38ONiU9MalCpaGpL2eGq4E
# QoO4tYCbIjggtSXlZOz39L9+Y1klD3ouOVd2onGqBooPiRa6YacRy5rYDkeagMXQ
# zafQ732D8OE7cQnfXXSYIghh2rBQHm+98eEA3+cxB6STOvdlR3jo+KhIq/fecn5h
# a293qYHLpwmsObvsxsvYgrRyzR30uIUBHoD7G4kqVDmyW9rIDVWZeodzOwjmmC3q
# jeAzLhIp9cAvVCch98isTtoouLGp25ayp0Kiyc8ZQU3ghvkqmqMRZjDTu3QyS99j
# e/WZii8bxyGvWbWu3EQ8l1Bx16HSxVXjad5XwdHeMMD9zOZN+w2/XU/pnR4ZOC+8
# z1gFLu8NoFA12u8JJxzVs341Hgi62jbb01+P3nSISRKhggOsMIIClAIBATCB/qGB
# 1KSB0TCBzjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEpMCcG
# A1UECxMgTWljcm9zb2Z0IE9wZXJhdGlvbnMgUHVlcnRvIFJpY28xJjAkBgNVBAsT
# HVRoYWxlcyBUU1MgRVNOOjk4RkQtQzYxRS1FNjQxMSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNloiUKAQEwCQYFKw4DAhoFAAMVALmjk9JAdtG3
# HxWjBFGXrjgr25ohoIHeMIHbpIHYMIHVMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSkwJwYDVQQLEyBNaWNyb3NvZnQgT3BlcmF0aW9ucyBQdWVy
# dG8gUmljbzEnMCUGA1UECxMebkNpcGhlciBOVFMgRVNOOjU3RjYtQzFFMC01NTRD
# MSswKQYDVQQDEyJNaWNyb3NvZnQgVGltZSBTb3VyY2UgTWFzdGVyIENsb2NrMA0G
# CSqGSIb3DQEBBQUAAgUA36vqczAiGA8yMDE4MTIwMTAwNTcyM1oYDzIwMTgxMjAy
# MDA1NzIzWjBzMDkGCisGAQQBhFkKBAExKzApMAoCBQDfq+pzAgEAMAYCAQACARMw
# BwIBAAICGQswCgIFAN+tO/MCAQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYBBAGE
# WQoDAaAKMAgCAQACAxbjYKEKMAgCAQACAwehIDANBgkqhkiG9w0BAQUFAAOCAQEA
# pTxBdd1l6V+fn5+uZ3mObbc+BE1bHVfGtNVhuknqpcql6/k3cHZxGmOUf0QVNKsG
# 94saI1sRzxIxS79H7/1O7cg1gmZzhbEvVW8/RxlHlA+RHXkgTyOer/DsO0YdcEoO
# ZQ6ZYsAuVnEpIwq2By9cBCEKG+7XeUAqMBNu6Lmc6acekoNcpf3etmL4hCA7buZl
# dN4q4iG5BDh7emMNXEHMdetBAPlGZsYcz77t/5LKnM/MJh+ajPGAdfvLgLbbDQTm
# YLZhncB3ARY5pkWYs5Es9hoJixInbzX1R1ZWdkbTx6G1Y6F4kljZEcVe0VKCll/P
# Qwl8YvYK8SXCclwcTqn5UTGCAw0wggMJAgEBMIGTMHwxCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0
# YW1wIFBDQSAyMDEwAhMzAAAAy194yyMOlJfDAAAAAADLMA0GCWCGSAFlAwQCAQUA
# oIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkEMSIE
# IH1eJ4tvj1cg3SYEdJTzk+CJkIDO3IVMPkdKCcE4/7tSMIH6BgsqhkiG9w0BCRAC
# LzGB6jCB5zCB5DCBvQQgNichqqlgp17rc9CkvUt8Lhf2n0vTLu4UR16qYN3BHWQw
# gZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYw
# JAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAMtfeMsj
# DpSXwwAAAAAAyzAiBCA8M6wG5uWI6P1JMonGz49xMrYHgkD9R2DD23IhWNdBfTAN
# BgkqhkiG9w0BAQsFAASCAQC37Iri7uaxTZCB3gtKlhuTVdihYPQ7gXjQGjA1O9zc
# j4orxzwV3djIRs5VOjDT2XPERWMSvHAbxKo1O17UVeZScwVx/NDtPoVPd2PKnilK
# JSPebJ8VRNnAGPB3+dHsLe5Sl7EGxeJpfxD9XZPbn5pyG9D46jwtmq6XRwbZl0fa
# wVaDcNrIsNEDb0ilo/73g5zmGlRVPYaq5gliSIOR5Lx51tNo9QFNKvmxeZJ9/VR1
# TV392QF8VPlIbzaqWptaO9SyJ4PUp6rPA8LLT+D9zFWhw6WkcOgW0iuM6Qwd91ap
# 5N60GMynlo8k1vwPZXWdW/v8DIURDA2XUvqsrelWXZp7
# SIG # End signature block
