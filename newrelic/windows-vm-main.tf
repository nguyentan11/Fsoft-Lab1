# Bootstrapping PowerShell Script
data "template_file" "windows-userdata" {
  template = <<EOF
<powershell>
# Rename Machine
# Rename-Computer -NewName "${var.windows_instance_name}" -Force;

# Enable PowerShell Remoting
Enable-PSRemoting -SkipNetworkProfileCheck -Force;

# Restart machine
#shutdown -r -t 5;
# Install Python & set environment variable
cd C:\Users\Administrator\Downloads
Invoke-WebRequest -URI "https://www.python.org/ftp/python/3.11.0/python-3.11.0-amd64.exe" -OutFile "python-3.11.0-amd64.exe";
.\python-3.11.0-amd64.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0;
Start-Sleep -Seconds 30;
#$env:PATH += $env:PATH+";C:\Program Files\Python311";

Invoke-WebRequest -URI "https://aka.ms/wsl-SUSELinuxEnterpriseServer15SP3" -OutFile suselinux15.appx -UseBasicParsing;
Add-AppxPackage .\suselinux15.appx;
Start-Sleep -Seconds 30;
# pip install pywinrm;
winrm create winrm/config/Listener?Address=*+Transport=HTTP;
winrm set winrm/config/service/auth @{CredSSP="true"};

# turn on WSL
#Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All;

Invoke-WebRequest -URI "https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.msi" -OutFile "newrelic-infra.msi";
# msiexec.exe /qn /i "$env:TEMP\newrelic-infra.msi"
# net start newrelic-infra

</powershell>
EOF
}