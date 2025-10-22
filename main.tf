data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts"
}

resource "yandex_compute_instance" "bastion-mia" {
  name        = "bastion-mia"
  hostname    = "bastion-mia"
  platform_id = "standard-v4a"
  zone        = "ru-central1-a"

  resources {
    cores         = var.test.cores
    memory        = var.test.memory
    core_fraction = var.test.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.edu_a-mia.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.bastion.id]
  }
}

resource "yandex_compute_instance" "web_a-mia" {
  name        = "web-a-mia"
  hostname    = "web-a-mia"
  platform_id = "standard-v4a"
  zone        = "ru-central1-a"

  resources {
    cores         = var.test.cores
    memory        = var.test.memory
    core_fraction = var.test.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.edu_a-mia.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]
  }
}

resource "yandex_compute_instance" "web_b-mia" {
  name        = "web-b-mia"
  hostname    = "web-b-mia"
  platform_id = "standard-v4a"
  zone        = "ru-central1-b"

  resources {
    cores         = var.test.cores
    memory        = var.test.memory
    core_fraction = var.test.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id          = yandex_vpc_subnet.edu_b-mia.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]

  }
}

# resource "yandex_compute_instance" "web_c-mia" {
#   name        = "web-c-mia"
#   hostname    = "web-c-mia"
#   platform_id = "standard-v4a"
#   zone        = "ru-central1-b"

#   resources {
#     cores         = var.test.cores
#     memory        = var.test.memory
#     core_fraction = var.test.core_fraction
#   }

#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
#       type     = "network-hdd"
#       size     = 10
#     }
#   }

#   metadata = {
#     user-data          = file("./cloud-init.yml")
#     serial-port-enable = 1
#   }

#   scheduling_policy { preemptible = true }

#   network_interface {
#     subnet_id          = yandex_vpc_subnet.edu_b-mia.id
#     nat                = false
#     security_group_ids = [yandex_vpc_security_group.LAN.id, yandex_vpc_security_group.web_sg.id]

#   }
# }

resource "local_file" "inventory" {
  content  = <<-XYZ
  [bastion]
  ${yandex_compute_instance.bastion-mia.network_interface.0.nat_ip_address}

  [webservers]
  ${yandex_compute_instance.web_a-mia.network_interface.0.ip_address}
  ${yandex_compute_instance.web_b-mia.network_interface.0.ip_address}

  # [task3]
  # ${yandex_compute_instance.web_c-mia.network_interface.0.ip_address}
  
  [webservers:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q user@${yandex_compute_instance.bastion-mia.network_interface.0.nat_ip_address}"'

  # [task3:vars]
  # ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q user@${yandex_compute_instance.bastion-mia.network_interface.0.nat_ip_address}"'
  XYZ
  filename = "./hosts.ini"
}