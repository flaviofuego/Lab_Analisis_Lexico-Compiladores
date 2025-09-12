#!/bin/bash

# Script para ejecutar el Laboratorio de Análisis Léxico
# Este script automatiza todo el proceso de construcción y ejecución

# Colores para hacer la salida más clara
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con colores
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[ADVERTENCIA]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[PASO]${NC} $1"
}

# Función principal
main() {
    echo "=========================================="
    echo "    LABORATORIO DE ANÁLISIS LÉXICO"
    echo "=========================================="
    echo ""
    
    print_message "Este script te ayudará a ejecutar el analizador léxico paso a paso"
    echo ""
    
    # Verificar si Docker está instalado
    if ! command -v docker &> /dev/null; then
        print_error "Docker no está instalado. Por favor, instala Docker primero."
        exit 1
    fi
    
    # Verificar si docker-compose está instalado
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose no está instalado. Por favor, instálalo primero."
        exit 1
    fi
    
    print_step "Verificando que todos los archivos están presentes..."
    
    # Verificar archivos necesarios
    required_files=("Dockerfile" "analizador_lexico.l" "entrada_ejemplo.py" "Makefile" "docker-compose.yml")
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            print_error "Archivo faltante: $file"
            exit 1
        fi
    done
    
    print_message "Todos los archivos están presentes ✓"
    echo ""
    
    # Mostrar opciones al usuario
    echo "¿Qué te gustaría hacer?"
    echo "1) Compilar y ejecutar automáticamente (recomendado para principiantes)"
    echo "2) Entrar al contenedor para desarrollo interactivo"
    echo "3) Solo compilar el analizador"
    echo "4) Ejecutar con un archivo personalizado"
    echo "5) Mostrar ayuda sobre los comandos Make"
    echo ""
    
    read -p "Ingresa tu opción (1-5): " opcion
    
    case $opcion in
        1)
            print_step "Ejecutando el analizador automáticamente..."
            echo ""
            print_message "Esto compilará y ejecutará el analizador con el archivo de ejemplo"
            docker-compose run --rm run-analyzer
            ;;
        2)
            print_step "Iniciando contenedor para desarrollo interactivo..."
            echo ""
            print_message "Puedes usar los siguientes comandos dentro del contenedor:"
            print_message "  - make all: Compilar el analizador"
            print_message "  - make run: Ejecutar con archivo de ejemplo"
            print_message "  - make clean: Limpiar archivos generados"
            print_message "  - exit: Salir del contenedor"
            echo ""
            docker-compose run --rm analizador-lexico
            ;;
        3)
            print_step "Solo compilando el analizador..."
            docker-compose run --rm analizador-lexico bash -c "make clean && make all"
            ;;
        4)
            print_step "Ejecutando con archivo personalizado..."
            echo ""
            read -p "Ingresa el nombre del archivo Python: " archivo_personalizado
            if [ ! -f "$archivo_personalizado" ]; then
                print_warning "El archivo $archivo_personalizado no existe."
                print_message "Creando un archivo de ejemplo..."
                echo "# Tu código Python aquí" > "$archivo_personalizado"
            fi
            docker-compose run --rm analizador-lexico bash -c "make all && ./analizador_lexico $archivo_personalizado"
            ;;
        5)
            print_step "Mostrando ayuda de comandos Make..."
            docker-compose run --rm analizador-lexico make help
            ;;
        *)
            print_error "Opción inválida. Ejecuta el script nuevamente."
            exit 1
            ;;
    esac
    
    echo ""
    print_message "¡Proceso completado! 🎉"
    print_message "Si quieres ejecutar de nuevo, simplemente corre este script otra vez."
}

# Verificar si el script se está ejecutando directamente
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi