resource "docker_image" "nginx" {
  name         = "nginx:stable-alpine3.21-perl"
  keep_locally = false
}

resource "docker_container" "nginx" {
  count = var.nginx_container_count
  
  name  = "app-${terraform.workspace}-${count.index + 1}"
  image = docker_image.nginx.image_id
  
  networks_advanced {
    name = docker_network.app_net.name
  }
  
  networks_advanced {
    name = docker_network.persistence_net.name
  }

  ports {
    internal = 80
    external = var.nginx_base_port + count.index
  }
}