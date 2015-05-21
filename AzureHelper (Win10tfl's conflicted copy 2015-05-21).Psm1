# Azure Helper - Main module script
#
Write-Host 'Installing Azure Helper module'
Write-Verbose "In Main Module Script of AzureHelper"

# Dot Source module functions
. .\Set-tflAzureVMSize.ps1            # works
. .\New-tflHttpVmEndPoint.ps1         # 
. .\Set-CurrentAzureSubscription.ps1

# Some More Aliases
Set-Alias gavm Get-AzureVM

# more will go here later!
# All Done

Write-Verbose 'Completing Azure Helper Initialisation'
Write-Host 'Added Azure Helper module'