# 🚀 Guía Completa de Uso del Repositorio - Analizador Léxico Python

## 📋 Descripción
Este repositorio contiene un **analizador léxico completo para el lenguaje Python** implementado con Flex/Lex. El analizador reconoce tokens, palabras reservadas, identificadores, números, operadores, delimitadores y maneja errores léxicos.

## 🛠️ Requisitos Previos

### Para Windows (Recomendado)
- **Docker Desktop** instalado y funcionando
- **PowerShell** o **Command Prompt**

### Para Linux/Unix
- **Flex** (sudo apt install flex / yum install flex)
- **GCC** compiler
- **Make**

## 📥 Cómo Usar el Repositorio

### 1. Clonar el Repositorio
```bash
git clone https://github.com/flaviofuego/Lab_Analisis_Lexico-Compiladores.git
cd Lab_Analisis_Lexico-Compiladores
```

### 2. En Windows con Docker (Método Recomendado)

#### Construcción de la imagen Docker (solo la primera vez):
```powershell
docker build -t analizador-lexico .
```

#### Comandos principales:
```powershell
# Instalación completa desde cero
docker run --rm -v "E:\Repos Git\Lab_Analisis_Lexico-Compiladores:/workspace" analizador-lexico bash -c "make install"

# Compilar el analizador
docker run --rm -v "E:\Repos Git\Lab_Analisis_Lexico-Compiladores:/workspace" analizador-lexico bash -c "make all"

# Ejecutar con archivo de ejemplo
docker run --rm -v "E:\Repos Git\Lab_Analisis_Lexico-Compiladores:/workspace" analizador-lexico bash -c "make run"

# Ejecutar con archivo personalizado
docker run --rm -v "E:\Repos Git\Lab_Analisis_Lexico-Compiladores:/workspace" analizador-lexico bash -c "make run-file FILE=mi_archivo.py"

# Ver estadísticas del proyecto
docker run --rm -v "E:\Repos Git\Lab_Analisis_Lexico-Compiladores:/workspace" analizador-lexico bash -c "make stats"

# Limpiar archivos generados
docker run --rm -v "E:\Repos Git\Lab_Analisis_Lexico-Compiladores:/workspace" analizador-lexico bash -c "make clean"

# Ver ayuda completa
docker run --rm -v "E:\Repos Git\Lab_Analisis_Lexico-Compiladores:/workspace" analizador-lexico bash -c "make help"
```

#### Modo interactivo (para desarrollo):
```powershell
# Entrar al contenedor
docker run --rm -it -v "E:\Repos Git\Lab_Analisis_Lexico-Compiladores:/workspace" analizador-lexico bash

# Dentro del contenedor puedes usar:
make install    # Instalación completa
make run       # Ejecutar análisis
make clean     # Limpiar
exit           # Salir del contenedor
```

### 3. En Linux/Unix (Directo)

```bash
# Verificar dependencias
make check-deps

# Instalación completa
make install

# Compilar
make all

# Ejecutar con ejemplo
make run

# Ejecutar con archivo personalizado
make run-file FILE=mi_archivo.py

# Ver ayuda
make help
```

## 📂 Estructura del Proyecto

```
Lab_Analisis_Lexico-Compiladores/
├── analizador_lexico.l          # Código fuente Flex del analizador
├── entrada_ejemplo.py           # Archivo de prueba
├── Makefile                     # Sistema de construcción
├── Dockerfile                   # Configuración Docker
├── docker-compose.yml           # Orquestación Docker
├── ejecutar_laboratorio.sh      # Script para sistemas Unix
├── README.md                    # Documentación básica
├── GUIA_USO.md                  # Esta guía (este archivo)
├── VERIFICACION_CUMPLIMIENTO.md # Verificación de requisitos
└── .gitignore                   # Archivos ignorados por Git
```

## 🎯 Comandos Make Disponibles

| Comando | Descripción |
|---------|-------------|
| `make install` | Instalación completa: verifica deps + limpia + compila |
| `make all` | Compilar el analizador léxico |
| `make run` | Ejecutar con archivo de ejemplo (entrada_ejemplo.py) |
| `make run-file FILE=archivo.py` | Ejecutar con archivo específico |
| `make run-custom` | Ejecutar con entrada desde teclado |
| `make clean` | Limpiar archivos generados |
| `make check-deps` | Verificar que Flex y GCC estén instalados |
| `make stats` | Mostrar estadísticas del proyecto |
| `make help` | Mostrar ayuda completa |

## 💡 Ejemplos de Uso

### Ejemplo 1: Primer uso del repositorio
```powershell
# Windows con Docker
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make install"
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run"
```

### Ejemplo 2: Analizar tu propio código Python
```powershell
# Crear tu archivo Python
echo 'def hola(): print("Hola mundo")' > mi_codigo.py

# Analizarlo
docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run-file FILE=mi_codigo.py"
```

### Ejemplo 3: Desarrollo y modificación
```powershell
# Entrar al contenedor para desarrollo
docker run --rm -it -v "${PWD}:/workspace" analizador-lexico bash

# Dentro del contenedor:
make clean        # Limpiar
nano analizador_lexico.l  # Editar el analizador
make all          # Recompilar
make run          # Probar
exit              # Salir
```

## 🔍 Qué Reconoce el Analizador

### ✅ Tokens Reconocidos:
- **32 Palabras reservadas**: `def`, `if`, `else`, `for`, `while`, `class`, `import`, `try`, `except`, etc.
- **Identificadores**: Variables y funciones (numerados secuencialmente)
- **Números**: Enteros, decimales, científicos, largos, imaginarios
- **Operadores**: Aritméticos, comparación, lógicos, asignación, bitwise
- **Delimitadores**: `()`, `[]`, `{}`, `:`, `;`, `,`, `.`
- **Cadenas**: Con comillas simples y dobles
- **Comentarios**: Se ignoran correctamente

### 📊 Salida del Análisis:
- Lista de tokens encontrados
- Numeración de identificadores únicos
- Conteo de errores léxicos
- Estadísticas finales

## 🐛 Resolución de Problemas

### Error: "Docker no reconocido"
```powershell
# Asegúrate de que Docker Desktop esté instalado y ejecutándose
docker --version
```

### Error: "Archivo no encontrado"
```powershell
# Verifica la ruta actual
pwd
# Usa rutas absolutas si es necesario
docker run --rm -v "C:\ruta\completa:/workspace" analizador-lexico bash -c "make run"
```

### Error: "Permission denied"
```bash
# En Linux, puede necesitar sudo
sudo docker run --rm -v "${PWD}:/workspace" analizador-lexico bash -c "make run"
```

## 🚀 Flujo de Trabajo Recomendado

1. **Primera vez**: `make install`
2. **Desarrollo**: Editar `analizador_lexico.l`
3. **Compilar**: `make all`
4. **Probar**: `make run` o `make run-file FILE=tu_archivo.py`
5. **Limpiar**: `make clean` (cuando termines)

## 📝 Archivos de Entrada

Puedes analizar cualquier archivo `.py` que contenga código Python. El analizador procesará:
- Sintaxis válida de Python
- Caracteres inválidos (reportados como errores)
- Combinaciones de todos los elementos léxicos

## 🎓 Propósito Educativo

Este proyecto es ideal para:
- Aprender análisis léxico
- Entender Flex/Lex
- Estudiar la primera fase de compiladores
- Practicar con Docker y Make
- Análisis de lenguajes de programación

---

**¡El repositorio está listo para usar! Todos los comandos Make han sido probados y funcionan correctamente.** 🎉