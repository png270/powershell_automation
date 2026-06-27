<#Some addutional PowerShell commands that can help with extracting relevant information.
Use as per requirement.
#>

#System Health

#CPU USAGE

<#This gives % of CPU utilization across all the processors. 
While it alone cannot indicate malicious actibity, unusually high CPU utilization can idicate something wrong.
#>
$processor_time = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue

if ($processor_time -gt 20){
    Write-Host "Something maybe wrong?"
    Write-Host $processor_time
}
Else {
    Write-Host "Seems normal, ig?"
    Write-Host $processor_time
}

(Get-CimInstance Win32_Processor).LoadPercentage #Tells you the current average load on each processor.
#Per-core CPU Usage
Get-Counter '\Processor(*)\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue #Gives incividual core's CPU utilization, incredibly high values of core usage during idle state can idicate running of background process

(Get-Counter '\System\Processor Queue Length').CounterSamples.CookedValue #pending threads waiting for CPU cycles, high value == CPU Bottleneck (Meaning, CPU is slower than other hardware compoments of the system)

#Processor Interrupts/DPC Rates - Recommended to compare these value against baselines collected from a clean system state
Get-Counter '\Processor(_Total)\Interrupts/sec' #when the computer is idle and it still shows high value of processor time handling interrupts indicate unusual performance. Interrurpts are normally signals sent by SW/HW to indicate they need processors attention.



#MEMORY USAGE

#Available Memory
(Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
#Committed Bytes in Use
(Get-Counter '\Memory\% Committed Bytes In Use').CounterSamples.CookedValue
#Paging Activity (Pages/Sec) -- High Values incdicates RAM exhaustion
(Get-Counter '\Memory\Pages/sec').CounterSamples.CookedValue
#Nonpaged Bytes/Kernel Memory -- High Values indicate memory leaks in drivers
(Get-Counter '\Memory\Pool Nonpaged Bytes').CounterSamples.CookedValue


#DISK MONITORING

# Logical Disk Space
Get-CimInstance Win32_LogicalDisk | Select-Object DeviceID, VolumeName, @{Name='SizeGB';Expression={$_.Size / 1GB -as [int]}}, @{Name='FreeGB';Expression={$_.FreeSpace / 1GB -as [int]}}, @{Name='FreePercent';Expression={[math]::Round($_.FreeSpace / $_.Size * 100, 2)}} | Format-Table -AutoSize
# Disk Queue Length
Get-Counter '\LogicalDisk(*)\Current Disk Queue Length' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
# Disk Read/Write Bytes/Sec
Get-Counter '\LogicalDisk(*)\Disk Read Bytes/sec', '\LogicalDisk(*)\Disk Write Bytes/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
# Disk Latency (Avg. Disk sec/Read, Avg. Disk sec/Write) -- Considtent values >20ms == concerning
Get-Counter '\LogicalDisk(*)\Avg. Disk sec/Read', '\LogicalDisk(*)\Avg. Disk sec/Write' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
# Disk Transfers/sec -- Total I/O rate
Get-Counter '\LogicalDisk(*)\Disk Transfers/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue
# Drive Health (SMART Status)
Get-CimInstance -ClassName MSFT_PhysicalDisk -Namespace ROOT\Microsoft\Windows\Storage | Select-Object DeviceId, FriendlyName, HealthStatus, OperationalStatus, Size
# Last Boot Uptime
(Get-CimInstance Win32_OperatingSystem).LastBootUpTime
# System Uptime Duration
(Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime


#File Integrity Checks

sfc /scannow  #works only in a terminal with administrator privileges


#User Account Monitoring
#Some of these commands query windows event viewer logs, instead of checking it manually, you can modify these commands and use them to query events.

# New User Account
Get-WinEvent -LogName Security -FilterXPath '*[System[(EventID=4720)]]' | Select-Object TimeCreated, Message, @{Name='TargetUserName'; Expression={$_.Properties[5].Value}}
# User Account Deletion
Get-WinEvent -LogName Security -FilterXPath '*[System[(EventID=4726)]]' | Select-Object TimeCreated, Message, @{Name='TargetUserName'; Expression={$_.Properties[4].Value}}
# User Account Enable/Disable
Get-WinEvent -LogName Security -FilterXPath '*[System[(EventID=4722 or EventID=4725)]]' | Select-Object TimeCreated, Message
# Password Changes
Get-WinEvent -LogName Security -FilterXPath '*[System[(EventID=4723 or EventID=4724)]]' | Select-Object TimeCreated, Message
# Group Membership Changes
Get-WinEvent -LogName Security -FilterXPath '*[System[(EventID=4728 or EventID=4732 or EventID=4733)]]' | Select-Object TimeCreated, Message
# Successful Logons
Get-WinEvent -LogName Security -FilterXPath '*[System[(EventID=4624)]]' -MaxEvents 50 | Select-Object TimeCreated, @{Name='AccountName'; Expression={$_.Properties[6].Value}}, @{Name='LogonType'; Expression={$_.Properties[8].Value}}, @{Name='SourceNetworkAddress'; Expression={$_.Properties[18].Value}}
# Failed Logins
Get-WinEvent -LogName Security -FilterXPath '*[System[(EventID=4625)]]' -MaxEvents 50 | Select-Object TimeCreated, @{Name='AccountName'; Expression={$_.Properties[6].Value}}, @{Name='LogonType'; Expression={$_.Properties[8].Value}}, @{Name='SourceNetworkAddress'; Expression={$_.Properties[18].Value}}, @{Name='FailureReason'; Expression={$_.Properties[19].Value}}


# Local User Accounts
Get-LocalUser | Select-Object Name, Enabled, PasswordLastSet, LastLogon
# Local Admin Group Members
Get-LocalGroupMember -Group Administrators | Select-Object Name, PrincipalSource


#Services

# All Services
Get-Service | Sort-Object DisplayName
# Stopped Services
Get-Service | Where-Object {$_.Status -eq 'Stopped'} | Select-Object DisplayName, Name, Status, StartType
# Servces with Startup Type Disabled
Get-Service | Where-Object {$_.StartType -eq 'Disabled'}
# Services not running and set to automatic
Get-Service | Where-Object {$_.Status -eq 'Stopped' -and $_.StartType -eq 'Automatic'} | Select-Object DisplayName, Name, Status, StartType
# Service errors in event Log
Get-WinEvent -LogName System -FilterXPath '*[System[(EventID >= 7000 and EventID <= 7045)]]' -MaxEvents 50 | Select-Object TimeCreated, Id, LevelDisplayName, Message | Format-List


#Processes
# All running Processes
Get-Process
# Top-10 processes by CPU Usage
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 ProcessName, Id, CPU, WS, Handles
# Top-10 Processes by Memory Usage
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 ProcessName, Id, WS, CPU, Handles
# Processe with high handle count -- high == indicate resource leaks
Get-Process | Sort-Object Handles -Descending | Select-Object -First 10 ProcessName, Handles, CPU, WS
# Processes started by a specific users
Get-CimInstance Win32_Process | Select-Object ProcessId, Name, CommandLine, @{n='Owner';exp={$_.GetOwner().User}} | Where-Object {$_.Owner -eq 'Administrator'}
# Processes listening on Network ports/Netstat info
Get-NetTCPConnection | Where-Object {$_.State -eq 'Listen'} | ForEach-Object {
    $process = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
    if ($process) {
        [PSCustomObject]@{
            ProcessName = $process.ProcessName
            PID = $_.OwningProcess
            LocalAddress = $_.LocalAddress
            LocalPort = $_.LocalPort
            State = $_.State
        }
    }
} | Format-Table -AutoSize

#processes without window
Get-Process | Where-Object { -not $_.HasMainWindow } | Select-Object ProcessName, Id, Path, StartTime, CPU, WS

#Network Activity

#Network adapter status and speed
Get-NetAdapter | Select-Object Name, Status, LinkSpeed, MacAddress

#Detailed IP config
Get-NetIPConfiguration | Select-Object InterfaceAlias, IPv4Address, IPv6Address, DNSServer

#Actve TCP Connections
Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State, OwningProcess | Format-Table -AutoSize

#Listening ports
Get-NetTCPConnection -State Listen | Select-Object LocalAddress, LocalPort, OwningProcess, @{Name='ProcessName'; Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName}} | Format-Table -AutoSize

#DNS Client Cache
Get-NetTCPConnection -State Listen | Select-Object LocalAddress, LocalPort, OwningProcess, @{Name='ProcessName'; Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName}} | Format-Table -AutoSize

