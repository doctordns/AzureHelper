# New-tflAzureFileShare.ps1
Function New-tflAzureFileShare {
<#
.SYNOPSIS
    This script creates an Azure File Store in a new Storage Account
.DESCRIPTION
    This script first checks to see if the 
.NOTES
    File Name  : 
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0
    Tested     : PowerShell Version 5
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
   .EXAMPLE
    
#>

[CmdletBinding()]
Param (
$StorageAccountName = 'cookham123',   # must be lower case
$Share              = 'fileshare',
$Location           = 'North Europe',
# Type can be: Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS
$Type               =  'Standard_LRS',
$FileShareName      = 'Cookham123FS'
)

# start time
$start = Get-Date
Write-Verbose "New-tflAzureFileshare started at [$start]" 

# Ensure share and storage account names are lower case
$StorageAccountName = $StorageAccountName.ToLower()
$FileShareName      = $FileShareName.ToLower()

# First, see if SA exists
$ac = Get-AzureStorageAccount -StorageAccountName $StorageAccountName -ErrorAction SilentlyContinue
Write-Verbose "Storage account [$StorageAccountName] exists? [$(if ($ac) {$true} else {$false})]"

If (!$ac)  # SA does not exist - so create it
   {
   # But check to see if the name exists elswhere!
     if (Test-AzureName -Storage $StorageAccountName) 
        {Write-Verbose "The name [$StorageAccountName] can not be used - try again"
          return}


   # SA does not exist, not used elsewhere...
     Write-Verbose "Storage Account [$StorageAccountName] in [$Location] does not exist"
     Write-Verbose "Creating Storage Account [$StorageAccountName] in [$Location]"
     New-AzureStorageAccount -StorageAccountName $StorageAccountName `
                             -Location $Location -Type $Type
     Write-Verbose "Storage Account [$StorageAccountName] created in [$Location] as [$Type]"
 
 # Get Storage Account Key/Context
    $Key     = (Get-AzureStorageKey -StorageAccountName $StorageAccountName).Primary
    $Context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $key
  
  # Create the share   
    Write-Verbose "Creating new share [$Share]"
    $FS = New-AzureStorageShare -Name $Share -Context $Context
    Write-Verbose "New Share Created"  
  
  
  # Create a folder
    New-AzureStorageDirectory -Share $Share -Path testdir
    Get-AzureStorageFile -Share $s -Path testdir

  # For future use - persist the creds that created this account locally
    Write-Verbose "Persisting credentials for [$StorageAccountName]"
    cmdkey /add:$StorageAccountName.file.core.windows.net /user:$StorageAccountName /pass:$key
    Write-Verbose "Credenials for [$StorageAccountName] persisted locally"

   }

$finish = Get-Date
Write-Verbose "Finished at [$finish]"
Write-Verbose ("Function took [{0}] minutes" -f $($finish-$start).totalminutes.tostring('n2'))
} # End of function

 # Try..


# test it
# $testsa = 'share1234'
# Test-AzureName -storage $testsa
# $Share              = 'jerry'
# $Location           = 'North Europe'
# New-tflAzureFileShare -StorageAccountName $testsa  -FileShareName $share -Verbose
# net use w: "https://share1234.file.core.windows.net/share1234"
# Explorer w:

#
# Remove It
# Remove-AzureStorageAccount -StorageAccountName $testsa