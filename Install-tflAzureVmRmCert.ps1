Function Install-tflAzureVmRmCert {
<#
.SYNOPSIS
    Downloads and installs the certificate created or initially uploaded
    during creation of a Windows based Windows Azure Virtual Machine.
.DESCRIPTION
    Downloads and installs the certificate created (or uploaded) during
    the creation of a Windows based Windows Azure Virtual Machine. Running
    this function obtains and installs the certificate into your local machine
    certificate store. Writing to the local host's cert store requires PowerShell
    to run elevated). Once the certificate is installed, you can connect to 
    Azure VMs using SSL to improve security.  This function works against the 
    current Azure subscription, use Set-TflCurrentAzureSubscription or SAS to change it!
.NOTES
    File Name  : Install-tflAzureVmRmCert.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0, Azure module 8.12
    Tested     : PowerShell Version 5

.PARAMETER ServiceName
    The name of the Azure cloud service the virtual machine is deployed in.
.PARAMETER VmName
    The name of the Azure virtual machine to install the certificate for. 
.EXAMPLE
    Install-tflAzureVmRmCert -SubscriptionName "my subscription" -ServiceName "mycloudservice" -Name "myvm1" 
#>
[Cmdletbinding()]
param(
[string] $CloudServiceName, 
[string] $VMName)

Function IsAdmin
{
Write-Verbose 'Checking user is an Admin'
$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
Write-Verbose "User is admin: [$IsAdmin]"
Return $IsAdmin
}

# First, ensure the user is admin and that the VM exists
if((IsAdmin) -eq $false)
{
  Write-Error "Must run PowerShell elevated to install WinRM certificates."
  return
}
If (-not (Get-AzureVM -ServiceName $CloudServiceName -Name $VMName))
 {
   Write-Error "VM $VMName does not exist."
   return
 }

 # Pre-reqs OK so let's get started...
 Write-Verbose "Getting WinRM Certificate for Service: [$CloudServiceName] and VMname: [$VMName]"
$AzureVM   = (Get-AzureVM -ServiceName $CloudServiceName -Name $VMname).vm
$WinRmVmTp = $AzureVM.DefaultWinRMCertificateThumbprint
$AzureX509cert = Get-AzureCertificate -ServiceName $CloudServiceName -Thumbprint $WinRmVmTp -ThumbprintAlgorithm sha1
Write-Verbose "Found certificate with thumbprint: $WinRmVmTp"

# Now get cert into our cert store
# First create a temp file and dump the certificate data to it
$CertTempFile = [IO.Path]::GetTempFileName()
Write-Verbose "Using temp file: [$CertTempFile]"
$AzureX509cert.Data | Out-File $CertTempFile
Write-Verbose 'Temp file contains cert data'

# Create a certificate object from this file
$CertToImport = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 $certTempFile

# Now get the local machine's trusted root store
# first remote old certs
Get-ChildItem Cert:\LocalMachine\Root| where Subject -match $VMName | Remove-Item -ea 0 
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store "Root", "LocalMachine"
Write-Verbose "[$($store.location)] [$($store.name)] cert store found sucessfully"

# Now Add the cert object to the store
$store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
$store.Add($CertToImport)
$store.Close()
Write-Verbose 'Certificate written to Local Machine Trusted Root Store'

# And nuke the temp file	
Remove-Item $certTempFile
Write-Verbose 'Temp file removed'
}

