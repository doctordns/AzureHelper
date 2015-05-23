AzureHelper
Ths AzureHelper module is a set of useful PowerShell tools for use with Microsoft Azure.

Introduction
I use PowerShell with Azure a great deal and have created a number of useful functions etc for dealing with Azure. 
The functions help me - and you are welcome to use them. 

What this module contains
This module consists of a variety of useful things including functions, aliases, code fragments, 
demos, format files and about_ files. These artifacts were created to illustrate Azure with PowerShell 
in course teachings and in presentations and other documentation. 

Meta-Files
1. AzureHelper.PSD1 - this is the module Manaifest with predictible information contained therein.
2. AzureHelper.PSM1 - this is the main script, called by teh manifest, that runs when you load the module. It does some documentation, dot sources each function file, and creates aliases.

Functions (each defined in a separate .ps1 file of same name)
Set-tflAzureSubscription        - sets a subscription as default.
New-tflHttpVmEndpoint           - sets an HTTP endpoint for a vm in the cloud
New-tflLinuxVM                  - Creates a Linux VM and sets SSH endpoint to 22/22
New-tflWindowsVM                - Creates a Windows VM, sets up and tests winrm,
                                  creates an HTTP endpoint
Set-tflAzureVMSize              - sets a VM to be in a different size (and restarts VM if not already running)
Update-tflAzurePowerShellModule - Gets Latest Azure PowerShell Module from GitHub (and checks if latest version if loaded)
Install-tflAzureVmRmCert        - Installs a remote management cert for a VM.


Aliases (set in psm1 file)
* Aliass to Azure Cmdlets
gavm - Get-AzureVM
ravm - Remove-AzureVM
savm - Stop-AzureVM
* Aliases to module functions
sas  - Set-AzureSubscription
uam  - Update-tflazurePowerShellModule
irc  - Install-tflAzureVmRmCert

Help Files
1. About_AzureHelper.help.txt - a help file to import on module load.

Format Files
1. AzureHelper.Format.PS1XML - has improved XML for:
  . Type         : Microsoft.WindowsAzure.Commands.ServiceManagement.Model.PersistentVMRoleListContext
    Returned from: Get-AzureVM.
  . Type         : Microsoft.WindowsAzure.Commands.ServiceManagement.Model.InputEndpointContext
    Returned from: GetAzureEndpoint

Contact
tfl@psp.co.uk
