# Laboratorio de Análisis Léxico - Compiladores

## Comprensión Profunda del Proyecto

Este laboratorio representa tu primera inmersión real en el fascinante mundo de los compiladores, ahora con **dos enfoques diferentes** para el aprendizaje progresivo. Imagina que estás construyendo los primeros componentes de un traductor universal que puede entender el lenguaje de programación Python a diferentes niveles de complejidad.

Hemos implementado **dos analizadores léxicos**:
- **Analizador BÁSICO**: 16 palabras reservadas fundamentales (ideal para entender los conceptos)
- **Analizador COMPLETO**: 32 palabras reservadas del subset moderno de Python (para análisis completo)

El análisis léxico es como enseñar a una máquina a reconocer las "palabras" individuales de un lenguaje de programación, de la misma manera que un niño aprende a distinguir entre diferentes tipos de palabras cuando está aprendiendo a leer.

## Arquitectura del Sistema con Docker

Hemos diseñado este laboratorio usando Docker para eliminar completamente los problemas de configuración del entorno. Piensa en Docker como una máquina virtual liviana que contiene exactamente las herramientas que necesitas, configuradas de la manera correcta, sin importar qué sistema operativo uses en tu computadora personal.

La belleza de esta aproximación es que todos los estudiantes trabajarán en exactamente el mismo entorno, lo que significa que si tu código funciona en tu máquina, funcionará en todas las demás. Esto es especialmente importante en compiladores, donde pequeñas diferencias en las versiones de las herramientas pueden causar comportamientos inesperados.

## Entendiendo los Componentes del Sistema

### Los Corazones del Sistema: analizador_lexico.l y analizador_basico.l

Estos archivos son donde ocurre toda la magia. Están escritos en el lenguaje de especificación de Lex (también conocido como Flex), que es una herramienta diseñada específicamente para crear analizadores léxicos.

**analizador_lexico.l** (COMPLETO - 171 líneas):
- 32 palabras reservadas completas de Python
- Operadores avanzados y números complejos
- Manejo completo de características modernas como async/await

**analizador_basico.l** (BÁSICO - 120 líneas):
- 16 palabras reservadas fundamentales
- Operadores básicos esenciales
- Perfecto para entender los conceptos sin abrumarse

Cada archivo tiene tres secciones principales que trabajan en armonía:
1. **Declaraciones**: Variables globales y patrones reutilizables
2. **Reglas**: Asociaciones patrón-acción usando expresiones regulares
3. **Código C**: Función main() que orquesta el análisis

### El Cerebro Organizativo: Makefile

El Makefile es como un chef que conoce exactamente las recetas para crear **ambos analizadores léxicos**. Automatiza los procesos de compilación para:

- **Analizador BÁSICO**: `make install-basic`, `make run-basic`
- **Analizador COMPLETO**: `make install`, `make run`
- **Comandos comparativos**: `make both`, `make stats`

Esta automatización es fundamental porque el proceso manual sería propenso a errores y tedioso. El Makefile incluye objetivos útiles para ejecutar pruebas, comparar ambos analizadores y limpiar archivos temporales.

### El Entorno Controlado: Configuración Docker

Los archivos `Dockerfile` y `docker-compose.yml` trabajan juntos para crear un entorno de desarrollo consistente. El Dockerfile define las instrucciones para crear una imagen que contenga Ubuntu con todas las herramientas necesarias instaladas. El docker-compose.yml orquesta cómo usar esa imagen, incluyendo cómo montar nuestro código fuente para desarrollo en tiempo real.

## Proceso Educativo Paso a Paso

### Preparación del Entorno

Antes de comenzar, asegúrate de que Docker y Docker Compose estén instalados en tu sistema. Estos son los únicos requisitos previos, gracias a nuestro enfoque containerizado.

Descarga todos los archivos del laboratorio y colócalos en un directorio de trabajo. La estructura debería verse así:

```
laboratorio-lexico/
├── Dockerfile
├── docker-compose.yml
├── analizador_lexico.l
├── entrada_ejemplo.py
├── Makefile
├── ejecutar_laboratorio.sh
└── README.md
```

### Ejecución Guiada para Principiantes

La forma más sencilla de comenzar es usar nuestro script automatizado. Abre una terminal en el directorio del proyecto y ejecuta:

