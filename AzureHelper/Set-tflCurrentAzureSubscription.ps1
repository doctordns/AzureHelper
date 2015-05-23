Function Set-tflCurrentAzureSubscription {
<#
.SYNOPSIS
    This script changes the current Azure Subscription
.DESCRIPTION
    This script defines a function to get the Azure subscriptions
    in the current Azure Account, and sets one to be the current. 
    You specifiy  an ordinal number to select the subscription 
    where 0 is the first subscription, 1 the next, etc. The function
    checks to ensure the number you specifed is valid, returnign 'try again'
    if not.
.NOTES
    File Name  : Set-CurrentAzureSubscription.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0
    Tested     : PowerShell Version 5
.LINK
    This script posted to Github:
        https://github.com/Azure/azure-powershell

.EXAMPLE
    See:
        http://tfl09.blogspot.co.uk/2015/05/managing-multiple-azure-subscriptions.html
#>

[CmdletBinding()]
Param($SubscriptionNumber) 
# Check minimum sub number
If ($subscriptionNumber -lt 0) {return 'Try again'}

# Get azure subs
$Subs = Get-AzureSubscription

# check the upper bound
If ($SubscriptionNumber -GE $Subs.count) {return 'try again'}

# set the sub as current
$Subs[$subscriptionNumber] |Select-AzureSubscription -Current
# and say so
"Subscription [$($subs[$subscriptionNumber].SubscriptionName)] set as current"
}
