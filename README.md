# Infraestructura como Código con Terraform + Docker

## Grupo e Integrantes

**Grupo:** 8

**Integrantes:**
- VERA ROMERO, VANESA MARILI
- CAIPO TRUJILLO, SONIA FERNANDA
- ASUNCIÓN CHIRA, LUIS GERARDO
- LEYVA SANDOVAL, PIERO ALEJANDRO
- RODRIGUEZ MALCA, RODRIGO ABEL

## Descripción del Proyecto

Este repositorio contiene la configuración de Terraform necesaria para desplegar una infraestructura local completa utilizando el proveedor de **Docker**. El objetivo es automatizar el aprovisionamiento de un entorno de microservicios, demostrando principios de Infraestructura como Código (IaC).

La arquitectura está compuesta por contenedores para las aplicaciones (Nginx), persistencia (PostgreSQL, Redis) y monitoreo (Grafana), organizados y aislados a través de redes dedicadas.

## Imágenes Docker Utilizadas

| Servicio       | Imagen                      | Justificación                                                                                         |
|----------------|----------------------------|------------------------------------------------------------------------------------------------------|
| **Aplicaciones** | `nginx:1.25-alpine`          | Versión estable y ligera de Nginx, ideal como servidor web o proxy inverso. La base Alpine reduce el tamaño de la imagen. |
| **PostgreSQL**   | `postgres:16-alpine`         | Versión reciente de PostgreSQL sobre Alpine Linux, que garantiza menor consumo de recursos y una superficie de ataque reducida. |
| **Redis**        | `redis:7-alpine`             | Versión estable y optimizada de Redis, perfecta para un caché en memoria de alto rendimiento con una imagen base mínima. |
| **Grafana**      | `grafana/grafana-oss:10.1.5` | Imagen oficial de Grafana Open Source. Se fija una versión específica en lugar de `latest` para garantizar la reproducibilidad del entorno. |

## Instrucciones de Uso

### 1. Requisitos Previos
- **Docker** instalado y en ejecución.
- **Terraform** (versión 1.0 o superior) instalado.

### 2. Clonar e Inicializar
```bash
# 1. Clona el repositorio
git clone https://github.com/gerardoezk/InfraestructuraCmCodigo.git

# 2. Ingresa al directorio del proyecto
cd InfraestructuraCmCodigo

# 3. Inicializa Terraform para descargar los proveedores
terraform init
```

### 3. Gestionar Entornos con Workspaces

Se recomienda utilizar workspaces para mantener entornos aislados (ej. dev, qa, prod).

```bash
# (Opcional) Crea un nuevo workspace si no existe
terraform workspace new dev

# Asegúrate de estar en el workspace correcto
terraform workspace select dev
```

### 4. Desplegar la Infraestructura

```bash
# (Recomendado) Visualiza los cambios que Terraform planea realizar
terraform plan

# Aplica los cambios para crear los contenedores y redes
terraform apply

# Confirma la operación escribiendo "yes" cuando se te solicite.

# Verifica que los contenedores estén en ejecución
docker ps

# Para eliminar toda la infraestructura gestionada por Terraform
terraform destroy
```

## Justificación de Puertos y Redes

### Estructura de Redes (`networks.tf`)

- **app_net:** Red para los servicios de aplicación (contenedores Nginx). Aísla la capa de presentación del resto de la infraestructura.
- **persistence_net:** Red dedicada para los servicios de persistencia de datos (PostgreSQL, Redis), protegiendo el acceso a las bases de datos.
- **monitor_net:** Red aislada para las herramientas de monitoreo (Grafana), permitiendo el acceso controlado a los servicios que necesita supervisar.

### Puertos Expuestos

| Servicio      | Puerto Host   | Puerto Contenedor | Justificación                                                                                  |
|---------------|--------------|-------------------|-----------------------------------------------------------------------------------------------|
| Aplicaciones  | 8081, 8082, 8083 | 80             | El contenedor Nginx escucha en el puerto 80, pero se expone en puertos altos en el host para evitar conflictos y simular un entorno de microservicios. |
| PostgreSQL    | 5432         | 5432              | Puerto estándar para conexiones a PostgreSQL. Se mantiene consistente entre el host y el contenedor para facilitar el acceso con herramientas de BBDD. |
| Redis         | 6379         | 6379              | Puerto por defecto para Redis. Se expone para permitir la conexión directa durante el desarrollo si fuera necesario. |
| Grafana       | 3000         | 3000              | Puerto estándar para acceder a la interfaz web de Grafana.                                     |

## Consideraciones de Storage (Persistencia de Datos)

- **PostgreSQL con Volumen:** Se configura un volumen de Docker para PostgreSQL. Esto garantiza que los datos sean persistentes y no se pierdan si el contenedor se reinicia o se elimina, desacoplando el ciclo de vida de los datos del contenedor.
- **Redis sin Volumen:** El servicio de Redis no utiliza un volumen de persistencia, ya que su rol en esta arquitectura es de caché en memoria. La pérdida de datos tras un reinicio es un comportamiento esperado y aceptable para este caso de uso.

## Estructura de Archivos del Proyecto

- `main.tf`: Archivo principal que configura el proveedor de Docker.
- `variables.tf`: Define todas las variables de entrada del proyecto (ej. puertos, credenciales, etc.).
- `terraform.tfvars`: Asigna valores a las variables definidas. **Importante:** Este archivo no debe ser versionado en un repositorio público si contiene secretos. Añádelo a tu `.gitignore`.
- `networks.tf`: Declara las tres redes Docker (`app_net`, `persistence_net`, `monitor_net`).
- `apps.tf`: Define el despliegue de los contenedores de aplicación (Nginx).
- `persistence.tf`: Configuración de los contenedores de persistencia (PostgreSQL y Redis).
- `monitoring.tf`: Configuración del contenedor de monitoreo (Grafana).

## Acceso a los Servicios

Una vez desplegada la infraestructura, puedes acceder a cada servicio en las siguientes URLs:

- **Aplicaciones Nginx:**  
  - http://localhost:8081  
  - http://localhost:8082  
  - http://localhost:8083

- **Grafana:**  
  - http://localhost:3000

- **PostgreSQL (conexión):**  
  - localhost:5432

- **Redis (conexión):**  
  - localhost:6379

---
