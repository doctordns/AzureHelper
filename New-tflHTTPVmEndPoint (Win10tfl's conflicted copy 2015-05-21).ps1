Function New-tflHttpVmEndpoint {
<#
SYNOPSIS
    This script defines a function to add an HTTP endpoint
    to an Azure VM. 
.DESCRIPTION
    This script uses the Azure module to add an HTTP end point
    to an existing Azure VM.
.NOTES
    File Name  : New-tflHttpVmEndpoint.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0, Azure module
    Tested     : PowerShell Version 5
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
     
.EXAMPLE
    New-tflHttpVmEndpoint -vm 'psh1' -servicename 'psh1' 
    
    OperationDescription  OperationId                           OperationStatus                          
    --------------------  -----------                           ---------------                          
    Update-AzureVM        99709683-8c4b-607e-8856-5958a6967147  Succeeded                                

#>

[Cmdletbinding()]
Param (
   $VmName = $(Throw "No VM Name specified"),
   $ServiceName = $(Throw "No Service Name specified"),
   $PublicPort = 80,
   $LocalPort  = 80
)

# Get the vm, add the endpoint, then update the VM
$vm = Get-AzureVM -ServiceName $ServiceName -Name $VmName
if (! $vm) # check to see if it exists
   {
     "VM $VmName Does not exist"; return
   }
Else 
    {
     Write-Verbose "VM exists, continuing"
    }

Write-Verbose "VM [$VmName] in Service [$vmservicename] exists, proceeding"

# Check to see if endpoint exists - return if so
$EPExists = $false
$vm | Get-AzureEndpoint | 
      Foreach { if ($_.port -eq $PublicPort) 
                  {$EPExists = $true}
               }

# So...
If ($EPExists)
   {
      Write-Verbose "Endpoint with Public port [$PublicPort] exists, returning"
      return
   }

Write-Verbose "Endpoint with Public port [$PublicPort] does not exist, proceeding"
Write-Verbose "Adding Endpoint [$PublicPort]/[$LocalPort] for VM [$VmName] in service [$ServiceName]"
Get-AzureVM -Name $VmName -ServiceName $ServiceName | 
      Add-AzureEndpoint -Name "Http" -Protocol "tcp" -PublicPort $PublicPort -LocalPort $LocalPort | 
          Update-AzureVM  

Write-Verbose "Added Endpoint [$PublicPort]/[$LocalPort] for VM [$VmName] in service [$ServiceName]"

}

# Commented out - using the function. useful to demo!
# Test it
# New-tflHTTPVmEndPoint -VmName bunty100 -ServiceName bunty100 -PublicPort 80 -LocalPort 80 -Verbose

# And remove it after testing
#Get-AzureVM -ServiceName $servicename -Name $VmName | Get-AzureEndpoint | where port -eq 80 | Remove-AzureEndpoint | Update-AzureVM

