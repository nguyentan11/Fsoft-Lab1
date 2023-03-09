data "template_file" "Ansible-inventory" {
  template = "${file("${path.module}/ansible-inventory/inventory")}"

  vars = {
    LINUX_HOST_IP = module.newrelic.linux_public_ip
    LINUX_HOST_USER = module.newrelic.instance_username
    WINDOWS_HOST_IP = module.newrelic.windows_public_ip
    WINDOWS_HOST_USER = module.newrelic.username
    WINDOWS_HOST_PASSWORD = module.newrelic.password
  }
}

resource "local_file" "inventory" {
  content  = data.template_file.Ansible-inventory.rendered
  filename = "${path.module}/inventory"
}