$VerbosePreference = 'continue'
$AzureHelper = Get-Module -Name AzureHelper -ListAvailable
Write-Verbose "You currently have version $($AzureHelper.Version.ToString()) loaded"


# Get the URI

$uri = 'https://api.github.com/repos/doctordns/azurehelper/releases/latest'
$LatestRelease = Invoke-RestMethod -Uri $uri -Method GET

Write-Verbose "Latest Version on GitHub: [$LatestVersionNumber]"
$latestrelease
$LatestVersionNumber = $LatestRelease.name




# Get latest version on GitHub
$LatestRelease = Invoke-RestMethod -Uri https://api.github.com/repos/Azure/azure-powershell/releases/latest -Method GET
$LatestVersionNumber = $LatestRelease.name
Write-Verbose "Latest Version on GitHub: [$LatestVersionNumber]"

