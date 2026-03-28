output "droplet_ip" {
  description = "Public IP of the Droplet"
  value       = digitalocean_droplet.shop.ipv4_address
}

output "droplet_id" {
  description = "Droplet ID"
  value       = digitalocean_droplet.shop.id
}

output "ssh_command" {
  description = "SSH command to connect"
  value       = "ssh root@${digitalocean_droplet.shop.ipv4_address}"
}