```bash
chmod +x ejecutar_laboratorio.sh
./ejecutar_laboratorio.sh
```

Este script te guiará a través de diferentes opciones de ejecución. Para tu primera experiencia, recomiendo elegir la opción 1 (compilar y ejecutar automáticamente), que te permitirá ver el analizador en acción sin preocuparte por los detalles de compilación.

### Desarrollo Interactivo para Aprendizaje Profundo

Una vez que hayas visto el analizador funcionando, es momento de sumergirte en desarrollo interactivo. Esto te permitirá experimentar, hacer cambios, y ver los resultados inmediatamente.

Ejecuta el script nuevamente y elige la opción 2 para entrar al contenedor de desarrollo. Una vez dentro, tienes acceso a todos los comandos de Make:

- `make all` compila el analizador desde cero
- `make run` ejecuta el analizador con el archivo de ejemplo
- `make clean` limpia todos los archivos generados
- `make help` muestra todas las opciones disponibles

### Experimentación y Personalización

El verdadero aprendizaje viene de la experimentación. Intenta modificar el archivo `entrada_ejemplo.py` para incluir diferentes tipos de tokens de Python. Observa cómo el analizador responde a cada cambio.

También puedes crear tus propios archivos de prueba y usar la opción 4 del script de ejecución para procesarlos. Esto te ayudará a entender las capacidades y limitaciones de tu analizador léxico.

## Arquitectura Técnica Detallada

### Manejo de Identificadores Únicos

Una de las partes más elegantes de nuestro analizador es cómo maneja los identificadores. En lugar de simplemente imprimir cada identificador que encuentra, el sistema mantiene un registro de identificadores únicos y les asigna números consecutivos.

La función `get_id_number()` implementa esta lógica. Cuando encuentra un identificador, primero busca en el array de identificadores ya registrados. Si lo encuentra, devuelve el número que ya tenía asignado. Si es nuevo, lo agrega al array y le asigna el siguiente número disponible.

Esta aproximación es importante porque simula cómo un compilador real manejaría las tablas de símbolos. En un compilador completo, esta información se usaría en fases posteriores para resolver referencias a variables y funciones.

### Reconocimiento de Patrones Complejos

El reconocimiento de números demuestra la potencia de las expresiones regulares. Considera cómo nuestro analizador puede distinguir entre un entero simple como `42`, un número decimal como `3.14`, un entero largo como `40000L`, y un número imaginario como `5j`.

La clave está en el orden de las reglas. Las reglas más específicas (como números imaginarios) van primero, seguidas por las menos específicas (como enteros simples). Esto asegura que cada token sea clasificado con la mayor precisión posible.

### Manejo Robusto de Errores

Nuestro analizador incluye manejo de errores léxicos, que es crucial para una herramienta de compilación robusta. Cuando encuentra un carácter o secuencia de caracteres que no corresponde a ningún token válido, lo marca como error pero continúa procesando el resto del archivo.

Este comportamiento es importante porque permite al programador ver todos los errores léxicos de una vez, en lugar de tener que corregir un error a la vez y reejecutar el analizador.

## Extensiones y Mejoras Futuras

Una vez que domines el analizador básico, puedes considerar varias extensiones educativas. Podrías agregar soporte para más tipos de tokens de Python, como números hexadecimales o strings con comillas triples. También podrías implementar mejor manejo de espacios en blanco y comentarios.

Para estudiantes avanzados, una extensión interesante sería agregar información de posición (línea y columna) a cada token, lo cual sería útil para reportar errores más precisos en fases posteriores del compilador.

## Entrega y Documentación

Recuerda que tu entrega debe incluir no solo el código funcionando, sino también un manual de instalación y uso. Afortunadamente, nuestro enfoque con Docker simplifica enormemente este proceso, ya que las instrucciones de instalación se reducen a "instalar Docker y ejecutar el script".

Tu manual debería explicar cómo usar cada comando disponible, cómo interpretar la salida del analizador, y qué hacer si se encuentran errores. También es útil incluir ejemplos de diferentes tipos de archivos de entrada y sus salidas esperadas.

El objetivo no es solo entregar código que funcione, sino demostrar que entiendes profundamente cómo funciona cada componente y por qué está diseñado de esa manera. Este entendimiento profundo te servirá en las siguientes fases del curso de compiladores y en tu carrera profesional.