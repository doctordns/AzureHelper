Function Update-tflAzureHelperModule  {
<#
.SYNOPSIS
    This function downloads the latest version of Azure Helper
.DESCRIPTION
    This function gets the version of Azure Helper loaded, and
    compares it with the latest on GitHub. If there is no version already loaded
    or if therere is a newer version, the latest version is downloaded and installed.
.NOTES
    File Name  : Get-LatestAzureHelperModule.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0
    Tested     : PowerShell Version 5
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
    Available on GitHub in the AzureHeler project
        https://github.com/doctordns/AzureHelper  
.EXAMPLE
    
#>

[CmdletBinding()]
Param(
[switch] $Listonly
)

$VerbosePreference = 'continue'
$AzureHelper = Get-Module -Name AzureHelper -ListAvailable
If ($azurehelper)
  {Write-Verbose "You currently have version $($AzureHelper.Version.ToString()) loaded"}

# Get the URI

$uri = 'https://api.github.com/repos/doctordns/azurehelper/releases/latest'

# Get latest version on GitHub
$LatestRelease = Invoke-RestMethod -Uri https://api.github.com/repos/DoctorDNS/AzureHelper/releases/latest -Method GET
$LatestVersionNumber = $LatestRelease.tag_name.substring(1)
Write-Verbose "Latest Version on GitHub: [$LatestVersionNumber]"

if ($listonly) 
   {
     Write-Verbose 'List version on GitHub'
     "Latest Version on GitHub: $LatestVersionNumber"
     if ($AzureHelper -eq $NULL) # not installed
         {"Local Version Not Installed"}
     elseif ($AzureHelper.Version.ToString() -ne $LatestRelease.name)
         {"Local version [$($AzureHelper.Version.ToString())] and GitHub version [$LatestVersionNumber] differs"}
     elseif ($AzureHelper.Version.ToString() -eq $LatestRelease.name)
         {"Local and GitHub versions identical"}
     Return
   }

# OK - now get the module if appropriate

$Doit=$false # assume don't
If (!$AzureHelper) {$Doit=$true}  # if it doesn't exist
Else  #do it if the release numberss vary)
   {if ($AzureHelper.Version.ToString() -ne $LatestRelease.name) {$Doit=$true}}

If ($doit)
{
    Write-Verbose "Downloading Version $($LatestRelease.name)"
    $OutFile = "{0}\{1}" -f $env:TEMP, "$($LatestRelease.name).zip"
    Invoke-WebRequest -Uri $LatestRelease.zipball_url -OutFile $Outfile -Method Get
    Write-Verbose "New Version Downloaded to [$OutFile]"

    # Now unzip it into temp folder
    $OutModule = "{0}\{1}" -f $env:TEMP, "$($LatestRelease.name)azurehelper"
    Expand-Archive -Path $OutFile -DestinationPath $OutModule -Force
    $OutFolder = ls $OutModule | Select -first 1
    $ModuleSource = "$($OutFolder.fullname)\AzureHelper"
    $ModuleLocation = "$((ls env:ProgramFiles).value)\Windowspowershell\Modules\"
    Copy-Item -Path $ModuleSource -Destination $moduleLocation -Force -Recurse
    
    Write-Verbose "AzureHelper Module updated at [$($ModuleLocation)\AzureHelper]"
    Write-Verbose "Use `'ipmo azurehelper -force1' to reload the module"
}
else
{
    Write-Host "Azure Powershell module is up to date with version [$($AzureHelper.Version.ToString())]"
}
}



# Test it
 Update-tflAzureHelperModule -list