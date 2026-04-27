# Práctica 05 — Producto Punto de Vectores en Ensamblador x86

## Descripción

Programa mixto **ensamblador x86 + C++** que calcula el **producto punto** (producto escalar) de dos vectores de números reales de dimensión arbitraria N. La función ensamblador recorre ambos vectores simultáneamente usando registros puntero, acumula los productos elemento a elemento en la pila de la FPU, y devuelve el resultado escalar en `ST(0)`.

La operación implementada es:

```
u · v = u[0]*v[0] + u[1]*v[1] + ... + u[N-1]*v[N-1]
```

---

## Estructura del Proyecto

```
Practica05_ProductoPunto/
├── productoPunto.asm   # Función en ensamblador x86: recorre los vectores y acumula el producto
└── main.cpp            # Programa principal en C++: solicita datos y muestra el resultado
```

---

## Interfaz y Convención de Llamada

La función ensamblador es invocada desde C++ usando la convención **cdecl** (convención C plana):

| Elemento               | Descripción                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `.model flat, c`       | Modelo de memoria plana con compatibilidad de nombres C                     |
| `extern "C"` en C++    | Desactiva el *name mangling* para que el enlazador ubique el símbolo `productoPunto` |
| `[EBP+8]`              | Puntero a `vec1` (`double*`, 4 bytes en x86)                               |
| `[EBP+12]`             | Puntero a `vec2` (`double*`, 4 bytes en x86)                               |
| `[EBP+16]`             | Dimensión `N` (`int`, 4 bytes)                                             |
| `ST(0)` al hacer `RET` | Registro donde se deposita el resultado `double` para el llamador           |
| `ESI`, `EDI`           | Preservados con `PUSH`/`POP` según exige la convención *cdecl*              |

Cada elemento `double` del vector ocupa **8 bytes**; por eso los punteros avanzan con `ADD ESI, 8` y `ADD EDI, 8` en cada iteración.

---

## Funcionamiento del Algoritmo

La función implementa un **bucle de acumulación** sobre la pila de la FPU. Antes de entrar al bucle, verifica que `N > 0`; si no, retorna `0.0` inmediatamente.

### Registros utilizados

| Registro | Rol                                                              |
|----------|------------------------------------------------------------------|
| `ESI`    | Puntero al elemento actual de `vec1`; avanza 8 bytes por iteración |
| `EDI`    | Puntero al elemento actual de `vec2`; avanza 8 bytes por iteración |
| `ECX`    | Contador decreciente: inicia en `N` y llega a 0 al terminar      |
| `ST(0)`  | Producto parcial `vec1[i] * vec2[i]` durante la iteración; acumulador entre iteraciones |
| `ST(1)`  | Acumulador desplazado temporalmente mientras `ST(0)` contiene el producto |

### Flujo de ejecución

```
Inicio
 └─ ESI = &vec1[0], EDI = &vec2[0], ECX = N
 └─ FLDZ → ST(0) = 0.0  (acumulador)
 └─ TEST ECX, ECX → N <= 0 ? → fin (retorna 0.0)

bucle:
 ├─ FLD  [ESI]        → ST(0)=vec1[i],  ST(1)=acum
 ├─ FMUL [EDI]        → ST(0)=v1[i]*v2[i],  ST(1)=acum
 ├─ FADDP ST(1),ST(0) → ST(0)=acum + producto  (pop)
 ├─ ADD ESI, 8        → avanzar al siguiente double de vec1
 ├─ ADD EDI, 8        → avanzar al siguiente double de vec2
 ├─ DEC ECX
 └─ JNZ bucle         → repetir si ECX != 0

fin:
 └─ RET → ST(0) = resultado final
```

### Estado de la pila FPU por instrucción

| Instrucción          | ST(0)               | ST(1) |
|----------------------|---------------------|-------|
| `FLDZ`               | `0.0` (acum)        | —     |
| `FLD [ESI]`          | `vec1[i]`           | acum  |
| `FMUL [EDI]`         | `vec1[i] * vec2[i]` | acum  |
| `FADDP ST(1),ST(0)`  | `acum + producto`   | —     |

### Ejemplo con u=(2, 3, 4) y v=(1, 5, 2)

| Iteración | vec1[i] | vec2[i] | Producto | Acumulador |
|-----------|---------|---------|----------|------------|
| inicial   | —       | —       | —        | 0          |
| 1         | 2.0     | 1.0     | 2        | 2          |
| 2         | 3.0     | 5.0     | 15       | 17         |
| 3         | 4.0     | 2.0     | 8        | **25**     |

Resultado final: **25**

---

## Instrucciones x86 Utilizadas

### FPU

| Instrucción  | Operación                                                             |
|--------------|-----------------------------------------------------------------------|
| `FLDZ`       | Carga la constante `0.0` al tope de la pila FPU; inicializa el acumulador |
| `FLD`        | Carga un `double` (8 bytes) desde memoria al tope de la pila FPU     |
| `FMUL`       | Multiplica `ST(0)` por el operando de memoria; resultado en `ST(0)`  |
| `FADDP`      | Suma `ST(0)` a `ST(1)` y hace *pop*; acumulador actualizado en `ST(0)` |

### Propósito general

| Instrucción    | Operación                                                            |
|----------------|----------------------------------------------------------------------|
| `PUSH` / `POP` | Prólogo/epílogo del marco de pila y preservación de `ESI`, `EDI`    |
| `MOV`          | Carga punteros y contador desde el marco de pila a los registros     |
| `ADD`          | Avanza los punteros `ESI` y `EDI` en 8 bytes por iteración          |
| `DEC`          | Decrementa `ECX` y actualiza banderas para el salto `JNZ`           |
| `TEST`         | Verifica si `ECX == 0` antes de entrar al bucle (AND lógica)         |
| `JLE`          | Salta al final si `N <= 0`; protección contra dimensión inválida     |
| `JNZ`          | Repite el bucle si `ECX != 0`                                        |
| `RET`          | Retorna al llamador; el resultado `double` permanece en `ST(0)`      |

---

## Ejemplo de Ejecución

```
Ingresa la dimension de los vectores (N): 3

--- DATOS DEL VECTOR 1 ---
Ingresa el valor para vec1[0]: 2
Ingresa el valor para vec1[1]: 3
Ingresa el valor para vec1[2]: 4

--- DATOS DEL VECTOR 2 ---
Ingresa el valor para vec2[0]: 1
Ingresa el valor para vec2[1]: 5
Ingresa el valor para vec2[2]: 2

----------------------------------------
Resultado del Producto Punto: 25
```

---

## Requisitos

- **Ensamblador:** MASM (Microsoft Macro Assembler), incluido en Visual Studio
- **Compilador C++:** MSVC (Visual Studio 2019 o superior)
- **Arquitectura:** x86 (32 bits), modo protegido plano (`flat`)
- **Sistema operativo:** Windows
- **Convención de llamadas:** `cdecl` / convención C (`flat, c`)
