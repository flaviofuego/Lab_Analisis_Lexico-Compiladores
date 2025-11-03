# ╔════════════════════════════════════════════════════════════╗
# ║      ANALIZADOR LÉXICO Y SINTÁCTICO - MAKEFILE            ║
# ║      Laboratorio de Compiladores                          ║
# ╚════════════════════════════════════════════════════════════╝

# ============================================================
# VARIABLES DE CONFIGURACIÓN
# ============================================================

# Analizador Léxico
LEX_SOURCE = src/LAB01_Arregoces_Gonzalez_Sanchez_Oviedo.l
EXECUTABLE = dist/LAB01_Arregoces_Gonzalez_Sanchez_Oviedo
COMPILE_FILE = dist/LAB01_Arregoces_Gonzalez_Sanchez_Oviedo.c

# Analizador Sintáctico
YACC_SOURCE = src/LAB02_Analizador_Sintactico.y
LEX_SYNTAX_SOURCE = src/LAB02_Lexico_Para_Sintactico.l
SYNTAX_EXECUTABLE = dist/LAB02_Analizador_Sintactico
YACC_OUTPUT = dist/LAB02_Analizador_Sintactico.tab.c
YACC_HEADER = dist/LAB02_Analizador_Sintactico.tab.h
LEX_SYNTAX_OUTPUT = dist/lex.yy.c

# Visualizador de Tokens
VISUALIZADOR_SOURCE = src/visualizador_tokens.l
VISUALIZADOR_EXECUTABLE = dist/visualizador_tokens
VISUALIZADOR_OUTPUT = dist/visualizador_tokens.c

# Archivos de entrada por defecto
INPUT_FILE = entradas/entrada_ejemplo.py
FILE ?= $(INPUT_FILE)

# Compilador y flags
CC = gcc
CFLAGS = -Wall -Wno-unused-function -Wno-implicit-function-declaration -std=c99
LDFLAGS = -lfl -ly

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

# Compilar analizador léxico
$(EXECUTABLE): $(LEX_SOURCE)
	@mkdir -p dist
	@flex -o $(COMPILE_FILE) $(LEX_SOURCE) 2>/dev/null
	@$(CC) $(CFLAGS) $(COMPILE_FILE) -o $(EXECUTABLE) -lfl 2>/dev/null

# Compilar analizador sintáctico
$(SYNTAX_EXECUTABLE): $(YACC_SOURCE) $(LEX_SYNTAX_SOURCE)
	@mkdir -p dist
	@bison -d -o $(YACC_OUTPUT) $(YACC_SOURCE) 2>/dev/null
	@flex -o $(LEX_SYNTAX_OUTPUT) $(LEX_SYNTAX_SOURCE) 2>/dev/null
	@$(CC) -Wno-implicit-function-declaration -Idist $(YACC_OUTPUT) $(LEX_SYNTAX_OUTPUT) -o $(SYNTAX_EXECUTABLE) -lfl 2>/dev/null

# Compilar visualizador de tokens
$(VISUALIZADOR_EXECUTABLE): $(VISUALIZADOR_SOURCE)
	@mkdir -p dist
	@flex -o $(VISUALIZADOR_OUTPUT) $(VISUALIZADOR_SOURCE) 2>/dev/null
	@$(CC) $(CFLAGS) $(VISUALIZADOR_OUTPUT) -o $(VISUALIZADOR_EXECUTABLE) -lfl 2>/dev/null

# ============================================================
# COMANDOS DE INSTALACIÓN/COMPILACIÓN
# ============================================================

# Compilar todo (ambos analizadores)
build: check-tools
	@echo "$(CYAN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(CYAN)║     COMPILANDO ANALIZADORES                ║$(NC)"
	@echo "$(CYAN)╚════════════════════════════════════════════╝$(NC)"
	@echo ""
	@echo "$(YELLOW)📦 Compilando analizador léxico...$(NC)"
	@$(MAKE) $(EXECUTABLE) && echo "$(GREEN)✅ Analizador léxico compilado$(NC)" || echo "$(RED)❌ Error al compilar léxico$(NC)"
	@echo ""
	@echo "$(YELLOW)📦 Compilando analizador sintáctico...$(NC)"
	@$(MAKE) $(SYNTAX_EXECUTABLE) && echo "$(GREEN)✅ Analizador sintáctico compilado$(NC)" || echo "$(RED)❌ Error al compilar sintáctico$(NC)"
	@echo ""
	@echo "$(YELLOW)📦 Compilando visualizador de tokens...$(NC)"
	@$(MAKE) $(VISUALIZADOR_EXECUTABLE) && echo "$(GREEN)✅ Visualizador compilado$(NC)" || echo "$(RED)❌ Error al compilar visualizador$(NC)"
	@echo ""
	@echo "$(GREEN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║     COMPILACIÓN COMPLETADA EXITOSAMENTE    ║$(NC)"
	@echo "$(GREEN)╚════════════════════════════════════════════╝$(NC)"

