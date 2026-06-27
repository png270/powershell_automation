<#Plabybook 002 - DDoS#>
<#Update file path to specify the path you need the output at;
To create a baseline from this script, modify the file path and mention the name of the baseline file (eg. baseline(#playbook-number).txt);
#>

<#To make script require admin privileges, follow instructions to uncomment specific lines below-
There should a # character before the keyword 'Requires'. 
Remove the multi-line comment characters below <#....#> #>

<# #Requires -RunAsAdministrator #>
Write-Output "<TCP CONN LISTEN>" >> "output002.txt"
Get-NetTCPConnection | Where-Object {$_.State -eq "Listen"} | Out-File -FilePath "C:\Users\siddhi.lad\OneDrive - Schulte Group\Desktop\automate\output002.txt" -Append
Write-Output "</TCP CONN LISTEN>" >> "output002.txt"

Write-Output "<NETSTAT ANO>" >> "output002.txt"
cmd /c "netstat -ano" | Out-File -FilePath "C:\Users\siddhi.lad\OneDrive - Schulte Group\Desktop\automate\output002.txt" -Append
Write-Output "</NETSTAT ANO>" >> "output002.txt"
