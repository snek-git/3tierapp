output "self_link" {
  value = google_compute_network.dynamic_vpc.self_link
}

output "subnetwork_self_link" {
  value = google_compute_subnetwork.dynamic_subnetwork["k8subnet"].self_link
}