# Get the current directory where the script is located
$scriptPath = Get-Location

# Set the execution policy to Unrestricted for the current process (does not require administrative privileges)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force

# Define the path to "runme.ps1" and "mimi.ps1" scripts in the same location as this script
$runmeScriptPath = Join-Path -Path $scriptPath -ChildPath "secret\runme.ps1"
$mimiScriptPath = Join-Path -Path $scriptPath -ChildPath "secret\mimi.ps1"


# Change to the script's directory
Set-Location -Path $scriptPath

# Define the command to be executed in the terminal for "runme.ps1"
$runmeCommand = "Set-ExecutionPolicy Bypass -Scope Process -Force; $runmeScriptPath"

# Start a new PowerShell process to run "runme.ps1" with administrative privileges
Start-Process powershell -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command $runmeCommand" -Verb RunAs -WindowStyle Hidden

# Wait for a few seconds to ensure that "runme.ps1" starts before launching "mimi.ps1"
Start-Sleep -Seconds 8

# Define the command to be executed in the terminal for "mimi.ps1"
$mimiCommand = "Set-ExecutionPolicy Bypass -Scope Process -Force; $mimiScriptPath"

# Start a new PowerShell process to run "mimi.ps1" with administrative privileges
Start-Process powershell -ArgumentList "-NoExit -ExecutionPolicy Bypass -Command $mimiCommand" -Verb RunAs -WindowStyle Hidden
