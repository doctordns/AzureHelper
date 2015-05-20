
$Accounts = Get-AzureAccount

foreach ($account in $accounts) 
{
  $Subs = $account.subscriptions
  Foreach ($sub in $subs) 
  {
    if ($sub -ne $null) 
    {
      $subdetail = Get-AzureSubscription -SubscriptionId $sub
      if ($subdetail.CurrentStorageAccountName -ne $null)
      {
        Select-AzureSubscription -Current -Subscriptionid $subdetail.SubscriptionId 
        "For Subscription $sub"
        $accounts = Get-AzureStorageAccount       
        "  {0} storage accounts" -f $accounts.count
        foreach ($account in $accounts) 
        {
        "     {0,-15}  {1}" -f $account.label,$account.georeplicatedenabled
      
        }
      }
    }
  }
  
}