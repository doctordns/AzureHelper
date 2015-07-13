# Get-tflAzureHelperFormatting
Function Get-tflAzureHelperFormatting {
<#
.SYNOPSIS
    This function gets the AzureHelper improvements
    to default Azure object formattion
.DESCRIPTION
    This script defines a function that opens the
    FormatXML shipped with AzureHelper and returns
    Azure objects that AzureHelper improves.
    Right not this is simple and does a straightforward parse
    of the XML. But building a custom object with better naming might be possible!
.NOTES
    File Name  : Get-tflAzureHelperFormatting.ps1
    Author     : Thomas Lee - tfl@psp.co.uk
    Requires   : PowerShell Version 3.0
    Tested     : PowerShell Version 5
.LINK
    This script posted to:
        http://www.pshscripts.blogspot.com
    Included in AzureHelper Module at GitHub:
        https://github.com/doctordns/AzureHelper
.EXAMPLE
    
#>

# Start of script - check to see if the module and format file can be found
# If not, just return
$ModuleHome = 'C:\Program Files\WindowsPowerShell\Modules\AzureHelper'
if (! (Test-Path $ModuleHome)) {
  "AzureHelper can not be found at [$ModuleHome]"
  return
}

$FormatFile = join-path $ModuleHome 'AzureHelper.Format.Ps1xml'
if (! (Test-Path $formatfile)) {
  "AzureHelper Formatfile can not be found at [$FormatFile]"
  return
}

# So now we have the format file, open it as XML then
# loop through the views and return each viewname and control type
# So far, all controls are tables (and this will probably remain
# the case, but never say never.
$Fxml = [xml] (Get-Content $FormatFile)
Foreach ($view in $fxml.configuration.ViewDefinitions.View) {
  $view | select-object Name, *control
# You could do a better select-object here, and return better
#  property names, and new property controltype that woudl be either
#  table or list. Fun for the future
}
}

#
# Test it
# Get-tflAzureHelperFormatting