# Recurso que descarga la imagen oficial de PostgreSQL versión 15 en su variante ligera "alpine"
resource "docker_image" "postgres" {
  name = "postgres:15-alpine"
}

# Recurso que crea y configura un contenedor Docker con la base de datos PostgreSQL 
resource "docker_container" "postgres" {
 
# Le indicamos que use la imagen descargada arriba
  image = docker_image.postgres.image_id

# El nombre del contenedor incluirá el "workspace" de Terraform (ej: dev, qa, prod)
  name  = "postgres-${terraform.workspace}"

# Conexión a una red Docker previamente definida (persistence_net)
  networks_advanced {
    name = docker_network.persistence_net.name
  }

# Exponemos el puerto 5432 (interno de Postgres) hacia el puerto 5432 del host
  ports {
    internal = 5432
    external = 5432
  }

# Variables de entorno necesarias para inicializar la base de datos
  env = [
    "POSTGRES_DB=myapp",             # Nombre de la base de datos inicial
    "POSTGRES_USER=postgres",        # Usuario administrador
    "POSTGRES_PASSWORD=password"     # Contraseña del usuario
  ]

}
