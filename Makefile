# Makefile para el Analizador Léxico
# Este archivo automatiza el proceso de compilación

# Variables de configuración
LEX_SOURCE = analizador_lexico.l
LEX_BASIC = analizador_basico.l
C_SOURCE = lex.yy.c
EXECUTABLE = analizador_lexico
EXECUTABLE_BASIC = analizador_basico
INPUT_FILE = entrada_ejemplo.py

# Compilador y flags
CC = gcc
CFLAGS = -Wall -Wextra -std=c99
FLEX_FLAGS = 

# Regla principal: construir todo
all: $(EXECUTABLE)

# Construir solo el analizador básico
basic: $(EXECUTABLE_BASIC)

# Construir ambos analizadores
both: $(EXECUTABLE) $(EXECUTABLE_BASIC)

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

# Compilar analizador básico
$(EXECUTABLE_BASIC): $(LEX_BASIC)
	@echo "🔧 Generando analizador básico..."
	flex -o lex_basic.yy.c $(LEX_BASIC)
	@echo "🔧 Compilando analizador básico..."
	$(CC) $(CFLAGS) lex_basic.yy.c -o $(EXECUTABLE_BASIC) -lfl
	@echo "✅ Analizador básico compilado: $(EXECUTABLE_BASIC)"
	

	

# Ejecutar el analizador con el archivo de ejemplo
run: $(EXECUTABLE)
	@echo "🚀 Ejecutando analizador léxico con archivo de ejemplo..."
	@echo "================================================"
	./$(EXECUTABLE) $(INPUT_FILE)
	@echo "================================================"

# Ejecutar analizador básico
run-basic: $(EXECUTABLE_BASIC)
	@echo "🚀 Ejecutando analizador BÁSICO con archivo de ejemplo..."
	@echo "================================================"
	./$(EXECUTABLE_BASIC) $(INPUT_FILE)
	@echo "================================================"

# Ejecutar con entrada personalizada
run-custom: $(EXECUTABLE)
	@echo "📝 Ejecutando analizador léxico (entrada desde teclado)..."
	@echo "Escribe tu código Python y presiona Ctrl+D cuando termines:"
	@echo "================================================"
	./$(EXECUTABLE)

# Ejecutar analizador básico con archivo personalizado
run-basic-file: $(EXECUTABLE_BASIC)
	@if [ -z "$(FILE)" ]; then \
		echo "❌ Error: Especifica un archivo con: make run-basic-file FILE=archivo.py"; \
		exit 1; \
	fi
	@if [ ! -f "$(FILE)" ]; then \
		echo "❌ Error: El archivo $(FILE) no existe"; \
		exit 1; \
	fi
	@echo "🚀 Ejecutando analizador BÁSICO con archivo: $(FILE)"
	@echo "================================================"
	./$(EXECUTABLE_BASIC) $(FILE)
	@echo "================================================"

# Limpiar archivos generados
clean:
	@echo "🧹 Limpiando archivos generados..."
	rm -f $(C_SOURCE) $(EXECUTABLE) lex_basic.yy.c $(EXECUTABLE_BASIC)
	@echo "✅ Limpieza completada"

# Mostrar ayuda
help:
	@echo "=== Analizador Léxico - Ayuda ==="
	@echo ""
	@echo "Comandos disponibles:"
	@echo "  make all          - Compilar el analizador léxico completo"
	@echo "  make basic        - Compilar solo el analizador básico (16 palabras)"
	@echo "  make both         - Compilar ambos analizadores"
	@echo "  make run          - Ejecutar analizador completo con archivo de ejemplo"
	@echo "  make run-basic    - Ejecutar analizador básico con archivo de ejemplo"
	@echo "  make run-custom   - Ejecutar con entrada desde teclado"
	@echo "  make run-file FILE=archivo.py - Ejecutar analizador completo con archivo específico"
	@echo "  make run-basic-file FILE=archivo.py - Ejecutar analizador básico con archivo específico"
	@echo "  make clean        - Limpiar archivos generados"
	@echo "  make check-deps   - Verificar dependencias"
	@echo "  make stats        - Mostrar estadísticas del proyecto"
	@echo "  make install      - Instalación completa desde cero"
	@echo "  make help         - Mostrar esta ayuda"
	@echo ""
	@echo "Archivos importantes:"
	@echo "  $(LEX_SOURCE)   - Código fuente Lex COMPLETO (32 palabras reservadas)"
	@echo "  $(LEX_BASIC)    - Código fuente Lex BÁSICO (16 palabras reservadas)"
	@echo "  $(INPUT_FILE)   - Archivo de ejemplo"
	@echo "  $(EXECUTABLE)   - Ejecutable completo"
	@echo "  $(EXECUTABLE_BASIC) - Ejecutable básico"
	@echo ""
	@echo "Ejemplos de uso:"
	@echo "  make basic && make run-basic                    # Usar analizador básico"
	@echo "  make all && make run                            # Usar analizador completo"
	@echo "  make run-basic-file FILE=mi_codigo.py           # Analizar archivo con versión básica"

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
	@echo "  Líneas en $(LEX_BASIC): $$(wc -l < $(LEX_BASIC))"
	@echo "  Tamaño de $(LEX_SOURCE): $$(du -h $(LEX_SOURCE) | cut -f1)"
	@echo "  Tamaño de $(LEX_BASIC): $$(du -h $(LEX_BASIC) | cut -f1)"
	@if [ -f "$(EXECUTABLE)" ]; then \
		echo "  Tamaño del ejecutable completo: $$(du -h $(EXECUTABLE) | cut -f1)"; \
	else \
		echo "  Ejecutable completo: No compilado"; \
	fi
	@if [ -f "$(EXECUTABLE_BASIC)" ]; then \
		echo "  Tamaño del ejecutable básico: $$(du -h $(EXECUTABLE_BASIC) | cut -f1)"; \
	else \
		echo "  Ejecutable básico: No compilado"; \
	fi

# Instalación completa desde cero
install: check-deps clean all
	@echo "✅ Instalación completada exitosamente"

# Instalación básica
install-basic: check-deps clean basic
	@echo "✅ Instalación BÁSICA completada exitosamente"
	@echo "================================================"
	@echo "================================================"


# Reglas que no corresponden a archivos
.PHONY: all basic both run run-basic run-custom run-file run-basic-file clean help check-deps stats install install-basic