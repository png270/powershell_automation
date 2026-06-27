<#Update file path to specify the path you need the output at;
To create a baseline from this script, modify the file path and mention the name of the baseline file (eg. baseline.txt);
#>

<#To make script require admin privileges, follow instructions to uncomment specific lines below-
There should a # character before the keyword 'Requires'. 
Remove the multi-line comment characters below <#....#> #>

<# #Requires -RunAsAdministrator #>

#get systeminfo, PS version 

Write-Output "<SYSTEMINFO>" >> "baseline001.txt"
systeminfo | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</SYSTEMINFO>" >> "baseline001.txt"

Write-Output "<PS Version>" >> "baseline001.txt"
$PSVersionTable | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</PS Version>" >> "baseline001.txt"

#get execution policy details
Write-Output "<EXECUTION POLICY>" >> "baseline001.txt"
Get-ExecutionPolicy | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</EXECUTION POLICY>" >> "baseline001.txt"

Write-Output "<EXECUTION POLICY LIST>" >> "baseline001.txt"
Get-ExecutionPolicy -List | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</EXECUTION POLICY LIST>" >> "baseline001.txt"

#get command history path
Write-Output "<PS COMMAND HISTORY PATH>" >> "baseline001.txt"
(Get-PSReadlineOption).HistorySavePath | Out-File -FilePath "C:\Users\s<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</PS COMMAND HISTORY PATH>" >> "baseline001.txt"


#processes, services and scheduled tasks
Write-Output "<PROCESSES>" >> "baseline001.txt"
Get-Process | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</PROCESSES>" >> "baseline001.txt"

Write-Output "<SERVICES>" >> "baseline001.txt"
Get-Service | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</SERVICES>" >> "baseline001.txt"

Write-Output "<SCHEDULED TASKS>" >> "baseline001.txt"
Get-ScheduledTask | Where-Object {$_.TaskPath -notlike "\Microsoft*"} | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</SCHEDULED TASKS>" >> "baseline001.txt"

#network connections
Write-Output "<TCP CONNECTIONS>" >> "baseline001.txt"
Get-NetTCPConnection | Where-Object { $_.State -eq "Established" } | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</TCP CONNECTIONS>" >> "baseline001.txt"


Write-Output "<FIREWALL RULES>" >> "baseline001.txt"
Get-NetFirewallRule | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</FIREWALL RULES>" >> "baseline001.txt"

Write-Output "<SESSION INFO>" >> "baseline001.txt"
query session | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</SESSION INFO>" >> "baseline001.txt"

#get user account info
$list = cmd /c "net user" #execute command - net user

#get list of users
$userLines = $list[4..($list.Length - 2)]
$userNames = $userLines -join ' ' -split '\s+'

#loop through list of usernames and get info regarding each user
foreach ($user in $userNames) {
    if (($user -ceq "The") -or ($user -ceq "command") -or ($user -ceq "completed") -or ($user -ceq "successfully.")){

    }
    else {
        # execute command - net user <username>
        Write-Output "<USER ACCOUNT INFO>" >> "baseline001.txt"
        cmd /c "net user $user" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
        Write-Output "</USER ACCOUNT INFO>" >> "baseline001.txt"

    }
}

#user account privileges
Write-Output "<CURRENT USER PRIV>" >> "baseline001.txt"
cmd /c "whoami /priv" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</CURRENT USER PRIV>" >> "baseline001.txt"

Write-Output "<ALL USER PRIV>" >> "baseline001.txt"
cmd /c "whoami /all" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</ALL USER PRIV>" >> "baseline001.txt"


#user groups
Write-Output "<LOCAL_GROUPS>" >> "baseline001.txt"
cmd /c "net localgroup" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</LOCAL_GROUPS>" >> "baseline001.txt"


#check the name of the localgroup before running this command, change it, if required.
Write-Output "<ADMIN MEMBERS>" >> "baseline001.txt"
cmd /c "net localgroup Administrators" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</ADMIN MEMBERS>" >> "baseline001.txt"

#ARP & DNS cache
Write-Output "<ARP INFO>" >> "baseline001.txt"
cmd /c "arp -a" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</ARP INFO>" >> "baseline001.txt"

Write-Output "<DNS INFO>" >> "baseline001.txt"
cmd /c "ipconfig /displaydns" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</DNS INFO>" >> "baseline001.txt"


#routing information & active connections
Write-Output "<ROUTE INFO>" >> "baseline001.txt"
cmd /c "route print" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</ROUTE INFO>" >> "baseline001.txt"

Write-Output "<NETSTAT ANO>" >> "baseline001.txt"
cmd /c "netstat -ano" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</NETSTAT ANO>" >> "baseline001.txt"

#enumerate drivers
Write-Output "<SYSTEM DRIVERS>" >> "baseline001.txt"
cmd /c "driverquery" | Out-File -FilePath "C:\Users\<your-folder>\Desktop\automate\baseline001.txt" -Append
Write-Output "</SYSTEM DRIVERS>" >> "baseline001.txt"



