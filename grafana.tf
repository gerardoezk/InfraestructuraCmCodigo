/*
  grafana.tf
  Despliega un contenedor Docker para Grafana Enterprise.

  Este servicio se utiliza para visualizar métricas y crear dashboards
  de monitorización. Se conecta a redes específicas para recolectar
  datos de otras herramientas y aplicaciones.
*/

# Descarga la imagen oficial de Grafana. Fijar la versión es una
# buena práctica para garantizar que los despliegues sean siempre consistentes
resource "docker_image" "grafana" {
  # La variante 'enterprise' es compatible con la licencia gratuita (OSS)
  # y permite actualizar a una de pago sin reinstalar.
  name         = "grafana/grafana-enterprise:9.4.7" # nombre y versión de la imagen
  keep_locally = false                              # no mantener la imagen local tras destruir el recurso
}

# Crea, configura y ejecuta el contenedor de Grafana.
resource "docker_container" "grafana" {
  image = docker_image.grafana.image_id              # usa la imagen descargada arriba
  # Esto es clave para poder desplegar entornos de desarrollo, pruebas y
  # producción en la misma máquina sin que los nombres choquen.
  name  = "grafana-${terraform.workspace}"           # nombre dinámico del contenedor

  # Conecta Grafana a la red de monitoreo
  networks_advanced {
    name = docker_network.monitor_net.name
  }

  # Conecta también Grafana a la red de aplicación si necesita acceder a servicios
  networks_advanced {
    name = docker_network.app_net.name
  }

  # Mapea el puerto 3000 interno de Grafana al puerto 3000 de la máquina host.
  # Esto permite acceder a la interfaz web desde un navegador en http://localhost:3000.
  ports {
    internal = 3000  # puerto interno del contenedor
    external = 3000  # puerto externo en el host
  }

  # Configura reinicio automático para asegurar disponibilidad
  restart = "always"
}

