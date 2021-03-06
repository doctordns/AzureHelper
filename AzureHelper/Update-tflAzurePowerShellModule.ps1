﻿Function Update-tflAzurePowerShellModule  {
<#
.SYNOPSIS
    This function downloads the latest version of Azure PowerShell
.DESCRIPTION
    This function gets the version of Azure PowerShell loaded, and
    compares it with the latest on GigHub. If there is no version already loaded
    or if therere is a newer version, the latest version is downloaded and installed.
.NOTES
    File Name  : Get-LatestAzurePowerShellModule.ps1
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
[switch] $listonly
)
# Get latest Azure-Powershell module loaded in your system
$AzureModule = Get-Module -Name Azure -ListAvailable
Write-Verbose "You currently have version $($AzureModule.Version.ToString()) loaded"

# Get latest version on GitHub
$LatestRelease = Invoke-RestMethod -Uri https://api.github.com/repos/Azure/azure-powershell/releases/latest -Method GET
$LatestVersionNumber = $LatestRelease.name
Write-Verbose "Latest Version on GitHub: [$LatestVersionNumber]"

# If just list...
if ($listonly) 
   {
     Write-Verbose 'Called to list version on GitHub'
     "Latest Version on GitHub: $LatestVersionNumber"
     if ($AzureModule -eq $NULL) # not installed
         {"Local Version Not Installed"}
     elseif ($AzureModule.Version.ToString() -ne $LatestRelease.name)
         {"Local [$($AzureModule.Version.ToString())] and GitHub version differs"}
     elseif ($AzureModule.Version.ToString() -eq $LatestRelease.name)
         {"Local and GitHub versions identical"}


     Return
   }

If (($AzureModule.Version.ToString() -ne $LatestRelease.name) -or ($AzureModule -eq $NULL))
{
    Write-Verbose "Downloading Version $($LatestRelease.name)"
    $OutFile = "{0}\{1}" -f $env:TEMP, $LatestRelease.assets.name
    Invoke-WebRequest -Uri $LatestRelease.assets.browser_download_url -OutFile $Outfile -Method Get
    Write-Verbose "New Version Downloaded"
    Start-Process -FilePath msiexec.exe -ArgumentList @("/i $OutFile /qb") -Wait -PassThru
    Write-Verbose "New Version installed"
}
else
{
    Write-Host "Azure Powershell module is up to date with version [$($AzureModule.Version.ToString())]"
}
}

# Update-tflAzurePowerShellModule -listonly