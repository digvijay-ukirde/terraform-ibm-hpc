resource "local_file" "create_playbook" {
  count    = var.inventory_path != null ? 1 : 0
  content  = <<EOT
# Ensure provisioned VMs are up and Passwordless SSH setup has been established

- name: Check passwordless SSH connection is setup
  hosts: all
  any_errors_fatal: true
  gather_facts: false
  connection: local
  tasks:
    - name: Check passwordless SSH on all scale inventory hosts
      shell: echo PASSWDLESS_SSH_ENABLED
      register: result
      until: result.stdout.find("PASSWDLESS_SSH_ENABLED") != -1
      retries: 60
      delay: 10
  vars:
    ansible_ssh_common_args: >-
      -o ControlMaster=auto
      -o ControlPersist=30m
      -o UserKnownHostsFile=/dev/null
      -o StrictHostKeyChecking=no
      -o ProxyCommand="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.private_key_path} -J ubuntu@${var.bastion_fip} -W %h:%p root@{{ inventory_hostname }}"
EOT
  filename = var.playbook_path
}

# TODO: Replace the ansible playbook run with ansible provider
resource "null_resource" "run_playbook" {
  count = var.inventory_path != null ? 1 : 0
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "which ansible; /usr/bin/ansible-playbook -i ${var.inventory_path} ${var.playbook_path}"
  }
  triggers = {
    build = timestamp()
  }
  depends_on = [local_file.create_playbook]
}
