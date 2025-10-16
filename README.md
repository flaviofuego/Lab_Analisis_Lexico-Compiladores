# 🚀 Analizador Léxico y Sintáctico Python - Laboratorio de Compiladores

## 📋 Descripción

**Analizador léxico y sintáctico completo** para Python implementado con Flex/Lex y Yacc/Bison:

### 📝 Analizador Léxico:
- **19+ palabras reservadas** incluyendo `True`, `False`, `import`, `print`, `range`, `len`
- Reconocimiento completo de tipos numéricos (enteros, reales, largos, imaginarios, notación científica)
- Operadores aritméticos, comparación, lógicos, bit a bit y asignación
- Manejo de cadenas, comentarios, delimitadores y errores léxicos
- Generación automática de archivos de salida con tokens y tabla de identificadores

### 🔍 Analizador Sintáctico:
- Validación sintáctica completa de programas Python
- Detección de errores sintácticos con número de línea
- Soporta estructuras: asignación, funciones, condicionales, ciclos, listas
- Gramática completa para Python simplificado
- Generación de reporte de errores sintácticos

## 🛠️ Requisitos

- **Docker Desktop** (Windows/Mac)
- **PowerShell** o **Command Prompt**

## 🚀 Inicio Rápido

### 1. Clonar y preparar el entorno

```powershell
# Clonar el repositorio
git clone https://github.com/flaviofuego/Lab_Analisis_Lexico-Compiladores.git
cd Lab_Analisis_Lexico-Compiladores

# Construir la imagen Docker (incluye Flex, Bison, GCC)
docker build -t analizador-lexico .
```

> **Nota**: La imagen Docker incluye todas las herramientas necesarias: Flex, Bison, GCC y Make.

### 2. Comandos esenciales

**Usando Makefile (Recomendado - Comandos Unificados):**

```powershell
# Construir imagen Docker
docker build -t analizador-lexico .

# Compilar ambos analizadores
docker run --rm -v "${PWD}:/workspace" analizador-lexico make build

# Ejecutar análisis completo de un archivo
docker run --rm -v "${PWD}:/workspace" analizador-lexico make completo FILE=entradas/prueba_correcta.py

# Solo análisis sintáctico
docker run --rm -v "${PWD}:/workspace" analizador-lexico make sintactico FILE=entradas/prueba2.py

# Solo análisis léxico
docker run --rm -v "${PWD}:/workspace" analizador-lexico make lexico FILE=entradas/prueba1.py

# Ver ayuda completa del Makefile
docker run --rm -v "${PWD}:/workspace" analizador-lexico make help
```

**Comandos de prueba rápida:**

```powershell
# Probar con archivo de ejemplo
docker run --rm -v "${PWD}:/workspace" analizador-lexico make demo

# Probar archivo sin errores
docker run --rm -v "${PWD}:/workspace" analizador-lexico make test-correcto

# Probar archivo con errores
docker run --rm -v "${PWD}:/workspace" analizador-lexico make test-errores

# Ejecutar todas las pruebas
docker run --rm -v "${PWD}:/workspace" analizador-lexico make test-all
```

## 📋 Comandos Disponibles (Makefile Unificado)

### 📦 Compilación:
| Comando | Descripción |
|---------|-------------|
| `make build` | Compila ambos analizadores (léxico y sintáctico) |
| `make install` | Alias de `build` |
| `make install-basic` | Compila solo el analizador léxico |
| `make install-syntax` | Compila solo el analizador sintáctico |

### 🚀 Ejecución:
| Comando | Descripción |
|---------|-------------|
| `make lexico FILE=archivo.py` | Ejecuta solo análisis léxico |
| `make sintactico FILE=archivo.py` | Ejecuta solo análisis sintáctico |
| `make completo FILE=archivo.py` | Ejecuta ambos análisis |

### 🧪 Pruebas Rápidas:
| Comando | Descripción |
|---------|-------------|
| `make demo` | Prueba con archivo de ejemplo |
| `make test-correcto` | Prueba archivo sin errores |
| `make test-errores` | Prueba archivo con errores sintácticos |
| `make test-all` | Ejecuta todas las pruebas |

### 🧹 Limpieza:
| Comando | Descripción |
|---------|-------------|
| `make clean` | Limpia archivos compilados |
| `make clean-all` | Limpia todo (incluye archivos de salida) |

### ❓ Ayuda:
| Comando | Descripción |
|---------|-------------|
| `make help` | Muestra ayuda completa con ejemplos |

> **Nota**: Los comandos antiguos (`run-basic`, `run-syntax`, `run-all`) siguen funcionando para compatibilidad.

## 💡 Ejemplos de Uso

### 🚀 Inicio Rápido

**1. Compilar todo y ejecutar demo:**
```powershell
docker run --rm -v "${PWD}:/workspace" analizador-lexico make build
docker run --rm -v "${PWD}:/workspace" analizador-lexico make demo
```

**2. Ejecutar todas las pruebas:**
```powershell
docker run --rm -v "${PWD}:/workspace" analizador-lexico make test-all
```

