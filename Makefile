# ╔════════════════════════════════════════════════════════════╗
# ║      ANALIZADOR LÉXICO Y SINTÁCTICO - MAKEFILE            ║
# ║      Laboratorio de Compiladores                          ║
# ╚════════════════════════════════════════════════════════════╝

# ============================================================
# VARIABLES DE CONFIGURACIÓN
# ============================================================

# Analizador combinado (léxico + sintáctico)
LEX_SOURCE = src/LAB02_Arregoces_Gonzalez_Sanchez_Oviedo.l
YACC_SOURCE = src/LAB02_Arregoces_Gonzalez_Sanchez_Oviedo.y
LEX_OUTPUT = dist/lex.yy.c
YACC_OUTPUT = dist/LAB02_Arregoces_Gonzalez_Sanchez_Oviedo.tab.c
YACC_HEADER = dist/LAB02_Arregoces_Gonzalez_Sanchez_Oviedo.tab.h
ANALYZER_EXECUTABLE = dist/LAB02_Arregoces_Gonzalez_Sanchez_Oviedo

# Archivos de entrada por defecto
INPUT_FILE = entradas/entrada_ejemplo.py
FILE ?= $(INPUT_FILE)

# Compilador y flags
CC = gcc
CFLAGS = -Wall -Wno-unused-function -Wno-implicit-function-declaration -std=c99
LDFLAGS = -lfl

