function New-tflLinuxVm {
<#
.SYNOPSIS
    This script creates a Linux VM
.DESCRIPTION
    This script creates a Linux VM. By default it's ubuntu, but
    you can change the $family to any Linux. 
.NOTES
    File Name  : 
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0
    Tested     : PowerShell Version 5
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
    MSDN sample posted to:
         http://   
.EXAMPLE
    c:> New-tflLinuxVm -Family "Ubuntu Server 12.10" 1
                   -Vmname "Bunty101" `
                   -VMsize "Basic_A1" `
                   -User 'tfl' `
                   -Password 'Pa$$w0rd'`
                   -Location 'West Europe'`
                   -Verbose
    OperationDescription  OperationId                          OperationStatus
    --------------------  -----------                          ---------------                    
    New-AzureVM           809506d1-62a4-a9c2-bbc5-16a21dc2c786 Succeeded

#>
[CmdletBinding()]

param (
$Family   = "Ubuntu Server 12.10",
$VmName   = "Bunty101",
$VmSize   = "Basic_A1",
$User     = 'tfl',
$Password = 'Pa$$w0rd',
$Location = 'West Europe'
)

# Get image details
$Image=Get-AzureVMImage | where { $_.ImageFamily -match $Family } | 
    Sort PublishedDate -Desc |
       Select -ExpandProperty ImageName -First 1
If (! $image)
    { 
       'No Image Found, returning'
       return
    }
Write-Verbose "Image selected: [$image]"

# Set VM Basic details, creating VMconfig object
Write-Verbose 'Setting Basic details of VM'
$Vm1=New-AzureVMConfig -Name $VmName -InstanceSize $VmSize -ImageName  $Image

# Add the creds to the Vm
$vm1 = $vm1 | Add-AzureProvisioningConfig -Linux -LinuxUser $User -Password $Password
Write-Verbose "Credentials for [$User/$Password] set"

# Change port for SSH
Write-Verbose 'Setting port for SSH to 22' # hard coded to 22
Get-AzureVM -Name $VmName -ServiceName $ServiceName | 
      Set-AzureEndpoint -Name "ssh" -Protocol "tcp" -PublicPort 22 -LocalPort 22 | 
          Update-AzureVM  

# Now create the VM
Write-Verbose "Creating VM [$VmName]"
New-AzureVM –ServiceName $vmname -VMs $vm1 -Location $Location -WaitForBoot
}

# For testing or demo
# New-tflLinuxVm -Family "Ubuntu Server 12.10" -Vmname "Bunty100" -VMsize "Basic_A1" -User 'tfl' -Password 'Pa$$w0rd' -Location 'West Europe' -Verbose
# Get-AzureVM | Get-AzureEndpoint