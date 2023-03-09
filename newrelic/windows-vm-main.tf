# Bootstrapping PowerShell Script
data "template_file" "windows-userdata" {
  template = <<EOF
<powershell>
# Rename Machine
# Rename-Computer -NewName "${var.windows_instance_name}" -Force;

# Enable PowerShell Remoting
Enable-PSRemoting -SkipNetworkProfileCheck -Force;

# Restart machine
# shutdown -r -t 5;

New-LocalUser -Name "${data.aws_ssm_parameter.win-user.value}" -Password (ConvertTo-SecureString -AsPlainText "${data.aws_ssm_parameter.win-pass.value}" -Force);
Add-LocalGroupMember -Group "Administrators" -Member "${data.aws_ssm_parameter.win-user.value}";

winrm set winrm/config/service/auth '@{Basic="true"}';
winrm set winrm/config/service '@{AllowUnencrypted="true"}';

</powershell>
EOF
}