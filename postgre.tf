resource "docker_image" "postgres" {
  name = "postgres:15-alpine"
}

resource "docker_container" "postgres" {
  image = docker_image.postgres.image_id
  name  = "postgres-${terraform.workspace}"
  
  networks_advanced {
    name = docker_network.persistence_net.name
  }
  
  ports {
    internal = 5432
    external = 5432
  }

  env = [
    "POSTGRES_DB=myapp",
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=password"
  ]
}