#Network Stats
Get-Counter '\Network Interface(*)\Bytes Total/sec' | Select-Object -ExpandProperty CounterSamples | Select-Object InstanceName, CookedValue

#Firewall Inbound and Outbound Blocks
Get-NetFirewallRule -PolicyStore ActiveStore | Where-Object {$_.Action -eq 'Block'} | Select-Object DisplayName, Direction, Action, Enabled, Protocol, LocalPort, RemotePort | Format-Table -AutoSize

#Firewall Status
Get-NetFirewallProfile -Name Domain, Private, Public | Select-Object Name, Enabled, FirewallEnabled


#Task Monitoring

#All scheduled tasks
Get-ScheduledTask | Select-Object TaskName, State, LastRunTime, LastTaskResult, Author

#Tasks enabled but not running
Get-ScheduledTask | Where-Object {$_.State -ne 'Running' -and $_.Enabled -eq $true -and $_.LastTaskResult -ne 0} | Select-Object TaskName, State, LastRunTime, LastTaskResult, Author

#Failed scheduled tasks
Get-ScheduledTask | Where-Object {$_.LastTaskResult -ne 0 -and $_.LastTaskResult -ne $null} | Select-Object TaskName, State, LastRunTime, LastTaskResult, Author

#Tasks scheduled to run more frequently
Get-ScheduledTask | Where-Object { ($_.Triggers | Where-Object {$_.Enabled -eq $true -and $_.RepetitionInterval -lt (New-TimeSpan -Hours 1) -and $_.RepetitionInterval -ne $null}) } | Select-Object TaskName, State, @{N='Interval';E={$_.Triggers[0].RepetitionInterval}}

#Scheudled tasks creation and modifications 
Get-WinEvent -LogName Security -FilterXPath '*[System[(EventID=4698 or EventID=4700 or EventID=4702)]]' -MaxEvents 50 | Select-Object TimeCreated, Message

