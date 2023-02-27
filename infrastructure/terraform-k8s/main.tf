terraform {
required_providers {
    vkcs = {
      source  = "vk-cs/vkcs"
    }
}
}

data "vkcs_kubernetes_clustertemplate" "ct" {
  version = "1.21.4"
}

resource "vkcs_kubernetes_cluster" "k8s-cluster" {
  depends_on = [
    vkcs_networking_router_interface.k8s,
  ]

  name                = "k8s-cluster"
  cluster_template_id = data.vkcs_kubernetes_clustertemplate.ct.id
  master_flavor       = data.vkcs_compute_flavor.k8s.id
  master_count        = 1

  network_id          = vkcs_networking_network.k8s.id
  subnet_id           = vkcs_networking_subnet.k8s-subnetwork.id
  floating_ip_enabled = true
  availability_zone   = "MS1"
  insecure_registries = ["1.2.3.4"]
}

# TODO описать переменные
resource "vkcs_kubernetes_node_group" "groups" {
    cluster_id = vkcs_kubernetes_cluster.k8s-cluster.id

    node_count = 1
    name = "default"
    max_nodes = 5
    min_nodes = 1
}