### 🎯 Ejemplos Específicos

**Análisis completo de archivo sin errores:**
```powershell
docker run --rm -v "${PWD}:/workspace" analizador-lexico make completo FILE=entradas/prueba_correcta.py
```

**Analizar archivo con errores sintácticos:**
```powershell
docker run --rm -v "${PWD}:/workspace" analizador-lexico make sintactico FILE=entradas/prueba2.py
```

**Analizar archivo con errores léxicos:**
```powershell
docker run --rm -v "${PWD}:/workspace" analizador-lexico make lexico FILE=entradas/prueba1.py
```

### 🧪 Pruebas Predefinidas

```powershell
# Probar archivo de ejemplo completo
docker run --rm -v "${PWD}:/workspace" analizador-lexico make demo

# Probar archivo sintácticamente correcto
docker run --rm -v "${PWD}:/workspace" analizador-lexico make test-correcto

# Probar archivo con errores sintácticos
docker run --rm -v "${PWD}:/workspace" analizador-lexico make test-errores

# Ejecutar todas las pruebas secuencialmente
docker run --rm -v "${PWD}:/workspace" analizador-lexico make test-all
```

### 🔧 Comandos de Desarrollo

```powershell
# Compilar solo el analizador léxico
docker run --rm -v "${PWD}:/workspace" analizador-lexico make install-basic

# Compilar solo el analizador sintáctico
docker run --rm -v "${PWD}:/workspace" analizador-lexico make install-syntax

# Limpiar y recompilar
docker run --rm -v "${PWD}:/workspace" analizador-lexico make clean
docker run --rm -v "${PWD}:/workspace" analizador-lexico make build

# Ver ayuda completa
docker run --rm -v "${PWD}:/workspace" analizador-lexico make help
```

## 📁 Estructura del Proyecto

```
Lab_Analisis_Lexico-Compiladores/
├── src/                                            # Código fuente
│   ├── LAB01_Arregoces_Gonzalez_Sanchez_Oviedo.l  # Analizador léxico (Flex)
│   ├── LAB02_Analizador_Sintactico.y              # Analizador sintáctico (Yacc/Bison)
│   └── LAB02_Lexico_Sintactico.l                  # Léxico para sintáctico
├── entradas/                                       # Archivos de prueba
│   ├── entrada_ejemplo.py                          # Ejemplo complejo
│   ├── prueba.py                                   # Prueba simple
│   ├── prueba1.py                                  # Prueba con error léxico (=?)
│   ├── prueba2.py                                  # Prueba con errores sintácticos
│   └── prueba_correcta.py                          # Programa sintácticamente correcto
├── salidas/                                        # Archivos de salida (generados)
│   ├── *_tokens.txt                                # Resultados de análisis léxico
│   └── *_sintactico.txt                            # Resultados de análisis sintáctico
├── dist/                                           # Ejecutables (generados)
│   ├── LAB01_Arregoces_Gonzalez_Sanchez_Oviedo    # Ejecutable léxico
│   └── LAB02_Analizador_Sintactico                 # Ejecutable sintáctico
├── Makefile                                        # Sistema de compilación y ejecución
├── Dockerfile                                      # Entorno Docker (Flex+Bison+GCC)
└── README.md                                       # Esta documentación
```

## 📤 Archivos de Salida

El analizador genera automáticamente archivos de salida en el directorio `salidas/`:

- **Nombre del archivo**: `{nombre_archivo_entrada}_tokens.txt`
- **Contenido**:
  - Lista de tokens reconocidos con sus tipos
  - Tabla de identificadores numerados
  - Contador de errores léxicos encontrados

**Ejemplo de salida**:
```
DEF id1=eval parabre=( id2=xi coma=, id3=exp parcierr=) dospunt=: 
    id4=ans asign= = FALSE 
    ...

14 Identificadores

Id1=eval
Id2=xi
Id3=exp
...

2 Errores
```

### Análisis Sintáctico (`*_sintactico.txt`):
- **Nombre del archivo**: `{nombre_archivo_entrada}_sintactico.txt`
- **Contenido**:
  - Resultado del análisis sintáctico
  - Lista de líneas con errores sintácticos
  - Mensaje de éxito si no hay errores

**Ejemplo con errores** (prueba2.py):
```
Prueba con el archivo de entrada
línea 1 error
línea 3 error
línea 4 error
línea 6 error
```

**Ejemplo sin errores** (prueba_correcta.py):
```
Prueba con el archivo de entrada
0 errores
```

## 🔍 Estructuras Sintácticas Soportadas

### 📝 Asignación
```python
x = 10                    # Asignación simple
a, b = 1, 2              # Asignación múltiple
x += 5                   # Asignación con operador
```

### 🔧 Definición de Funciones
```python
def suma(a, b):          # Función con parámetros
    return a + b

def saludar():           # Función sin parámetros
    print("Hola")
```

