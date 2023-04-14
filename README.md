# Windows OpenSSH Server

Script to set up a [OpenSSH server on Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=gui#install-openssh-for-windows).

This script will also set PowerShell (`pwsh`) as the default shell for SSH sessions. Make sure you have the [latest version of PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows) installed before running the script.

## Usage

1. Place any public keys you want to allow access in the `ssh` folder
2. Run the script `openssh-server.ps1` in a PowerShell session with elevated rights (_Run as Administrator_)
