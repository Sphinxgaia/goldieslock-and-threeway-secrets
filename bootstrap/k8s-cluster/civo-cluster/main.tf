# Query xsmall instance size
data "civo_size" "xsmall" {
    filter {
        key = "type"
        values = ["kubernetes"]
    }

    sort {
        key = "ram"
        direction = "asc"
    }
}

# Create a firewall
resource "civo_firewall" "my-firewall" {
    name = "${var.story_name}-firewall"
}

# Create a firewall rule
resource "civo_firewall_rule" "kubernetes" {
    firewall_id = civo_firewall.my-firewall.id
    protocol = "tcp"
    start_port = "6443"
    end_port = "6443"
    cidr = ["86.198.153.97/32"]
    direction = "ingress"
    label = "kubernetes-api-server"
}

# Create a firewall rule
resource "civo_firewall_rule" "ingress_http" {
    firewall_id = civo_firewall.my-firewall.id
    protocol = "tcp"
    start_port = "80"
    end_port = "80"
    cidr = ["86.198.153.97/32"]
    direction = "ingress"
    label = "kubernetes-ingress-server"
}

# Create a firewall rule
resource "civo_firewall_rule" "ingress_https" {
    firewall_id = civo_firewall.my-firewall.id
    protocol = "tcp"
    start_port = "443"
    end_port = "443"
    cidr = ["86.198.153.97/32"]
    direction = "ingress"
    label = "kubernetes-secingress-server"
}

# Create a firewall rule
resource "civo_firewall_rule" "nodeports" {
    firewall_id = civo_firewall.my-firewall.id
    protocol = "tcp"
    start_port = "30000"
    end_port = "32767"
    cidr = ["86.198.153.97/32"]
    direction = "ingress"
    label = "kubernetes-nodeport-server"
}

# Create a cluster
resource "civo_kubernetes_cluster" "my_kube_cluster" {
    name = var.story_name
    applications = ""
    num_target_nodes = 2
    target_nodes_size = element(data.civo_size.xsmall.sizes, 0).name
    firewall_id = civo_firewall.my-firewall.id
}

resource "local_file" "kubeconfig" {
    content     = civo_kubernetes_cluster.my_kube_cluster.kubeconfig
    filename = "${path.module}/kubeconfig"
}