### 🔀 Condicionales
```python
if x > 0:                # If simple
    print(x)

if x > 0:                # If-else
    print("positivo")
else:
    print("no positivo")

if x > 0:                # If-elif-else
    print("positivo")
elif x == 0:
    print("cero")
else:
    print("negativo")
```

### 🔄 Ciclos
```python
# Ciclo for
for i in range(10):
    print(i)

for item in lista:
    print(item)

# Ciclo while
while x > 0:
    x = x - 1
```

### 📋 Listas y Expresiones
```python
lista = [1, 2, 3, 4]     # Definición de lista
x = lista[0]             # Acceso a elemento
y = len(lista)           # Función len()
z = range(10)            # Función range()
```

### 🎯 Control de Flujo
```python
pass                     # Sentencia vacía
break                    # Salir de ciclo
continue                 # Continuar con siguiente iteración
```

### 🖨️ Otras Estructuras
```python
print(x, y, z)          # Impresión
import math             # Importación de módulos
```

## 🔍 Qué Reconoce el Analizador Léxico

### Palabras Reservadas (19+)
- ✅ **Control de flujo**: `def`, `if`, `else`, `elif`, `for`, `while`, `break`, `continue`, `pass`, `return`
- ✅ **Operadores lógicos**: `and`, `or`, `not`, `in`, `is`
- ✅ **Funciones**: `import`, `print`, `range`, `len`
- ✅ **Valores booleanos**: `True`, `False`

### Tipos de Datos Numéricos
- ✅ **Enteros**: `123`, `-456`, `+789`
- ✅ **Largos**: `40000L`, `-123l`
- ✅ **Reales**: `3.14`, `-2.5e-3`, `1.23E+4`
- ✅ **Imaginarios**: `5j`, `-3.2j`, `1+2j`

### Operadores
- ✅ **Aritméticos**: `+`, `-`, `*`, `/`, `%`, `**` (potencia), `//` (división entera)
- ✅ **Comparación**: `==`, `!=`, `<`, `>`, `<=`, `>=`, `<>` (diferente alternativo)
- ✅ **Asignación**: `=`, `+=`, `-=`, `*=`, `/=`, `//=`
- ✅ **Bit a bit**: `&`, `|`, `^`, `~`, `<<`, `>>`
- ✅ **Lógicos**: `and`, `or`, `not`

### Otros Elementos
- ✅ **Identificadores** (numerados automáticamente)
- ✅ **Cadenas**: `"texto"`, `'texto'`
- ✅ **Delimitadores**: `()`, `[]`, `{}`, `:`, `,`, `;`, `.`
- ✅ **Comentarios** (líneas que empiezan con `#`)
- ✅ **Detección de errores** (caracteres no válidos, números mal formados)

## 🔧 Resolución de Problemas

### Errores Comunes

| Problema | Solución |
|----------|----------|
| **Docker no reconocido** | Instalar Docker Desktop y reiniciar terminal |
| **Archivo no encontrado** | Verificar ruta con `pwd` y usar rutas absolutas si es necesario |
| **Permission denied** | En Linux usar `sudo` antes del comando docker |
| **Flex no instalado** | El Dockerfile incluye todas las dependencias necesarias |
| **Error de compilación** | Usar `make clean` y luego `make install-basic` |

### Verificación del Entorno

```bash
# Verificar que Docker funciona
docker --version

# Verificar que el contenedor se construye correctamente
docker build -t analizador-lexico .

# Verificar que el analizador se compila
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make help"
```

## � Documentación Adicional

- **[QUICKSTART.md](QUICKSTART.md)** - ⚡ Referencia rápida de comandos (Copy & Paste)
- **[MIGRACION.md](MIGRACION.md)** - 🔄 Guía de migración de scripts a Makefile
- **[IMPLEMENTACION.md](IMPLEMENTACION.md)** - 📋 Detalles técnicos de implementación

## �👥 Equipo de Desarrollo

**Laboratorio de Análisis Léxico y Sintáctico - Compiladores**
- **Estudiantes**: Arregoces, Gonzalez, Sanchez, Oviedo
- **Materia**: Compiladores
- **Implementación**: 
  - Análisis Léxico: Flex/Lex con C
  - Análisis Sintáctico: Yacc/Bison con C
  - Sistema de Build: Makefile unificado
  - Entorno: Docker (Ubuntu 20.04 + Flex + Bison + GCC)

---

## 🎉 Características Destacadas

✅ **Makefile Unificado** - Todos los comandos en un solo lugar  
✅ **Pruebas Integradas** - `make test-all` para ejecutar todas las pruebas  
✅ **Validación Automática** - Verifica archivos y herramientas antes de ejecutar  
✅ **Mensajes con Colores** - Salida clara y organizada  
✅ **Compatible con Docker** - Funciona en Windows, Linux y Mac  
✅ **Documentación Completa** - README, QUICKSTART, MIGRACION e IMPLEMENTACION  

---

*Este proyecto implementa un analizador léxico completo para Python usando las herramientas de desarrollo de compiladores.*
