# Makefile para el Analizador Léxico
# Este archivo automatiza el proceso de compilación

# Variables de configuración
LEX_SOURCE = analizador_lexico.l
C_SOURCE = lex.yy.c
EXECUTABLE = analizador_lexico
INPUT_FILE = entrada_ejemplo.py

# Compilador y flags
CC = gcc
CFLAGS = -Wall -Wextra -std=c99
FLEX_FLAGS = 

# Regla principal: construir todo
all: $(EXECUTABLE)

# Paso 1: Generar código C desde el archivo Lex
$(C_SOURCE): $(LEX_SOURCE)
	@echo "🔧 Generando código C desde Lex..."
	flex $(FLEX_FLAGS) $(LEX_SOURCE)
	@echo "✅ Código C generado: $(C_SOURCE)"

# Paso 2: Compilar el código C generado
$(EXECUTABLE): $(C_SOURCE)
	@echo "🔧 Compilando analizador léxico..."
	$(CC) $(CFLAGS) $(C_SOURCE) -o $(EXECUTABLE) -lfl
	@echo "✅ Analizador léxico compilado: $(EXECUTABLE)"

# Ejecutar el analizador con el archivo de ejemplo
run: $(EXECUTABLE)
	@echo "🚀 Ejecutando analizador léxico con archivo de ejemplo..."
	@echo "================================================"
	./$(EXECUTABLE) $(INPUT_FILE)
	@echo "================================================"

# Ejecutar con entrada personalizada
run-custom: $(EXECUTABLE)
	@echo "📝 Ejecutando analizador léxico (entrada desde teclado)..."
	@echo "Escribe tu código Python y presiona Ctrl+D cuando termines:"
	@echo "================================================"
	./$(EXECUTABLE)

# Limpiar archivos generados
clean:
	@echo "🧹 Limpiando archivos generados..."
	rm -f $(C_SOURCE) $(EXECUTABLE)
	@echo "✅ Limpieza completada"

# Mostrar ayuda
help:
	@echo "=== Analizador Léxico - Ayuda ==="
	@echo ""
	@echo "Comandos disponibles:"
	@echo "  make all          - Compilar el analizador léxico"
	@echo "  make run          - Ejecutar con archivo de ejemplo"
	@echo "  make run-custom   - Ejecutar con entrada desde teclado"
	@echo "  make run-file FILE=archivo.py - Ejecutar con archivo específico"
	@echo "  make clean        - Limpiar archivos generados"
	@echo "  make check-deps   - Verificar dependencias"
	@echo "  make stats        - Mostrar estadísticas del proyecto"
	@echo "  make install      - Instalación completa desde cero"
	@echo "  make help         - Mostrar esta ayuda"
	@echo ""
	@echo "Archivos importantes:"
	@echo "  $(LEX_SOURCE)   - Código fuente Lex"
	@echo "  $(INPUT_FILE)   - Archivo de ejemplo"
	@echo "  $(EXECUTABLE)   - Ejecutable final"
	@echo ""
	@echo "Ejemplos de uso:"
	@echo "  make install                    # Instalación completa"
	@echo "  make run                        # Ejecutar con ejemplo"
	@echo "  make run-file FILE=mi_codigo.py # Ejecutar con archivo personalizado"

# Verificar que Flex está instalado
check-deps:
	@echo "🔍 Verificando dependencias..."
	@which flex > /dev/null || (echo "❌ Error: Flex no está instalado" && exit 1)
	@which gcc > /dev/null || (echo "❌ Error: GCC no está instalado" && exit 1)
	@echo "✅ Todas las dependencias están disponibles"

# Ejecutar con archivo personalizado
run-file: $(EXECUTABLE)
	@if [ -z "$(FILE)" ]; then \
		echo "❌ Error: Especifica un archivo con: make run-file FILE=archivo.py"; \
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

# Mostrar estadísticas del proyecto
stats:
	@echo "📊 Estadísticas del proyecto:"
	@echo "  Líneas en $(LEX_SOURCE): $$(wc -l < $(LEX_SOURCE))"
	@echo "  Tamaño de $(LEX_SOURCE): $$(du -h $(LEX_SOURCE) | cut -f1)"
	@if [ -f "$(EXECUTABLE)" ]; then \
		echo "  Tamaño del ejecutable: $$(du -h $(EXECUTABLE) | cut -f1)"; \
	else \
		echo "  Ejecutable: No compilado"; \
	fi

# Instalación completa desde cero
install: check-deps clean all
	@echo "✅ Instalación completada exitosamente"

# Reglas que no corresponden a archivos
.PHONY: all run run-custom run-file clean help check-deps stats install