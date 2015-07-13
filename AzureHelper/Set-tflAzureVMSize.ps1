Function Set-tflAzureVMSize {
<#
.SYNOPSIS
    This function changes the VM size of an Azure VM
.DESCRIPTION
    This function first checks to see if the Service/VM exists.
    If so, it changes the size of the Azure VM.
.NOTES
    File Name  : Set=tflAzureVMSize
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0
    Tested     : PowerShell Version 5
.LINK
    This script posted to GitHub

.EXAMPLE
    Set-tflAzureVMSize -VmServicename bunty100 -VmName bunty100 -InstanceSize 'Small'
    
#>

[CmdletBinding()]
Param (
$VmName        = 'psh1', 
$VmServicename = 'psh1',
$InstanceSize  = 'Basic_A0')

# Check if VM exists
Write-Verbose "Checking to see if VM [$vmname] in service [$VmServicename] exists"
$Vm = Get-AzureVM  -Name $vmname -ServiceName $VmServicename
if (! $vm) 
   {
     "VM $vm Does not exist"; return
   }
Else 
    {
     Write-Verbose "VM exists, continuing"
    }

# Check if $InstanceSize size is valid
# First get the role sizes
$OkSizes = (Get-AzureLocation).VirtualMachineRoleSizes  | Sort-Object $_ | Select-Object -Unique
Write-Verbose "$($OkSizes.count) VM sizes available"
if ( $OkSizes -notcontains $InstanceSize)
   {
     Write-Verbose "VM Size [$VmSize] is incorrect"
     return
   }
Else {
     write-Verbose "Vmsisze [$InstanceSize] is valid"
     }

# Stop if if it's running
if ($Vm.instanceStatus -eq 'ReadyRole') 
  {
    Write-Verbose "Stopping VM [$($Vm.name)]"
    $Vm | Stop-AzureVM -force
    Write-Verbose 'VM Stopped'
    $Vm = Get-AzureVM $vmname
  }

 # Now wait until VM is fully stopped.
 do {
    if ($vm.Status -notmatch 'Stopped') 
      {
        Write-Verbose "Waiting 15 more seconds for shutdown"
        Start-Sleep -Seconds 15}
        $Vm = Get-AzureVM $vmname
      }
While ($vm.Status -NotMatch 'Stopped')

# So let's change size
Write-Verbose "VM Stopped - changing size  to $vmSize"
Set-AzureVMSize -VM $Vm -Instancesize $InstanceSize  | Update-AzureVM 

# Restart VM
Write-Verbose "Size changed to [$InstanceSize], restarting VM"
Start-AzureVM -Name $vmname -ServiceName $VmServicename

# Complete
$Vm = Get-AzureVM $vmname -ServiceName $VmServicename
$Vm
Write-Verbose "VM Status: [$($vm.InstanceStatus)]" 

# And return
Write-Verbose 'All done, returning'
}

 # test it out
 # Change-myAzureVMSize -verbose -VmName psh1 -VmServicename psh1 -VMsize 'ExtraSmall'
