function New-tflLinuxVm {

[CmdletBinding()]

param (
$Family   = "Ubuntu Server 12.10",
$Vmname   = "Bunty101",
$Vmsize   = "Basic_A1",
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
Write-Verbose "Image selected: [$image"]

# Set basic VM details
$Vm1=New-AzureVMConfig -Name $Vmname -InstanceSize $Vmsize -ImageName  $Image

# Add the creds to the Vm
$vm1 = $vm1 | Add-AzureProvisioningConfig -Linux -LinuxUser $user -Password $password
Write-verbose "credentials for [$user/$password] set"

Write-verbose "Creating VM"
New-AzureVM –ServiceName $vmname -VMs $vm1 -Location 'West Europe'

Get-AzureVM


}

# for testing
New-tflLinuxVm -Family "Ubuntu Server 12.10" -Vmname "Bunty101" -VMsize "Basic_A1" -User 'tfl' -Password 'Pa$$w0rd' -Location 'West Europe' -Verbose