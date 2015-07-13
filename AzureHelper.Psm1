# Azure Helper - Main module script
#
Write-Host 'Installing Azure Helper module'
Write-Verbose "In Main Module Script of AzureHelper"

# Dot Source module functions
. $psScriptRoot\Get-tflAzureFormatting.ps1          # added 06.06.2015
. $psScriptRoot\Install-tflAzureVmRmCert.ps1        # 
. $psScriptRoot\New-tflHttpVmEndpoint.ps1           # 
. $psScriptRoot\New-tflLinuxVM.ps1                  # 
. $psScriptRoot\New-tflWindowsVM.ps1                # 
. $psScriptRoot\Set-tflAzureVMSize.ps1              # 
. $psScriptRoot\Set-tflCurrentAzureSubscription.ps1 #
. $psScriptRoot\Update-tflAzureHelperModule.ps1     # added 29.06.2015 
. $psScriptRoot\Update-tflAzurePowerShellModule.ps1 # 


# Set aliases

# Alias to standard Azure functions/cmdlets
Set-Alias gasa Get-AzureStorageAccount
Set-Alias gavm Get-AzureVM
Set-Alias ravm Remove-AzureVM
Set-Alias savm Stop-AzureVM

# Aliases for AzureHelper functions
Set-Alias gaf  Get-tflAzureHelperFormatting
Set-Alias gasa Get-AzureStorageAccount
Set-Alias irc  Install-tflAzureVmRmCert
Set-Alias sas  Set-tflCurrentAzureSubscription
Set-Alias uam  Update-tflAzurePowerShellModule

# Fix Formats
Update-FormatData -PrependPath $PSScriptRoot\AzureHelper.Format.Ps1xml

# All Done

Write-Verbose 'Completing Azure Helper Initialisation'
Write-Host 'Added Azure Helper module'
Write-Host 'Type: Get-Help about_azurehelper for more information'
