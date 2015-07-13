$WarningPreference = 'silentlycontinue'
$Accounts = Get-AzureAccount
Write-Verbose ("{0} Accounts retreived" -f $accounts.count)

Foreach ($account in $accounts) 
{
  $Subs = $account.subscriptions
  Write-Verbose "Processing subscription [($subs-$($subs.count)]"
  Foreach ($sub in $subs) 
  {
# skip null sub or subs with bad guid
    if (! $sub) {continue} # Null sub, just continue
    $g = [system.guid]::Empty
    if (! ([system.guid]::TryParse($sub, [ref] $g)))
         {continue}
    $subdetail = Get-AzureSubscription -SubscriptionId $sub
    if ($subdetail.CurrentStorageAccountName -ne $null)
      {
        if (! $subdetail.subscriptionid) {continue}
        Select-AzureSubscription -Current -Subscriptionid $subdetail.SubscriptionId 
        "For Subscription [$sub]"
        $accounts = Get-AzureStorageAccount       
        "  [{0}] storage accounts" -f $accounts.count
        foreach ($account in $accounts) 
        {
        "    {0,-25} {1,-15} {2,-15}" -f $account.label,$account.GeoPrimaryLocation, $account.AccountType
      
        }
      }
    
  }
  
}