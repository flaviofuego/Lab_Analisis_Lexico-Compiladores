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

# Reglas internas (no documentadas)
$(EXECUTABLE): $(LEX_SOURCE)
	@flex $(LEX_SOURCE)
	@$(CC) $(CFLAGS) $(C_SOURCE) -o $(EXECUTABLE) -lfl 2>/dev/null

$(EXECUTABLE_BASIC): $(LEX_BASIC)
	@flex -o lex_basic.yy.c $(LEX_BASIC) 2>/dev/null
	@$(CC) $(CFLAGS) lex_basic.yy.c -o $(EXECUTABLE_BASIC) -lfl 2>/dev/null

# Instalación básica
install-basic:
	@which flex > /dev/null 2>&1 || (echo "❌ Error: Flex no está instalado" && exit 1)
	@which gcc > /dev/null 2>&1 || (echo "❌ Error: GCC no está instalado" && exit 1)
	@rm -f $(C_SOURCE) $(EXECUTABLE) lex_basic.yy.c $(EXECUTABLE_BASIC) 2>/dev/null
	@$(MAKE) $(EXECUTABLE_BASIC)
	@echo "✅ Instalación BÁSICA completada exitosamente"

# Ejecutar analizador completo
run: $(EXECUTABLE)
	@echo "Ejecutando analizador COMPLETO con archivo de ejemplo..."
	@echo "================================================"
	./$(EXECUTABLE) $(INPUT_FILE)
	@echo "================================================"

# Ejecutar analizador básico
run-basic: $(EXECUTABLE_BASIC)
	@echo "Ejecutando analizador BÁSICO con archivo de ejemplo..."
	@echo "================================================"
	./$(EXECUTABLE_BASIC) $(INPUT_FILE)
	@echo "================================================"

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
	@echo "=== Analizador Léxico - Comandos Disponibles ==="
	@echo ""
	@echo "  make install-basic    - Compilar analizador básico (16 palabras reservadas)"
	@echo "  make run              - Ejecutar analizador completo con archivo de ejemplo"
	@echo "  make run-basic        - Ejecutar analizador básico con archivo de ejemplo"
	@echo "  make run-basic-file FILE=archivo.py - Ejecutar analizador básico con archivo específico"
	@echo "  make clean            - Limpia archivos generados" 
	@echo "  make help             - Mostrar esta ayuda"
	@echo ""
	@echo "Archivos importantes:"
	@echo "  $(LEX_BASIC)    - Código fuente Lex BÁSICO (16 palabras reservadas)"
	@echo "  $(LEX_SOURCE)   - Código fuente Lex COMPLETO (32 palabras reservadas)"
	@echo "  $(INPUT_FILE)   - Archivo de ejemplo"
	@echo ""
	@echo "Ejemplo de uso:"
	@echo "  make install-basic && make run-basic"

# Reglas que no corresponden a archivos
.PHONY: install-basic run run-basic run-basic-file clean help 
.PHONY: all basic both run run-basic run-custom run-file run-basic-file clean help check-deps stats install install-basic