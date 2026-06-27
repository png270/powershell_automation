## Usage Instructions
### _Playbook Scripts_

This project consists of sample PowerShell and Python scripts for comparing data against baselines. This project is based on the Playbooks created for gathering useful information during major cybersecurity incidents like DoS, Ransomware, Phshing etc. It automates the commands required to be run while executing the playbooks.

#### Project Structure
The project directory is as follows - 
- diff.py - Python script that compare current output with the baselines. Uses difflib library to perfrom the comaprison.
- pb_001.ps1 - PowerShell script based on the playbook - 001 Generic System Check
- pb_002.ps1 - PowerShell script based on the playbook - 002 Dos\_DDoS
- pb_003.ps1 - PowerShell script based on the playbook - 003 Ransomware
- analysis.txt - Text file genereated by Python script containing results of comparison. File gets overwwriten everytime the Python script is run.

#### Usage

> Note - The PowerShell scripts in this project can be used to generate both baselines and gather current metrics from the host system. It requires file path modifications to store and name the files accurately.

##### Generate Baselines
To generate baselines from the clean state of a host system, modify file paths and names in the scripts before executing them. Store baseline ouptputs at a secured location.

##### Generate Current Metrics
To gather relevant metrics from the current state of the system, modify file names and paths in the scripts before executing them.

Run the command below on a terminal to execute PowerShell scripts -
```sh
./script_name.ps1
```
> Where [script_name] is the relevant PowerShell file name.

##### Perform Comparison
To compare current metrics with the baselines, run the diff.py Python script. Use the command below on a terminal - 
```sh
python diff.py
```
> How to interpret the output? 
 `+` : Line was added.
 `-` : Line was removed.
 `?` : Shows what was changed. `^^` underneath certain characters show where the changes happened. It also shows which characters were added and which were removed. View the line above `?` symbol. That particular line was changed.
 For unchanged lines, no symbols will be added as a prefix. If you get the output as it is, consider no changes were found.

###### Script Details 
The Python script uses `difflib` library to comapre two files and print the differences. However, before the comparison is run, data from both the files is stored in a list as blocks of lines for each command. These blocks are identified by regular expressions that look for starting and closing tags in the PowerShell output. The PowerShell scripts are designed to add these tags before executing the required commands.

> Note - There is an extra script in the directory named as `shell.ps1`. This script has advanced PS commands that can used to calculate CPU, Memory, Disk usage. The commands mentioned here can also be used to query event viewer logs. Can run specific commands from here in the PowerShell terminal as required.




