# Makefile para el Analizador Léxico Básico
# Laboratorio de Análisis Léxico - Compiladores

# Variables de configuración
LEX_SOURCE = src/LAB01_Arregoces_Gonzalez_Sanchez_Sharick.l
EXECUTABLE = dist/LAB01_Arregoces_Gonzalez_Sanchez_Sharick
COMPILE_FILE = dist/LAB01_Arregoces_Gonzalez_Sanchez_Sharick.c
INPUT_FILE = entradas/entrada_ejemplo.py
# Compilador y flags
CC = gcc
CFLAGS = -Wall -Wextra -std=c99

# Regla principal: compilar el analizador
$(EXECUTABLE): $(LEX_SOURCE)
	@flex -o $(COMPILE_FILE) $(LEX_SOURCE) 2>/dev/null
	@$(CC) $(CFLAGS) $(COMPILE_FILE) -o $(EXECUTABLE) -lfl 2>/dev/null

# Instalación del analizador
install-basic:
	@which flex > /dev/null 2>&1 || (echo "❌ Error: Flex no está instalado" && exit 1)
	@which gcc > /dev/null 2>&1 || (echo "❌ Error: GCC no está instalado" && exit 1)
	@rm -f $(COMPILE_FILE) $(EXECUTABLE) 2>/dev/null
	@$(MAKE) $(EXECUTABLE)
	@echo "✅ Analizador léxico compilado exitosamente"

# Ejecutar analizador con archivo de ejemplo
run-basic: $(EXECUTABLE)
	@echo "🚀 Ejecutando analizador léxico con archivo de ejemplo..."
	@echo "================================================"
	./$(EXECUTABLE) $(INPUT_FILE)
	@echo "================================================"

# Ejecutar analizador con archivo personalizado
run-basic-file: $(EXECUTABLE)
	@if [ -z "$(FILE)" ]; then \
		echo "❌ Error: Especifica un archivo con: make run-basic-file FILE=archivo.py"; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE)" ]; then \
		echo "❌ Error: El archivo $(FILE) no existe"; \
		exit 1; \
	fi
	@echo "🚀 Ejecutando analizador léxico con archivo: $(FILE)"
	@echo "================================================"
	./$(EXECUTABLE) $(FILE)
	@echo "================================================"

# Limpiar archivos generados
clean:
	@echo "🧹 Limpiando archivos generados..."
	@rm -f $(COMPILE_FILE) $(EXECUTABLE) 2>/dev/null
	@echo "✅ Limpieza completada"

# Mostrar ayuda
help:
	@echo "=== Analizador Léxico - Comandos Disponibles ==="
	@echo ""
	@echo "  make install-basic         - Compilar el analizador léxico"
	@echo "  make run-basic             - Ejecutar con archivo de ejemplo"
	@echo "  make run-basic-file FILE=archivo.py - Ejecutar con archivo específico"
	@echo "  make clean                 - Limpiar archivos generados"
	@echo "  make help                  - Mostrar esta ayuda"
	@echo ""
	@echo "Archivos importantes:"
	@echo "  $(LEX_SOURCE)  - Código fuente del analizador léxico"
	@echo "  $(INPUT_FILE)  - Archivo de ejemplo para pruebas"
	@echo "  $(EXECUTABLE)  - Ejecutable del analizador"
	@echo ""
	@echo "Ejemplo de uso:"
	@echo "  make install-basic && make run-basic"

# Reglas que no corresponden a archivos
.PHONY: install-basic run-basic run-basic-file clean help