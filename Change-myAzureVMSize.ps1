Function Change-myAzureVMSize {

[CmdletBinding()]
Param (
$VmName        = 'psh1', 
$VmServicename = 'psh1',
$VMsize        = 'Basic_A0')

# check if VM exists
$Vm = Get-AzureVM $vmname
if (! $vm) 
   {
     "VM $vm Does not exist"; return
   }
Else 
    {
     Write-Verbose "VM exists, continuing"
    }
# Check if size is valid
# First get the role sizes

$OkSizes = (Get-AzureLocation).VirtualMachineRoleSizes  | Sort-Object $_ | Select-Object -Unique
Write-Verbose "$($OkSizes.count) VM sizes available"
if ( $OkRoles -notcontains $VmSize)
   {
     Write-Verbose "VM Size [$VmSize] is incorrect"
     Write-Verbose "Valid VM Sizes are as follows:"
     return
   }

# Stop if if it's running
if ($Vm.instanceStatus -eq 'ReadyRole') 
  {
    Write-Verbose "Stopping VM [$($vm.name)]"
    $Vm | Stop-AzureVM -force
    $Vm = Get-AzureVM $vmname
  }

 # Now wait until VM is fully stopped.
 do {
    if ($vm.Status -notmatch 'Stopped') 
      {
        Write-Verbose "Waiting 15 more seconds"
        Start-Sleep -Seconds 15}
        $Vm = Get-AzureVM $vmname
      }
While ($vm.Status -NotMatch 'Stopped')

# So let's change size
Write-Verbose "VM Stopped - changing size  to $vmSize"
Set-AzureVMSize -VM $Vm -Instancesize $VmSize   -Verbose |
     Update-AzureVM -Verbose


# Restart VM
Write-Verbose 'Size changed, restarting VM'
Start-AzureVM -Name $vmname -ServiceName $vmservicename
$Vm = Get-AzureVM $vmname
Write-Verbose "VM Status: [$($vm.InstanceStatus)]" 
Write-Verbose 'All done, returning'

 }

 # test it out
 Change-myAzureVMSize -verbose -VmName psh1 -VmServicename psh1 -VMsize 'ExtraSmall'
