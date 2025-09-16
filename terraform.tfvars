# Puerto base desde el cual se van a exponer los contenedores Nginx.
# Ejemplo: si es 8080 y hay varios contenedores, se usarán 8080, 8081, 8082, etc.
nginx_base_port = 8080

# Cantidad de contenedores Nginx que Terraform debe crear.
# En este caso, se desplegarán 3 instancias de Nginx.
nginx_container_count = 3
