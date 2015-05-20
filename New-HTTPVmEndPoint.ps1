Function New-HttpVmEndpoint {
<#
SYNOPSIS
    This script defines a function to add an HTTP endpoint
    to an Azure VM.
.DESCRIPTION
    This script uses the Azure module to add an HTTP end point
    to an existing Azure VM.
.NOTES
    File Name  : New-HttpVmEndpoint.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0, Azure module
    Tested     : PowerShell Version 5
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
     
.EXAMPLE
    New-HttpVmEndpoint -vm 'psh1' -servicename 'psh1' 
    
    OperationDescription  OperationId                           OperationStatus                          
    --------------------  -----------                           ---------------                          
    Update-AzureVM        99709683-8c4b-607e-8856-5958a6967147  Succeeded                                

  #>
  [Cmdletbinding()]
  Param (
    $VmName,
    $ServiceName
  )
# So here, get the vm, add the endpoint, then update the VM
  Get-AzureVM -ServiceName $ServiceName -Name $VmName  |
     Add-AzureEndpoint -Name "Http" -Protocol "tcp" -PublicPort 80 -LocalPort 80  |
         Update-AzureVM 
   
}
