/*
  main.tf
  Propósito: configuración inicial de Terraform y definición del proveedor Docker.
  Este archivo declara que se usará el provider de Docker (kreuzwerker/docker) y su versión.
*/

# Configuramos el proveedor de Docker (Terraform)
terraform {
  required_providers {
    # Declaramos el proveedor de Docker y su version requerida
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
 # Este bloque usa la configuración por defecto y se conecta al cocket local de Docker:
 # unix://var/run/docker.sock
}

# Configuración del proveedor Docker:
# Por defecto se conecta al socket local de Docker (unix:///var/run/docker.sock).

# ¡Este archivo solo declara al proveedor!
