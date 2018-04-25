data "template_file" "manager1_cloud_config" {
  template = "${file("${path.module}/cloud-config/cloud-config.yaml.tpl")}"

  vars {
    ssh_authorized_keys = "ssh_authorized_keys: ${jsonencode(local.user_public_keys)}"
  }
}

data "template_file" "manager1_mounts_sh" {
  template = "${file("${path.module}/cloud-config/mounts.sh.tpl")}"

  vars {
    file_system_id = "${local.file_system_id}"
  }
}

data "template_file" "manager1_docker_daemon_sh" {
  template = "${file("${path.module}/cloud-config/docker-daemon.sh.tpl")}"
}

data "template_cloudinit_config" "manager1_user_data" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content      = "${data.template_file.manager1_cloud_config.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "00_mounts.sh"
    content      = "${data.template_file.manager1_mounts_sh.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "10_docker-daemon.sh"
    content      = "${data.template_file.manager1_docker_daemon_sh.rendered}"
  }
}
