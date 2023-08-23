#Start-Process powershell -Verb RunAs
Start-Sleep -Seconds 5
#Import-Module Defender
Set-MpPreference -DisableRealtimeMonitoring $true
