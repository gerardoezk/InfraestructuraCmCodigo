# Variable que define la cantidad de contenedores Nginx a crear.
# Su valor se asigna en el archivo terraform.tfvars.
variable "nginx_container_count" {
  type = number   # El valor debe ser un número (ej: 3)
}

# Variable que define el puerto base desde el cual se expondrán los contenedores.
# También se asigna en terraform.tfvars.
variable "nginx_base_port" {
  type = number   # El valor debe ser un número (ej: 8080)

}
