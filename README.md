# 🚀 Analizador Léxico Python - Laboratorio de Compiladores

## 📋 Descripción

**Analizador léxico completo** para Python implementado con Flex/Lex:

- **19+ palabras reservadas** incluyendo `True`, `False`, `import`, `print`, `range`, `len`
- Reconocimiento completo de tipos numéricos (enteros, reales, largos, imaginarios, notación científica)
- Operadores aritméticos, comparación, lógicos, bit a bit y asignación
- Manejo de cadenas, comentarios, delimitadores y errores léxicos
- Generación automática de archivos de salida con tokens y tabla de identificadores

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
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make install-basic && ./dist/LAB01_Arregoces_Gonzalez_Sanchez_Sharick ./entradas/entrada_ejemplo.py"



# Ejecutar con archivo de ejemplo
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run-basic"
```

## 📋 Comandos Disponibles

| Comando | Descripción |
|---------|-------------|
| `make install-basic` | Compila el analizador léxico |
| `make run-basic` | Ejecuta análisis con archivo de ejemplo (`entrada_ejemplo.py`) |
| `make run-basic-file FILE=archivo.py` | Ejecuta análisis con archivo específico |
| `make clean` | Limpia archivos generados (compilados) |
| `make help` | Muestra ayuda del sistema |

## 💡 Ejemplo de Uso

```powershell
# Crear archivo de prueba
echo 'def suma(a, b): return a + b' > ./entradas/prueba.py

# Analizarlo
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "./dist/LAB01_Arregoces_Gonzalez_Sanchez_Sharick ./entradas/prueba.py"
```

## 📁 Estructura del Proyecto

```
Lab_Analisis_Lexico-Compiladores/
├── src/
│   └── LAB01_Arregoces_Gonzalez_Sanchez_Sharick.l  # Código fuente del analizador
├── entradas/
│   ├── entrada_ejemplo.py                          # Archivo de ejemplo con casos complejos
│   └── prueba.py                                   # Archivo de prueba simple
├── salidas/
│   └── entrada_ejemplo_tokens.txt                  # Resultado del análisis
├── dist/
│   └── LAB01_Arregoces_Gonzalez_Sanchez_Sharick    # Ejecutable compilado
├── Makefile                                        # Scripts de compilación
├── Dockerfile                                      # Configuración del entorno Docker
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

## 🔍 Qué Reconoce el Analizador

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

## 👥 Equipo de Desarrollo

**Laboratorio de Análisis Léxico - Compiladores**
- **Estudiantes**: Arregoces, Gonzalez, Sanchez, Sharick
- **Materia**: Compiladores
- **Implementación**: Flex/Lex con C

---

*Este proyecto implementa un analizador léxico completo para Python usando las herramientas de desarrollo de compiladores.*
