resource "docker_image" "nginx" {      # se define un recurso de tipo "docker_image" llamado "nginx"
  name         = "nginx:stable-alpine3.21-perl"    #nombre y etiqueta de la imagen de docker
  keep_locally = false                 # la imagen no se mantendrá en local cuando se destruya el recurso
}

resource "docker_container" "nginx" {    # se define un recurso de tipo "docker_container" llamado "nginx"
  count = var.nginx_container_count    # se crean multiples contenedores segun el valor de la variable "nginx_container_count"
  
  name  = "app-${terraform.workspace}-${count.index + 1}"  
  image = docker_image.nginx.image_id  #  Se especifica la imagen a usar, vinculada al recurso "docker_image"
  
  networks_advanced {         # 1º bloque de red avanzada
    name = docker_network.app_net.name  # Conecta el contenedor a la red de aplicación "app_net"
  }
  
  networks_advanced {     # 2º bloque de red avanzada
    name = docker_network.persistence_net.name # # Conecta también el contenedor a la red  "persistence_net"
  }

  ports {  # configuracion del puerto 
    internal = 80  # Puerto interno del contenedor
    external = var.nginx_base_port + count.index #Puerto externo dinámico
  }

}

