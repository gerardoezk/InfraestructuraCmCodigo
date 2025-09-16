// Capa de Aplicacion
resource "docker_network" "app_net" {
  name   = "app_net"
  driver = "bridge"
}

// Capa de Persistencia
resource "docker_network" "persistence_net" {
  name   = "persistence_net"
  driver = "bridge"
}

// Capa de Monitoreo
resource "docker_network" "monitor_net" {
  name   = "monitor_net"
  driver = "bridge"
}