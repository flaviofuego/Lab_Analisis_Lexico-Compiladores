# Dockerfile para el entorno de análisis léxico y sintáctico
FROM ubuntu:20.04

# Evitar preguntas interactivas durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar sistema e instalar herramientas necesarias
RUN apt-get update && apt-get install -y \
    flex \
    bison \
    gcc \
    make \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio de trabajo
WORKDIR /workspace

# Copiar archivos del proyecto
COPY . .

# Comando por defecto para mantener el contenedor activo
CMD ["/bin/bash"]