# Colores para la salida (ANSI escape codes)
CYAN = \033[0;36m
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

# ============================================================
# REGLA POR DEFECTO
# ============================================================

.DEFAULT_GOAL := help

# ============================================================
# COMPILACIÓN DE ANALIZADORES
# ============================================================

# Compilar analizador combinado
$(ANALYZER_EXECUTABLE): $(YACC_SOURCE) $(LEX_SOURCE)
	@mkdir -p dist
	@bison -d -o $(YACC_OUTPUT) $(YACC_SOURCE) 2>/dev/null
	@flex -o $(LEX_OUTPUT) $(LEX_SOURCE) 2>/dev/null
	@$(CC) $(CFLAGS) -Idist $(YACC_OUTPUT) $(LEX_OUTPUT) -o $(ANALYZER_EXECUTABLE) $(LDFLAGS) 2>/dev/null

# ============================================================
# COMANDOS DE INSTALACIÓN/COMPILACIÓN
# ============================================================

# Compilar analizador principal
build: check-tools
	@echo "$(CYAN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(CYAN)║     COMPILANDO ANALIZADOR COMBINADO        ║$(NC)"
	@echo "$(CYAN)╚════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(YELLOW)📦 Compilando analizador léxico-sintáctico...$(NC)"
	@$(MAKE) $(ANALYZER_EXECUTABLE) && \
		echo "$(GREEN)✅ Analizador combinado compilado$(NC)" || \
		(echo "$(RED)❌ Error al compilar$(NC)"; exit 1)
	@echo ""
	@echo "$(GREEN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║     COMPILACIÓN COMPLETADA EXITOSAMENTE    ║$(NC)"
	@echo "$(GREEN)╚════════════════════════════════════════════╝$(NC)"

# Alias para compatibilidad
install: build
install-basic: $(ANALYZER_EXECUTABLE)
	@echo "$(GREEN)✅ Analizador combinado compilado (léxico + sintáctico)$(NC)"
install-syntax: $(ANALYZER_EXECUTABLE)
	@echo "$(GREEN)✅ Analizador combinado compilado (léxico + sintáctico)$(NC)"

# Verificar herramientas necesarias
check-tools:
	@which flex > /dev/null 2>&1 || (echo "$(RED)❌ Error: Flex no está instalado$(NC)" && exit 1)
	@which gcc > /dev/null 2>&1 || (echo "$(RED)❌ Error: GCC no está instalado$(NC)" && exit 1)
	@which bison > /dev/null 2>&1 || which yacc > /dev/null 2>&1 || (echo "$(RED)❌ Error: Bison/Yacc no está instalado$(NC)" && exit 1)

# ============================================================
# COMANDOS DE EJECUCIÓN
# ============================================================

# Ejecutar análisis léxico
lexico: $(ANALYZER_EXECUTABLE)
	@if [ ! -f "$(FILE)" ]; then \
		echo "$(RED)❌ Error: El archivo $(FILE) no existe$(NC)"; \
		exit 1; \
	fi
	@echo "$(CYAN)📝 ANÁLISIS LÉXICO (analizador combinado)$(NC)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "Archivo: $(FILE)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@./$(ANALYZER_EXECUTABLE) $(FILE)

# Ejecutar análisis sintáctico
sintactico: $(ANALYZER_EXECUTABLE)
	@if [ ! -f "$(FILE)" ]; then \
		echo "$(RED)❌ Error: El archivo $(FILE) no existe$(NC)"; \
		exit 1; \
	fi
	@echo "$(CYAN)🛠 ANÁLISIS SINTÁCTICO (analizador combinado)$(NC)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "Archivo: $(FILE)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@./$(ANALYZER_EXECUTABLE) $(FILE)

# Ejecutar análisis completo
completo: $(ANALYZER_EXECUTABLE)
	@if [ ! -f "$(FILE)" ]; then \
		echo "$(RED)❌ Error: El archivo $(FILE) no existe$(NC)"; \
		exit 1; \
	fi
	@echo "$(CYAN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(CYAN)║   ANÁLISIS LÉXICO Y SINTÁCTICO COMPLETO    ║$(NC)"
	@echo "$(CYAN)╚════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "📝 Archivo: $(FILE)"
	@echo ""
	@./$(ANALYZER_EXECUTABLE) $(FILE)
	@echo ""
	@echo "$(GREEN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║        ANÁLISIS COMPLETO FINALIZADO        ║$(NC)"
	@echo "$(GREEN)╚════════════════════════════════════════════╝$(NC)"

# Alias para compatibilidad con versión anterior
run-basic: lexico
run-syntax: sintactico
run-all: completo

# ============================================================
# PRUEBAS RÁPIDAS
# ============================================================

# Prueba con archivo de ejemplo
demo: $(ANALYZER_EXECUTABLE)
	@echo "$(CYAN)🧪 Ejecutando prueba con archivo de ejemplo...$(NC)"
	@$(MAKE) completo FILE=$(INPUT_FILE)

# Prueba con archivo correcto
test-correcto: $(ANALYZER_EXECUTABLE)
	@echo "$(CYAN)🧪 Ejecutando prueba con archivo correcto...$(NC)"
	@$(MAKE) completo FILE=entradas/prueba_correcta.py

# Prueba con archivo con errores
test-errores: $(ANALYZER_EXECUTABLE)
	@echo "$(CYAN)🧪 Ejecutando prueba con archivo con errores...$(NC)"
	@$(MAKE) completo FILE=entradas/prueba2.py

# Ejecutar todas las pruebas
test-all: $(ANALYZER_EXECUTABLE)
	@echo "$(CYAN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(CYAN)║     EJECUTANDO TODAS LAS PRUEBAS            ║$(NC)"
	@echo "$(CYAN)╚════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(YELLOW)1️⃣  Prueba con archivo de ejemplo$(NC)"
	@$(MAKE) demo
	@echo ""
	@echo "$(YELLOW)2️⃣  Prueba con archivo correcto$(NC)"
	@$(MAKE) test-correcto
	@echo ""
	@echo "$(YELLOW)3️⃣  Prueba con archivo con errores$(NC)"
	@$(MAKE) test-errores
	@echo ""
	@echo "$(GREEN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║        TODAS LAS PRUEBAS COMPLETADAS       ║$(NC)"
	@echo "$(GREEN)╚════════════════════════════════════════════╝$(NC)"

# Limpiar archivos compilados
clean:
	@echo "$(YELLOW)🧹 Limpiando archivos compilados...$(NC)"
	@rm -f $(LEX_OUTPUT) $(YACC_OUTPUT) $(YACC_HEADER) $(ANALYZER_EXECUTABLE) 2>/dev/null
	@rm -f dist/LAB01_Arregoces_Gonzalez_Sanchez_Oviedo dist/LAB01_Arregoces_Gonzalez_Sanchez_Oviedo.c 2>/dev/null
	@rm -f dist/LAB02_Analizador_Sintactico dist/LAB02_Analizador_Sintactico.tab.* 2>/dev/null
	@rm -f dist/visualizador_tokens dist/visualizador_tokens.c 2>/dev/null
	@echo "$(GREEN)✅ Limpieza completada$(NC)"

# Limpiar todo (incluyendo salidas)
clean-all: clean
	@echo "$(YELLOW)🧹 Limpiando archivos de salida...$(NC)"
	@rm -f salidas/*.txt 2>/dev/null
	@echo "$(GREEN)✅ Limpieza completa$(NC)"

# ============================================================
# AYUDA Y DOCUMENTACIÓN
# ============================================================

help:
	@echo "$(CYAN)╔════════════════════════════════════════════════════════════╗$(NC)"
	@echo "$(CYAN)║      ANALIZADOR LÉXICO Y SINTÁCTICO - MAKEFILE            ║$(NC)"
	@echo "$(CYAN)╚════════════════════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(YELLOW)📦 COMPILACIÓN:$(NC)"
	@echo "  make build                       - Compilar el analizador combinado"
	@echo "  make install                     - Alias de build"
	@echo "  make install-basic               - Compilar analizador combinado (léxico + sintáctico)"
	@echo "  make install-syntax              - Compilar analizador combinado (léxico + sintáctico)"
	@echo ""
	@echo "$(YELLOW)🚀 EJECUCIÓN (usar con FILE=archivo.py):$(NC)"
	@echo "  make lexico FILE=archivo.py      - Ejecutar análisis léxico (salida combinada)"
	@echo "  make sintactico FILE=archivo.py  - Ejecutar análisis sintáctico (salida combinada)"
	@echo "  make completo FILE=archivo.py    - Ejecutar análisis completo"
	@echo ""
	@echo "$(YELLOW)🧪 PRUEBAS RÁPIDAS:$(NC)"
	@echo "  make demo                     - Probar con archivo de ejemplo"
	@echo "  make test-correcto            - Probar archivo sin errores"
	@echo "  make test-errores             - Probar archivo con errores"
	@echo "  make test-all                 - Ejecutar todas las pruebas"
	@echo ""
	@echo "$(YELLOW)🧹 LIMPIEZA:$(NC)"
	@echo "  make clean                    - Limpiar archivos compilados"
	@echo "  make clean-all                - Limpiar todo (incluye salidas)"
	@echo ""
	@echo "$(YELLOW)❓ AYUDA:$(NC)"
	@echo "  make help                     - Mostrar esta ayuda"
	@echo ""
	@echo "$(YELLOW)ℹ️ NOTA:$(NC)"
	@echo "  El visualizador de tokens fue retirado junto con sus fuentes."
	@echo ""
	@echo "$(GREEN)* EJEMPLOS DE USO:$(NC)"
	@echo "  $(CYAN)# Compilar y probar$(NC)"
	@echo "  make build"
	@echo "  make demo"
	@echo ""
	@echo "  $(CYAN)# Analizar archivo específico$(NC)"
	@echo "  make completo FILE=entradas/prueba_correcta.py"
	@echo ""
	@echo "  $(CYAN)# Solo análisis sintáctico$(NC)"
	@echo "  make sintactico FILE=entradas/prueba2.py"
	@echo ""
	@echo "  $(CYAN)# Ejecutar todas las pruebas$(NC)"
	@echo "  make test-all"
	@echo ""
	@echo "$(YELLOW)📂 ESTRUCTURA:$(NC)"
	@echo "  entradas/     - Archivos de entrada (.py)"
	@echo "  salidas/      - Archivos de salida (generados)"
	@echo "  src/          - Código fuente (.l, .y)"
	@echo "  dist/         - Ejecutables compilados"
	@echo ""
	@echo "$(YELLOW)🔗 COMPATIBILIDAD:$(NC)"
	@echo "  Los comandos antiguos siguen funcionando:"
	@echo "  - run-basic, run-syntax, run-all (usan FILE por defecto)"
	@echo ""

# ============================================================
# PHONY TARGETS
# ============================================================

.PHONY: help build install install-basic install-syntax check-tools \
        lexico sintactico completo \
        run-basic run-syntax run-all \
        demo test-correcto test-errores test-all \
        clean clean-all