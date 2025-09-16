# Recurso que descarga la imagen oficial de Redis versión 7.4.1 en su variante ligera "alpine"
resource "docker_image" "redis" {
  name = "redis:7.4.1-alpine"
}

# Recurso que crea y configura un contenedor Docker con Redis
resource "docker_container" "redis" {

# El nombre del contenedor incluye el workspace de Terraform (ej: dev, qa, prod)  
name = "redis-${terraform.workspace}"

# Se usa la imagen definida arriba
image = docker_image.redis.image_id

# Conexión del contenedor a la red de persistencia 
networks_advanced {
    name = docker_network.persistence_net.name
  }

# Expone el puerto 6379 (interno de Redis) hacia el mismo puerto en el host
  ports {
    internal = 6379
    external = 6379
  }

# Asegura que el contenedor se reinicie automáticamente en caso de error o reinicio del sistema  
restart = "always"
  

}
