# 🚀 Guía de Uso - Analizador Léxico Pytho## 📋 Comandos Make

### Analizador BÁSICO (16 palabras reservada## 🔍 Qué Reconoce Cada Analizador

### Analizador BÁSICO (16 palabras reservadas):
- ✅ **Palabras clave básicas**: `def`, `if`, `else`, `elif`, `for`, `while`, `and`, `or`, `not`, `in`, `is`, `class`, `return`, `break`, `continue`, `pass`
- ✅ **Operadores básicos**: `+`, `-`, `*`, `/`, `=`, `==`, `!=`
- ✅ **Identificadores** y **números** básicos
- ✅ **Delimitadores** fundamentales: `()`, `[]`, `{}`, `:`, `,`
- ✅ **Cadenas** (comillas simples y dobles)

### Analizador COMPLETO (32 palabras reservadas):
- ✅ **Todas las palabras del básico PLUS**: `import`, `from`, `as`, `try`, `except`, `finally`, `with`, `yield`, `lambda`, `global`, `nonlocal`, `assert`, `del`, `async`, `await`, `raise`
- ✅ **Operadores avanzados**: `//`, `%`, `**`, `<<`, `>>`, `&`, `|`, `^`, `~`, `<`, `>`, `<=`, `>=`, `+=`, `-=`, etc.
- ✅ **Números complejos**: enteros, decimales, científicos, largos, imaginarios
- ✅ **Delimitadores completos** y **cadenas triple-quoted**
- ✅ **Comentarios** (ignorados)omando | Descripción |
|---------|-------------|
| `make install-basic` | Compila el analizador básico |
| `make run-basic` | Ejecuta análisis con versión básica |
| `make run-basic-file FILE=archivo.py` | Analiza archivo específico con versión básica |
| `make clean-basic` | Limpia archivos del analizador básico |

### Analizador COMPLETO (32 palabras reservadas):
| Comando | Descripción |
|---------|-------------|
| `make install` | Compila el analizador completo |
| `make run` | Ejecuta análisis con versión completa |
| `make run-file FILE=archivo.py` | Analiza archivo específico con versión completa |
| `make clean` | Limpia archivos del analizador completo |

### Comandos Generales:
| Comando | Descripción |
|---------|-------------|
| `make both` | Compila ambos analizadores |
| `make stats` | Muestra estadísticas comparativas |
| `make clean-all` | Limpia todos los archivos generados |
| `make help` | Ver ayuda completa del sistema | Descripción
**Dos analizadores léxicos** para Python implementados con Flex/Lex:
- **Analizador COMPLETO**: 32 palabras reservadas, operadores avanzados
- **Analizador BÁSICO**: 16 palabras reservadas fundamentales (ideal para empezar)

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

#### Analizador BÁSICO (16 palabras reservadas):
```powershell
# Compilar y ejecutar versión básica
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make install-basic"
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run-basic"

# Analizar archivo con versión básica
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run-basic-file FILE=mi_archivo.py"
```

#### Analizador COMPLETO (32 palabras reservadas):
```powershell
# Compilar y ejecutar versión completa
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make install"
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run"

# Analizar archivo con versión completa
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run-file FILE=mi_archivo.py"
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

### Analizar código Python con versión BÁSICA:
```powershell
# Crear archivo
echo 'def suma(a, b): return a + b' > prueba.py

# Analizarlo con analizador básico
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run-basic-file FILE=prueba.py"
```

### Analizar código Python con versión COMPLETA:
```powershell
# Crear archivo con código más complejo
echo 'async def fibonacci(n): yield from range(n)' > avanzado.py

# Analizarlo con analizador completo
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run-file FILE=avanzado.py"
```

### Comparar ambos analizadores:
```powershell
# Compilar ambos
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make both"

# Ver estadísticas comparativas
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make stats"
```

### Modo desarrollo (interactivo):
```powershell
docker run --rm -it -v "${PWD}:/workspace" analizador-lexico bash
# Dentro del contenedor: make run-basic, make run, make clean-all, etc.
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