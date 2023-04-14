#Requires -RunAsAdministrator

# Setup OpenSSH
# https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=gui#install-openssh-for-windows
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service -Name sshd
Set-Service -Name sshd -StartupType 'Automatic' -PassThru | Select-Object Status, Name, DisplayName, StartType
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Host "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Host "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}
$pwshPath = (Get-Command pwsh).Source
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value $pwshPath -PropertyType String -Force

# Add public key to authorized_keys file on server
$authorizedKeys = Get-Content -Path "$PSScriptRoot\ssh\*.pub"
New-Item -Path $env:USERPROFILE\.ssh -ItemType Directory -Force
Add-Content -Path "$env:USERPROFILE\.ssh\authorized_keys" -Value $authorizedKeys -Force
Add-Content -Path "$env:ProgramData\ssh\administrators_authorized_keys" -Value $authorizedKeys -Force
& icacls "$env:ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
