data "template_file" "cloud_config" {
  template = "${file("${path.module}/cloud-config/cloud-config.yaml.tpl")}"

  vars {
    ssh_authorized_keys = "ssh_authorized_keys: ${jsonencode(local.user_public_keys)}"
    environment         = "${local.environment}"
    project             = "blockchain"
    role                = "bastion"
  }
}

data "template_file" "mounts_sh" {
  template = "${file("${path.module}/cloud-config/mounts.sh.tpl")}"

  vars {
    file_system_id = "${local.file_system_id}"
  }
}

data "template_file" "docker_daemon_sh" {
  template = "${file("${path.module}/cloud-config/docker-daemon.sh.tpl")}"
}

data "template_file" "docker_client_sh" {
  template = "${file("${path.module}/cloud-config/docker-client.sh.tpl")}"

  vars {}
}

data "template_file" "mysql_client_sh" {
  template = "${file("${path.module}/cloud-config/mysql-client.sh.tpl")}"

  vars {
    db_fqdn = "${local.db_fqdn}"
  }
}

data "template_file" "motd_sh" {
  template = "${file("${path.module}/cloud-config/motd.sh.tpl")}"

  vars {}
}

data "template_cloudinit_config" "user_data" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content      = "${data.template_file.cloud_config.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "00_mounts.sh"
    content      = "${data.template_file.mounts_sh.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "10_docker-daemon.sh"
    content      = "${data.template_file.docker_daemon_sh.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "20_docker-client.sh"
    content      = "${data.template_file.docker_client_sh.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "30_mysql-client.sh"
    content      = "${data.template_file.mysql_client_sh.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "40_motd.sh"
    content      = "${data.template_file.motd_sh.rendered}"
  }
}
