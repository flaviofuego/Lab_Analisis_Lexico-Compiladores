def suma(a, b):
    return a + b

x = 10
y = 20
resultado = suma(x, y)
print(resultado)

lista = [1, 2, 3, 4, 5]
for i in range(len(lista)):
    if lista[i] > 2:
        print(lista[i])

while x > 0:
    x = x - 1
    if x == 5:
        break

def factorial(n):
    if n == 0:
        return 1
    else:
        return n * factorial(n - 1)