# Alias para compatibilidad
install: build
install-basic: $(EXECUTABLE)
	@echo "$(GREEN)✅ Analizador léxico compilado exitosamente$(NC)"
install-syntax: $(SYNTAX_EXECUTABLE)
	@echo "$(GREEN)✅ Analizador sintáctico compilado exitosamente$(NC)"
install-visualizador: $(VISUALIZADOR_EXECUTABLE)
	@echo "$(GREEN)✅ Visualizador de tokens compilado exitosamente$(NC)"

# Verificar herramientas necesarias
check-tools:
	@which flex > /dev/null 2>&1 || (echo "$(RED)❌ Error: Flex no está instalado$(NC)" && exit 1)
	@which gcc > /dev/null 2>&1 || (echo "$(RED)❌ Error: GCC no está instalado$(NC)" && exit 1)
	@which bison > /dev/null 2>&1 || which yacc > /dev/null 2>&1 || (echo "$(RED)❌ Error: Bison/Yacc no está instalado$(NC)" && exit 1)

# ============================================================
# COMANDOS DE EJECUCIÓN
# ============================================================

# Ejecutar análisis léxico
lexico: $(EXECUTABLE)
	@if [ ! -f "$(FILE)" ]; then \
		echo "$(RED)❌ Error: El archivo $(FILE) no existe$(NC)"; \
		exit 1; \
	fi
	@echo "$(CYAN)📝 ANÁLISIS LÉXICO$(NC)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "Archivo: $(FILE)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@./$(EXECUTABLE) $(FILE)

# Ejecutar análisis sintáctico
sintactico: $(SYNTAX_EXECUTABLE)
	@if [ ! -f "$(FILE)" ]; then \
		echo "$(RED)❌ Error: El archivo $(FILE) no existe$(NC)"; \
		exit 1; \
	fi
	@echo "$(CYAN)� ANÁLISIS SINTÁCTICO$(NC)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "Archivo: $(FILE)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@./$(SYNTAX_EXECUTABLE) $(FILE)

# Ejecutar visualizador de tokens
visualizar: $(VISUALIZADOR_EXECUTABLE)
	@if [ ! -f "$(FILE)" ]; then \
		echo "$(RED)❌ Error: El archivo $(FILE) no existe$(NC)"; \
		exit 1; \
	fi
	@./$(VISUALIZADOR_EXECUTABLE) $(FILE)

# Ejecutar ambos análisis
completo: $(EXECUTABLE) $(SYNTAX_EXECUTABLE)
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
	@echo "$(YELLOW)1️⃣  ANÁLISIS LÉXICO$(NC)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@./$(EXECUTABLE) $(FILE)
	@echo ""
	@echo "$(YELLOW)2️⃣  ANÁLISIS SINTÁCTICO$(NC)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@./$(SYNTAX_EXECUTABLE) $(FILE)
	@echo ""
	@echo "$(GREEN)╔════════════════════════════════════════════╗$(NC)"
	@echo "$(GREEN)║        ANÁLISIS COMPLETO FINALIZADO        ║$(NC)"
	@echo "$(GREEN)╚════════════════════════════════════════════╝$(NC)"

# Alias para compatibilidad con versión anterior
run-basic: lexico
run-syntax: sintactico
run-all: completo

# Limpiar archivos compilados
clean:
	@echo "$(YELLOW)🧹 Limpiando archivos compilados...$(NC)"
	@rm -f $(COMPILE_FILE) $(EXECUTABLE) 2>/dev/null
	@rm -f $(YACC_OUTPUT) $(YACC_HEADER) $(LEX_SYNTAX_OUTPUT) $(SYNTAX_EXECUTABLE) 2>/dev/null
	@rm -f $(VISUALIZADOR_OUTPUT) $(VISUALIZADOR_EXECUTABLE) 2>/dev/null
	@rm -f src/LAB02_Analizador_Sintactico.tab.h 2>/dev/null
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
	@echo "  make build                       - Compilar todos los analizadores"
	@echo "  make install                     - Alias de build"
	@echo "  make install-basic               - Compilar solo analizador léxico"
	@echo "  make install-syntax              - Compilar solo analizador sintáctico"
	@echo "  make install-visualizador        - Compilar solo visualizador de tokens"
	@echo ""
	@echo "$(YELLOW)🚀 EJECUCIÓN (usar con FILE=archivo.py):$(NC)"
	@echo "  make lexico FILE=archivo.py      - Ejecutar análisis léxico"
	@echo "  make sintactico FILE=archivo.py  - Ejecutar análisis sintáctico"
	@echo "  make visualizar FILE=archivo.py  - Visualizar tokens (con TABs, colores)"
	@echo "  make completo FILE=archivo.py    - Ejecutar ambos análisis"
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
	@echo "$(GREEN)� EJEMPLOS DE USO:$(NC)"
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

.PHONY: help build install install-basic install-syntax install-visualizador check-tools \
        lexico sintactico visualizar completo \
        run-basic run-basic-file run-syntax run-syntax-file run-all run-all-file \
        demo test-correcto test-errores test-all \
        clean clean-all