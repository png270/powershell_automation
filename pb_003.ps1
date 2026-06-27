<#Plabybook 003 - Ransomware#>
<#Update file path to specify the path you need the output at;
To create a baseline from this script, modify the file path and mention the name of the baseline file (eg. baseline(#playbook-number).txt);
#>

<#To make script require admin privileges, follow instructions to uncomment specific lines below-
There should a # character before the keyword 'Requires'. 
Remove the multi-line comment characters below <#....#> #>

<# #Requires -RunAsAdministrator #>
Write-Output "<SHADOW COPY LIST>" >> "output003.txt"
vssadmin list shadows | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\output003.txt" -Append
Write-Output "</SHADOW COPY LIST>" >> "output003.txt"

# Write-Output "<RECURSE>" >> "output003.txt"
# Get-ChildItem -Path C:\ -Recurse | Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-1) } | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\output003.txt" -Append
# Write-Output "</RECURSE>" >> "output003.txt"

Write-Output "<SSH CHECK>" >> "output003.txt"
cmd /c "ssh" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\output003.txt" -Append
Write-Output "</SSH CHECK>" >> "output003.txt"

Write-Output "<TELNET CHECK>" >> "output003.txt"
cmd /c "telnet" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\output003.txt" -Append
Write-Output "</TELNET CHECK>" >> "output003.txt"