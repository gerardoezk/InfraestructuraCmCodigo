resource "docker_image" "grafana" {
  name         = "grafana/grafana-enterprise:9.4.7"
  keep_locally = false
}

resource "docker_container" "grafana" {
  image = docker_image.grafana.image_id
  
  name  = "grafana-${terraform.workspace}"
  
  networks_advanced {
    name = docker_network.monitor_net.name
  }
  
  networks_advanced {
    name = docker_network.app_net.name
  }
  
  ports {
    internal = 3000
    external = 3000
  }
  
  restart = "always"
}