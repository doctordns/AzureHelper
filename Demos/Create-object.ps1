Function Create-Object {
# Create one object instance
$myobject = New-Object System.Management.Automation.PSObject
$myobject | Add-Member -Name 'Reg'    -Value 'XKE1' -MemberType NoteProperty
$myobject | Add-Member -Name 'Model'  -Value 'Jaguar XKE' -MemberType NoteProperty
$myobject | Add-Member -Name 'Colour' -Value 'BRG' -MemberType NoteProperty
$myobject | Add-Member -Value {[DateTime]::Now} -Name TimeStamp -MemberType ScriptProperty
# Output it
$myobject

#create another instance
$myobject = New-Object System.Management.Automation.PSObject
$myobject | Add-Member -Name 'Reg'    -Value 'LB01 0EF' -MemberType NoteProperty
$myobject | Add-Member -Name 'Model'  -Value 'BMW 350i' -MemberType NoteProperty
$myobject | Add-Member -Name 'Colour' -Value 'Silver' -MemberType NoteProperty
$myobject | Add-Member -Value {[DateTime]::Now} -Name TimeStamp -MemberType ScriptProperty
# Output it
$myobject
}
