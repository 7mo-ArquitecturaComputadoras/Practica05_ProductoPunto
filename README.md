# 🔢 Práctica 05 — Producto Punto de Vectores en Ensamblador x86

Programa mixto **ensamblador x86 + C++** que calcula el **producto punto** (producto escalar) de dos vectores de números reales de dimensión arbitraria N. La función ensamblador recorre ambos vectores simultáneamente usando registros puntero, acumula los productos elemento a elemento en la pila de la FPU, y devuelve el resultado escalar en `ST(0)`.

---

## 📑 Índice

- [🎯 ¿Qué hace el programa?](#-qué-hace-el-programa)
- [🧠 Idea central del algoritmo](#-idea-central-del-algoritmo)
- [📂 Estructura del repositorio](#-estructura-del-repositorio)
- [🚀 Cómo empezar](#-cómo-empezar)
- [🔍 Trazado del ejemplo `u=(2,3,4)` y `v=(1,5,2)`](#-trazado-del-ejemplo-u234-y-v152)
- [📘 Instrucciones x86 utilizadas](#-instrucciones-x86-utilizadas)
- [📄 Documentación adicional](#-documentación-adicional)

---

## 🎯 ¿Qué hace el programa?

El programa toma dos vectores de **N elementos reales** ingresados por el usuario y calcula su **producto punto** mediante un algoritmo en ensamblador x86 que usa la FPU (Floating Point Unit) del procesador.

La operación implementada es:

```
u · v = u[0]*v[0] + u[1]*v[1] + ... + u[N-1]*v[N-1]
```

Por ejemplo, para los vectores `u=(2, 3, 4)` y `v=(1, 5, 2)`:
- Entrada: 2 vectores con N=3
- Salida: `u · v = 2*1 + 3*5 + 4*2 = 25`

La función ensamblador es invocada desde C++ usando la convención **cdecl** (convención C plana), preservando los registros `ESI` y `EDI` según las normas de llamada.

---

## 🧠 Idea central del algoritmo

La función implementa un **bucle de acumulación** sobre la pila de la FPU. Antes de entrar al bucle, verifica que `N > 0`; si no, retorna `0.0` inmediatamente.

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

### Registros utilizados

| Registro | Rol                                                              |
|----------|------------------------------------------------------------------|
| `ESI`    | Puntero al elemento actual de `vec1`; avanza 8 bytes por iteración |
| `EDI`    | Puntero al elemento actual de `vec2`; avanza 8 bytes por iteración |
| `ECX`    | Contador decreciente: inicia en `N` y llega a 0 al terminar      |
| `ST(0)`  | Producto parcial / Acumulador entre iteraciones                  |
| `ST(1)`  | Acumulador desplazado temporalmente mientras `ST(0)` contiene el producto |

Cada elemento `double` del vector ocupa **8 bytes**; por eso los punteros avanzan con `ADD ESI, 8` y `ADD EDI, 8` en cada iteración.

---

## 📂 Estructura del repositorio

```
Practica05_ProductoPunto/
├── documentacion/
│   ├── README_compilacion_latex.md         # Cómo compilar el .tex a PDF
│   ├── reporte.pdf                         # Reporte técnico compilado
│   ├── reporte.tex                         # Reporte técnico en LaTeX
│   └── imagenes/                           # Imágenes usadas en el reporte
│
├── proyecto/
│   ├── README_instalacion.md               # Guía de instalación y puesta en marcha
│   ├── Practica05_ProductoPunto.slnx       # Solución de Visual Studio
│   ├── Practica05_ProductoPunto.vcxproj    # Proyecto MSBuild + MASM
│   └── src/
│       ├── productoPunto.asm               # Función en ensamblador x86 (FPU)
│       └── main.cpp                        # Interfaz C++ (entrada/salida)
│
├── .gitattributes                          # Normalización de finales de línea
├── .gitignore                              # Archivos ignorados por Git
└── README.md                               # Este archivo
```

---

## 🚀 Cómo empezar

La guía detallada con todos los pasos (instalar Git, Visual Studio, habilitar MASM, compilar y ejecutar) está en un documento aparte:

➡️ **[Guía de instalación y puesta en marcha](proyecto/README_instalacion.md)**

Resumen rápido para quien ya tiene el entorno listo:

1. Abre el **Símbolo del sistema** (`cmd`) o **Git Bash**, ubícate en la carpeta donde quieras guardar el proyecto y ejecuta:

```bash
git clone git@github.com:7mo-ArquitecturaComputadoras/Practica05_ProductoPunto.git
```
2. Abrir `proyecto/Practica05_ProductoPunto.slnx` en Visual Studio.
3. Seleccionar configuración **Debug | Win32**.
4. Compilar con `Ctrl + Shift + B` y ejecutar con `Ctrl + F5`.
5. Ingresar la dimensión `N` y los valores de ambos vectores cuando lo solicite.

---

## 🔍 Trazado del ejemplo `u=(2,3,4)` y `v=(1,5,2)`

### Estado de la pila FPU por instrucción

| Instrucción          | ST(0)               | ST(1) |
|----------------------|---------------------|-------|
| `FLDZ`               | `0.0` (acum)        | —     |
| `FLD [ESI]`          | `vec1[i]`           | acum  |
| `FMUL [EDI]`         | `vec1[i] * vec2[i]` | acum  |
| `FADDP ST(1),ST(0)`  | `acum + producto`   | —     |

### Iteración completa para `u=(2,3,4)` y `v=(1,5,2)`

| Iteración | vec1[i] | vec2[i] | Producto | Acumulador |
|-----------|---------|---------|----------|------------|
| inicial   | —       | —       | —        | 0          |
| 1         | 2.0     | 1.0     | 2        | 2          |
| 2         | 3.0     | 5.0     | 15       | 17         |
| 3         | 4.0     | 2.0     | 8        | **25**     |

Resultado final: **25** (almacenado en `ST(0)` al retornar)

---

## 📘 Instrucciones x86 utilizadas

### FPU (Floating Point Unit)

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

## 📄 Documentación adicional

| Documento | Descripción |
|---|---|
| 🛠️ [`README_instalacion.md`](proyecto/README_instalacion.md) | Cómo instalar Git, Visual Studio con MASM, compilar y ejecutar el programa paso a paso. |
| 📄 [`README_compilacion_latex.md`](documentacion/README_compilacion_latex.md) | Cómo regenerar el PDF del reporte a partir de `reporte.tex` usando TeX Live, Geany o VS Code, tanto en Linux como en Windows. |
| 📕 [`reporte.pdf`](documentacion/reporte.pdf) | Reporte técnico ya compilado, con análisis detallado del algoritmo y la pila FPU. |
| 📝 [`reporte.tex`](documentacion/reporte.tex) | Fuente LaTeX del reporte técnico. |

---

> **Autor:** Edson Joel Carrera Avila
