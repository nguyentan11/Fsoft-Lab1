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
Start-Sleep -Seconds 20;

New-LocalUser -Name "localadmin" -Password (ConvertTo-SecureString -AsPlainText "${data.aws_ssm_parameter.win-pass.value}" -Force);
Add-LocalGroupMember -Group "Administrators" -Member "localadmin";

winrm set winrm/config/service/auth '@{Basic="true"}';
winrm set winrm/config/service '@{AllowUnencrypted="true"}';

</powershell>
EOF
}