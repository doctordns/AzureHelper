Function New-tflWindowsVM {

[CmdletBinding()]

Param (
$ImageFamily    = 'Windows Server 2012 R2 Datacenter', 
#vm and vmservice names 
$VmName         = 'psh1', 
$VmServiceName  = 'psh1', 
# vm admin user and username 
$VmUserName     = 'tfl', 
$VmPassword     = 'Pa$$w0rd', 
# instance size and location 
$VmInstanceSize = 'ExtraSmall', 
$VmLocation     = 'West Europe'
)

# Welcome
Write-Verbose 'Starting New-tflWindowsVM'
$start = Get-Date
Write-Verbose "Started at [$start]"

# Get our Azure VM images 
Write-Verbose "Getting images in family [$ImageFamily]"
$Img = Get-AzureVMImage | Where ImageFamily -Match $ImageFamily | sort PublishedDate -desc  | select -first 1
$Imgnm = $Img.ImageName
Write-Verbose "Choosing image [$imgnm]"

# OK - do it and create the VM
Write-Verbose 'Creating new VM - may take some time'
New-AzureVMConfig -Name $VmName -Instance $VmInstanceSize -Image $Imgnm | 
  Add-AzureProvisioningConfig -Windows -AdminUser $VmUserName -Pass $VmPassword |
    New-AzureVM -ServiceName 'psh1' -Location $vmlocation -WaitForBoot

# Create HTTP-EndPoint
Write-Verbose 'Adding HTTP Endpoint'
Get-AzureVM -Name $VmName -ServiceName $VmServiceName | 
      Add-AzureEndpoint -Name "http" -Protocol "tcp" -PublicPort 80 -LocalPort 80 | 
          Update-AzureVM  

# Install the Remote Management Cert
Write-Verbose 'Adding VM Remote Management Cert to local machine trusted root store'
Install-tflAzureVmRmCert -CloudServiceName $VmServiceName -VMName $VmName

# Check RM working
Write-Verbose 'Checking Remote Management is working'
# First get URI info
$uri  = Get-AzureWinRMUri -ServiceName $VmServiceName -Name $VmName
$auri = $uri.AbsoluteUri
$urip = $uri.Port 
Write-Verbose "Remote Management uses URI: [$auri] and port [$urip]"
$secPassword = ConvertTo-SecureString $VmPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential $VmUserName, $secPassword

# Now check it works
$output = Invoke-Command -ConnectionUri $auri -scr {hostname} -Credential $credential
If ($output -eq $VmName)
    {Write-Verbose "Remote Management functioning"}
Else
    {Write-Verbose "Remote Managment FAILED"}

# All done
Write-Verbose "VM Setup Completed for VM: [$VmServiceName/$VmName]"
$Finish = Get-Date
Write-Verbose "Finished at [$finish]"

Write-Verbose "Total time: [$(($finish - $start).totalminutes)] minutes"
}

# Demo and test
# New-tflWindowsVm -verbose