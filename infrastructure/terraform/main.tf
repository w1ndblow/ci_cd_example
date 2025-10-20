terraform {
required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.46.0"
    }
    vkcs = {
      source  = "vk-cs/vkcs"
      version = "0.1.6"
    }

}
}
#########################
##          Network

resource "openstack_networking_network_v2" "generic" {
  name = "network-generic"
}

# Наша внешняя сеть называется в наше облоке ext-net
resource "openstack_networking_router_v2" "generic" {
  name                = "router-generic"
  external_network_id = "298117ae-3fa4-4109-9e08-8be5602be5a2"
}

# Создаём локальную сеть
resource "openstack_networking_subnet_v2" "local" {
  name            = "local"
  network_id      = openstack_networking_network_v2.generic.id
  cidr            = "192.168.1.0/24"
  dns_nameservers = ["8.8.8.8", "8.8.8.4"]
}

# Router
resource "openstack_networking_router_interface_v2" "local" {
  router_id = openstack_networking_router_v2.generic.id
  subnet_id = openstack_networking_subnet_v2.local.id
}

# Cоздаём floating ip для того чтобы поподать на виртуалку по внешнему ip
resource "openstack_networking_floatingip_v2" "myip" {
  pool = "ext-net"
}

resource "openstack_compute_floatingip_associate_v2" "ip-test-instance" {
  floating_ip = "${openstack_networking_floatingip_v2.myip.address}"
  instance_id = "${openstack_compute_instance_v2.test-instance.id}"
}


#########################
##    Virtual machine

# System volume with Ubuntu 18.04 for virtual machine
# check 00_openstack.sh
resource "openstack_blockstorage_volume_v2" "test-volume" {
  name        = "test-volume"
  volume_type = "dp1"
  size        = "20"
  image_id    = "e0144f62-cbac-4363-9c3d-dbc7ea799f6d"
}

resource "openstack_compute_instance_v2" "test-instance" {
  name              = "test-instance"
  flavor_id         = "25ae869c-be29-4840-8e12-99e046d2dbd4"
  key_pair          = "${var.keypair_name}"
  availability_zone = "MS1"
  config_drive      = true

  security_groups = [
    "default",
    "ssh+www"
  ]

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.test-volume.id}"
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  metadata = {
    env = "dev"
  }

  network {
    uuid = "${openstack_networking_network_v2.generic.id}"
  }
}


#########################
##   Database

# Cозадаем instance СУБД
resource "vkcs_db_instance" "db-instance" {
  name        = "db-instance"
  keypair     = "${var.keypair_name}"
  flavor_id   = "bf714720-78da-4271-ab7d-0cf5e2613f14"
  size        = 8
  volume_type = "ceph-ssd"
  disk_autoexpand {
    autoexpand    = true
    max_disk_size = 1000
  }

network {
    uuid = "${openstack_networking_network_v2.generic.id}"
    fixed_ip_v4 = "192.168.1.10"
}

datastore {
    version = 13
    type    = "postgresql"
}
}

resource "vkcs_db_database" "app" {
  name        = "appdb"
  dbms_id     = "${vkcs_db_instance.db-instance.id}"
  charset     = "utf8"
}

# Генерим пароль для базы
resource "random_string" "resource_code" {
  length  = 10
  special = false
  upper   = false
}

resource "vkcs_db_user" "app_user" {
  name        = "app_user"
  password    = "${random_string.resource_code.result}"
  dbms_id     = "${vkcs_db_instance.db-instance.id}"

  databases   = ["${vkcs_db_database.app.name}"]
}

#########################
##   Output

resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tpl",
    {
      ip = openstack_networking_floatingip_v2.myip.address
    }
  )
  filename = "../inventory"
}

output "database" {
  value = "db_password ${random_string.resource_code.result} ${vkcs_db_instance.db-instance.network[0].fixed_ip_v4}"
}

resource "local_file" "prod_env" {
  content = templatefile("${path.module}/env.tpl",
    {
      host = vkcs_db_instance.db-instance.network[0].fixed_ip_v4
    }
  )
  filename = "../../.github/prod_env"
}
