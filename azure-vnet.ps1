# making azure MMVPN

# Remove old certs
(Get-ChildItem -Path cert:\CurrentUser\My | where subject -match 'azure') | Remove-Item -ea 0
(Get-ChildItem -Path Cert:\LocalMachine\root | where subject -match 'azure') | Remove-Item -ea 0
'Old Certs Removed'

# Create self signed root and put in tr store
C:\foo\azure\makecert.exe -n "CN=Azure-P2S-Root-Cert"   -sky exchange -r -pe -a sha1 -len 2048 -ss My
c:\foo\azure\makecert.exe -n "CN=Azure-P2S-Client-Cert" -sky exchange -pe  -m 96 -ss My -in "Azure-P2S-Root-Cert" -is my -a sha1
'New Certs Created'

# Export root Cert and remove from local store
$cert = Get-ChildItem -Path cert:\CurrentUser\My | where subject -match 'azure-p2s-root-cert'
Export-Certificate -Cert $cert -FilePath c:\foo\azure\p2srootcert.cer
Get-ChildItem -Path cert:\CurrentUser\My | where subject -match 'azure-p2s-root-cert' | Remove-Item
'Root Cert exported to .cer file'

# Export personal cert as pfx
$cert = Dir Cert:\CurrentUser\my | Where-Object subject -match 'Azure-P2S-Client-Cert'
Export-Certificate -Type CERT -FilePath c:\foo\azure\p2sclientcert.pfx -Cert $cert
'Client Cert exported to .pfx file'
