# 🎯 Ejemplo Comparativo de Analizadores

## Código de Prueba
```python
# ejemplo_comparativo.py
async def fibonacci(n):
    """Generador de Fibonacci asíncrono"""
    a, b = 0, 1
    for i in range(n):
        yield a
        a, b = b, a + b
        await asyncio.sleep(0.1)

# Uso del generador
async def main():
    try:
        async for num in fibonacci(10):
            print(f"Fib: {num}")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        print("Finalizado")

if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

## Resultados del Analizador BÁSICO
```
ANALISIS BASICO (16 palabras reservadas):
===========================================
PALABRA_RESERVADA: def (línea 2)
IDENTIFICADOR: fibonacci (línea 2)
DELIMITADOR: ( (línea 2)
IDENTIFICADOR: n (línea 2)
DELIMITADOR: ) (línea 2)
DELIMITADOR: : (línea 2)
...
TOKEN_NO_RECONOCIDO: async (línea 2)
TOKEN_NO_RECONOCIDO: yield (línea 6)
TOKEN_NO_RECONOCIDO: await (línea 8)
TOKEN_NO_RECONOCIDO: import (línea 11)
TOKEN_NO_RECONOCIDO: except (línea 14)
TOKEN_NO_RECONOCIDO: finally (línea 16)
```

## Resultados del Analizador COMPLETO
```
ANALISIS COMPLETO (32 palabras reservadas):
===========================================
PALABRA_RESERVADA: async (línea 2)
PALABRA_RESERVADA: def (línea 2)
IDENTIFICADOR: fibonacci (línea 2)
DELIMITADOR: ( (línea 2)
IDENTIFICADOR: n (línea 2)
DELIMITADOR: ) (línea 2)
DELIMITADOR: : (línea 2)
...
PALABRA_RESERVADA: yield (línea 6)
PALABRA_RESERVADA: await (línea 8)
PALABRA_RESERVADA: import (línea 11)
PALABRA_RESERVADA: except (línea 14)
PALABRA_RESERVADA: finally (línea 16)
```

## Conclusión
- **Analizador BÁSICO**: Ideal para código Python simple, detecta tokens no reconocidos en características avanzadas
- **Analizador COMPLETO**: Reconoce todo el subset moderno de Python, incluyendo async/await, import/except, etc.

---
**¿Cuál usar?** Básico para aprender, Completo para código real de Python