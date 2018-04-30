data "template_file" "manager_cloud_config" {
  template = "${file("${path.module}/cloud-config/manager-cloud-config.yaml.tpl")}"

  vars {
    ssh_authorized_keys = "ssh_authorized_keys: ${jsonencode(local.user_public_keys)}"
    environment         = "${local.environment}"
    project             = "blockchain"
    role                = "manager"
  }
}

data "template_file" "motd_sh" {
  template = "${file("${path.module}/cloud-config/motd.sh.tpl")}"

  vars {
    environment = "${local.environment}"
    project     = "blockchain"
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

data "template_cloudinit_config" "manager_user_data" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content      = "${data.template_file.manager_cloud_config.rendered}"
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
    filename     = "20_motd.sh"
    content      = "${data.template_file.motd_sh.rendered}"
  }
}

data "template_file" "worker_cloud_config" {
  template = "${file("${path.module}/cloud-config/worker-cloud-config.yaml.tpl")}"

  vars {
    ssh_authorized_keys = "ssh_authorized_keys: ${jsonencode(local.user_public_keys)}"
    environment         = "${local.environment}"
    project             = "blockchain"
    role                = "worker"
  }
}

data "template_cloudinit_config" "worker_user_data" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content      = "${data.template_file.worker_cloud_config.rendered}"
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
    filename     = "20_motd.sh"
    content      = "${data.template_file.motd_sh.rendered}"
  }
}
