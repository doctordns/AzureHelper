#0 . What's there now? 
Get-AzureVM

# 1. Add Azure Account

#Add-AzureAccount  # Do once per session

# 2. Setup Subscription
$subscr="Visual Studio Ultimate with MSDN"
$staccount="cookham"
Select-AzureSubscription -SubscriptionName $subscr –Current
Set-AzureSubscription -SubscriptionName $subscr -CurrentStorageAccountName $staccount
Write-Verbose "subscription set   : $subscr"
Write-Verbose "Storage Account set: $staccount"
pause

# 3. Set image details
$Family="Ubuntu Server 12.10"
$Image=Get-AzureVMImage | where { $_.ImageFamily -eq $Family } | 
    Sort PublishedDate -Desc |
       Select -ExpandProperty ImageName -First 1
Write-Verbose "Image selected: $image"
pause

# 4. Set basic VM details
$Vmname="Bunty100"
$Vmsize="Basic_A1"
$Vm1=New-AzureVMConfig -Name $Vmname `
 -InstanceSize $Vmsize -ImageName  $Image


# 5. Setup Credentials for Linux box
$U = 'tfl'
$P = ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force
$Cred = New-Object system.management.automation.PSCredential $U,$P
$vm1 | Add-AzureProvisioningConfig -Linux -LinuxUser $Cred.GetNetworkCredential().Username -Password $Cred.GetNetworkCredential().Password
Write-verbose "credentials for $u set"

# 6. Create the VM And see it
Write-verbose "Creating VM"
New-AzureVM –ServiceName $vmname -VMs $vm1 -Location 'West Europe'
Get-AzureVM

# 7. Set ssh port to 22 on public
Write-Verbose 'Setting port for SSH to 22' # hard coded to 22
Get-AzureVM -Name $VmName -ServiceName $ServiceName | 
      Set-AzureEndpoint -Name "ssh" -Protocol "tcp" -PublicPort 22 -LocalPort 22 | 
          Update-AzureVM  
# 8. Show Endpoints

Get-AzureVM bunty100| Get-AzureEndpoint


