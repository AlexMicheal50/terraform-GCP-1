# Create a Virtual Network in the resource group
# Create a subnet on the virtual network
# Create public IPs ======== UNCOMPLETED
# Create Network Security Group and rule  ========== UNCOMPLETED
# Firewall rule for the security group
# Connect the security group to the network interface  =========== UNCOMPLETED
# Create an Azure Linux Virtual machine
# Add SSH Key for secure login
# The Disk on the VM will be an Hard Disk drive (default storage is 30GB)
# Copy the IP address into a txt file

data "google_compute_zones" "available_zones" {}

resource "google_compute_address" "static" {
  name = "apache"
}

# Create an Azure Linux Virtual machine
resource "google_compute_instance" "apache" {
  name = "apache"
  zone = data.google_compute_zones.available_zones.names[0]
  tags = ["allow-http"]

  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  metadata_startup_script = file("startup_script.sh")
}



# Firewall rule for the security group
resource "google_compute_firewall" "allow_http" {
  name          = "allow-http-rule"
  network       = "default"
  source_ranges = ["0.0.0.0/0"] # Allow traffic from any source (be cautious with this)

  allow {
    ports    = ["80"]
    protocol = "tcp"
  }

  target_tags = ["allow-http"]

  priority = 1000

}

# Create a Virtual Network in the resource group
resource "google_compute_network" "vpc_network" {
  project                 = "terrafor4gcp"
  name                    = "vpc-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}

# Create a subnet on the virtual network
resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  #  secondary_ip_range {
  #    range_name    = "tf-test-secondary-range-update1"
  #    ip_cidr_range = "192.168.10.0/24"
  #  }
}

resource "google_compute_network" "custom-test" {
  name                    = "test-network"
  auto_create_subnetworks = false
}

resource "google_compute_address" "my-public-ip" {
  name    = "my-public-ip"
  project = "terrafor4gcp"
}


