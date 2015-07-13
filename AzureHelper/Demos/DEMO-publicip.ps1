# Using Public IP for a vm

$vmname    = 'windy100'
$vmservice = 'windy100'
$location = 'West Europe'
$ipname = 'bunty'
$label = 'testing'


Get-AzureVM -ServiceName $vmservice -Name $vmname | Set-AzurePublicIP -PublicIPName windyip | Update-AzureVM