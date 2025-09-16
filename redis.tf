resource "docker_image" "redis" {
  name = "redis:7.4.1-alpine"
}

resource "docker_container" "redis" {
  name = "redis-${terraform.workspace}"
  image = docker_image.redis.image_id

  networks_advanced {
    name = docker_network.persistence_net.name
  }

  ports {
    internal = 6379
    external = 6379
  }

  restart = "always"
  
}