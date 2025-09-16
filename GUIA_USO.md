# 🚀 Guía de Uso - Analizador Léxico Python

## 📋 Descripción
Analizador léxico completo para Python implementado con Flex/Lex. Reconoce tokens, palabras reservadas, identificadores, números y operadores.

## 🛠️ Requisitos
- **Docker Desktop** (Windows/Mac)
- **PowerShell** o **Command Prompt**

## 🚀 Inicio Rápido

### 1. Clonar y preparar
```bash
git clone https://github.com/flaviofuego/Lab_Analisis_Lexico-Compiladores.git
cd Lab_Analisis_Lexico-Compiladores
docker build -t analizador-lexico .
```

### 2. Comandos esenciales
```powershell
# Instalación completa (primera vez)
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make install"

# Ejecutar análisis con archivo de ejemplo
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run"

# Analizar tu propio archivo
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run-file FILE=mi_archivo.py"

# Ver ayuda completa
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make help"
```

## � Comandos Make

| Comando | Descripción |
|---------|-------------|
| `make install` | Primera instalación completa |
| `make run` | Ejecutar con archivo de ejemplo |
| `make run-file FILE=archivo.py` | Analizar archivo específico |
| `make clean` | Limpiar archivos generados |
| `make help` | Ver todos los comandos |

## 💡 Ejemplos Rápidos

### Analizar código Python:
```powershell
# Crear archivo
echo 'def suma(a, b): return a + b' > prueba.py

# Analizarlo
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run-file FILE=prueba.py"
```

### Modo desarrollo (interactivo):
```powershell
docker run --rm -it -v "${PWD}:/workspace" analizador-lexico bash
# Dentro del contenedor: make run, make clean, etc.
```

## � Qué Reconoce
- ✅ **32 palabras reservadas** (`def`, `if`, `for`, `while`, etc.)
- ✅ **Identificadores** (numerados automáticamente)
- ✅ **Números** (enteros, decimales, científicos, largos, imaginarios)
- ✅ **Operadores** (aritméticos, comparación, lógicos)
- ✅ **Delimitadores** (`()`, `[]`, `{}`, `:`, `,`)
- ✅ **Cadenas** (comillas simples y dobles)
- ✅ **Comentarios** (ignorados)

## � Resolución de Problemas

**Docker no reconocido**: Instalar Docker Desktop y reiniciar terminal

**Archivo no encontrado**: Verificar ruta con `pwd` y usar rutas absolutas si es necesario

**Permission denied**: En Linux usar `sudo` antes del comando docker

---
**Repositorio listo para usar** 🎉