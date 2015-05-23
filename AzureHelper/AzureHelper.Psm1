# Azure Helper - Main module script
#
Write-Host 'Installing Azure Helper module'
Write-Verbose "In Main Module Script of AzureHelper"

# Dot Source module functions
. $psScriptRoot\Install-tflAzureVmRmCert.ps1        # works
. $psScriptRoot\New-tflHttpVmEndpoint.ps1           # works
. $psScriptRoot\New-tflLinuxVM.ps1                  # works
. $psScriptRoot\New-tflWindowsVM.ps1                # works
. $psScriptRoot\Set-tflAzureVMSize.ps1              # works
. $psScriptRoot\Set-tflCurrentAzureSubscription.ps1 # works
. $psScriptRoot\Update-tflAzurePowerShellModule.ps1 # works


# Set some aliases
# Alias to standard Azure functions/cmdlets
Set-Alias gavm Get-AzureVM
Set-Alias ravm Remove-AzureVM
Set-Alias savm Stop-AzureVM
# Aliases for AzureHelper functions
Set-Alias sas  Set-tflCurrentAzureSubscription
Set-Alias uam  Update-tflazurePowerShellModule
Set-Alias IRC  Install-tflAzureVmRmCert

# Fix Formats
Update-FormatData -PrependPath $PSScriptRoot\AzureHelper.Format.Ps1xml

# All Done

Write-Verbose 'Completing Azure Helper Initialisation'
Write-Host 'Added Azure Helper module'