# 🚀 Guía de Uso - Analizador Léxico Python (Básico)

## 📋 Descripción
**Analizador léxico básico** para Python implementado con Flex/Lex:
- **16 palabras reservadas fundamentales** (ideal para empezar)
- Reconocimiento de identificadores, números, operadores y delimitadores
- Manejo de cadenas y comentarios

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
# Compilar el analizador básico
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make install-basic && ./dist/LAB01_Arregoces_Gomez_Sanchez ./entradas/entrada_ejemplo.py"



# Ejecutar con archivo de ejemplo
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run-basic"
```

## 📋 Comandos Disponibles

| Comando | Descripción |
|---------|-------------|
| `make install-basic` | Compila el analizador básico |
| `make run-basic` | Ejecuta análisis con archivo de ejemplo |
| `make help` | Muestra ayuda del sistema |

## 💡 Ejemplo de Uso

```powershell
# Crear archivo de prueba
echo 'def suma(a, b): return a + b' > ./entradas/prueba.py

# Analizarlo
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "./dist/LAB01_Arregoces_Gomez_Sanchez ./entradas/prueba.py"
```

## 🔍 Qué Reconoce el Analizador Básico

- ✅ **16 palabras reservadas**: `def`, `if`, `else`, `elif`, `for`, `while`, `and`, `or`, `not`, `in`, `is`, `class`, `return`, `break`, `continue`, `pass`
- ✅ **Operadores básicos**: `+`, `-`, `*`, `/`, `=`, `==`, `!=`
- ✅ **Identificadores** (numerados automáticamente)
- ✅ **Números** (enteros, decimales, científicos, largos, imaginarios)
- ✅ **Delimitadores**: `()`, `[]`, `{}`, `:`, `,`
- ✅ **Cadenas** (comillas simples y dobles)
- ✅ **Comentarios** (ignorados)

## 🔧 Resolución de Problemas

**Docker no reconocido**: Instalar Docker Desktop y reiniciar terminal

**Archivo no encontrado**: Verificar ruta con `pwd` y usar rutas absolutas si es necesario

**Permission denied**: En Linux usar `sudo` antes del comando docker

---