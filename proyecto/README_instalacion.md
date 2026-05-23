# 🛠️ Instalación y Puesta en Marcha

Guía paso a paso para clonar, compilar y ejecutar la **Práctica 05 — Producto Punto de Vectores** en un equipo nuevo. Esta práctica está escrita en **ensamblador x86 (MASM)** con una interfaz en **C++** y se compila con **Visual Studio** en **Windows**.

---

## 📑 Índice

- [📚 ¿Qué herramientas necesitas?](#-qué-herramientas-necesitas)
- [🔗 Enlaces de descarga](#-enlaces-de-descarga)
- [1️⃣ Instalar Git](#1️⃣-instalar-git)
- [2️⃣ Instalar Visual Studio con MASM](#2️⃣-instalar-visual-studio-con-masm)
- [3️⃣ Clonar el repositorio](#3️⃣-clonar-el-repositorio)
- [4️⃣ Abrir la solución en Visual Studio](#4️⃣-abrir-la-solución-en-visual-studio)
- [5️⃣ Habilitar MASM en el proyecto](#5️⃣-habilitar-masm-en-el-proyecto)
- [6️⃣ Compilar el proyecto](#6️⃣-compilar-el-proyecto)
- [7️⃣ Ejecutar y observar el resultado](#7️⃣-ejecutar-y-observar-el-resultado)
- [❗ Problemas comunes](#-problemas-comunes)

---

## 📚 ¿Qué herramientas necesitas?

Antes de empezar, conviene entender qué hace cada programa:

- **Git**: Sistema de control de versiones. Sirve para descargar (clonar) el repositorio a tu computadora.
- **Visual Studio**: Entorno integrado de desarrollo (IDE) de Microsoft. Incluye el compilador, el linker y, lo más importante para esta práctica, **MASM** (`ml.exe`), el ensamblador que traduce `productoPunto.asm` a un ejecutable.
- **MASM** (*Microsoft Macro Assembler*): No se instala por separado, viene incluido dentro de la carga de trabajo *Desktop development with C++* de Visual Studio.

> 💡 No se requiere ningún compilador externo ni librerías adicionales. Todo lo que necesitas está dentro de Visual Studio.

---

## 🔗 Enlaces de descarga

| Herramienta | Windows |
|---|---|
| **Git** | [https://git-scm.com/download/win](https://git-scm.com/download/win) |
| **Visual Studio Community** (gratuito) | [https://visualstudio.microsoft.com/es/downloads/](https://visualstudio.microsoft.com/es/downloads/) |

> ⚠️ Esta práctica solo se compila en **Windows**, porque el código usa la convención `cdecl` con MASM x86 (32 bits). No funciona nativamente en Linux ni macOS.

---

## 1️⃣ Instalar Git

1. Entra a [https://git-scm.com/download/win](https://git-scm.com/download/win).
2. Descarga el instalador `.exe` (la descarga inicia automáticamente).
3. Ejecuta el instalador y acepta las opciones por defecto pulsando **"Next"** en cada pantalla.

Para verificar la instalación, abre el **Símbolo del sistema** (escribe `cmd` en el menú Inicio) y ejecuta:

```cmd
git --version
```

Si aparece un número de versión, todo está listo.

---

## 2️⃣ Instalar Visual Studio con MASM

1. Entra a [https://visualstudio.microsoft.com/es/downloads/](https://visualstudio.microsoft.com/es/downloads/).
2. Descarga **Visual Studio Community** (la versión gratuita).
3. Ejecuta el instalador. Aparecerá una ventana llamada **"Visual Studio Installer"**.
4. En la pestaña **"Cargas de trabajo"** (*Workloads*), marca la casilla:

   ✅ **Desarrollo para el escritorio con C++** (*Desktop development with C++*)

   > 🔑 Esta casilla es **obligatoria**: dentro de ella viene MASM (`ml.exe`), el ensamblador que compila el archivo `.asm`. Sin esta carga de trabajo, el proyecto **no compilará**.

5. Haz clic en **"Instalar"** y espera. La descarga e instalación puede tardar entre 30 minutos y 2 horas según tu conexión.

> ⏳ Visual Studio ocupa entre 8 y 15 GB de espacio en disco con esta carga de trabajo.

---

## 3️⃣ Clonar el repositorio

Abre el **Símbolo del sistema** (`cmd`) o **Git Bash**, ubícate en la carpeta donde quieras guardar el proyecto y ejecuta:

```bash
git git@github.com:7mo-ArquitecturaComputadoras/Practica05_ProductoPunto.git
```

> 💡 Reemplaza `<url-del-repositorio>` por el enlace HTTPS o SSH del repositorio en GitHub/GitLab.

---

## 4️⃣ Abrir la solución en Visual Studio

1. Entra a la carpeta `proyecto/` dentro del repositorio.
2. Haz doble clic sobre **`Practica05_ProductoPunto.slnx`**.
3. Visual Studio se abrirá y cargará automáticamente el proyecto, incluido el archivo `src/productoPunto.asm`.

> 💡 El archivo `.slnx` es la versión moderna de los `.sln` clásicos. Si tu versión de Visual Studio no lo reconoce, abre directamente el `.vcxproj`.

---

## 5️⃣ Habilitar MASM en el proyecto

La primera vez que abras la solución, es posible que Visual Studio no reconozca las directivas `.586`, `.model`, etc. Para activar MASM:

1. En el **Explorador de soluciones** (panel derecho), haz clic derecho sobre el proyecto **Practica05_ProductoPunto**.
2. Selecciona **"Generar dependencias"** → **"Personalizaciones de compilación…"** (*Build Customizations…*).
3. En la lista que aparece, marca la casilla:

   ✅ **masm(.targets, .props)**

4. Pulsa **"Aceptar"**.

> ⚠️ Si esta casilla **no aparece** en la lista, significa que MASM no se instaló. Vuelve al paso 2️⃣ y verifica que marcaste la carga de trabajo *Desarrollo para el escritorio con C++*.

---

## 6️⃣ Compilar el proyecto

1. En la barra superior, selecciona la configuración **Debug** y la plataforma **Win32** (32 bits).

   > 🔑 Es **obligatorio** usar **Win32**, porque el código está escrito con `.model flat, c` (32 bits). En **x64** no compilará.

2. Pulsa `Ctrl + Shift + B` o ve al menú **Compilar** → **Compilar solución**.
3. En la ventana de salida (parte inferior) debe aparecer:

   ```
   ========== Compilación: 1 correctos, 0 incorrectos ==========
   ```

El ejecutable se generará en `proyecto/Debug/Practica05_ProductoPunto.exe`.

> 💡 La carpeta `Debug/` está incluida en el `.gitignore` y no se sube al repositorio: cada quien la genera localmente al compilar.

---

## 7️⃣ Ejecutar y observar el resultado

El programa solicita la **dimensión N** y los **valores de ambos vectores**, y calcula su producto punto usando la FPU del procesador.

1. Pulsa `Ctrl + F5` para ejecutar sin depuración.
2. Ingresa la dimensión `N` (por ejemplo, `3`).
3. Ingresa los valores del vector 1 (uno por línea).
4. Ingresa los valores del vector 2 (uno por línea).
5. Observa el resultado del producto punto en la consola.

### Ejemplo de ejecución

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

Para depuración avanzada (inspeccionar la pila FPU):

1. Abre `proyecto/src/productoPunto.asm` en el editor.
2. Coloca un *breakpoint* en la etiqueta `bucle:` o `fin:`.
3. Pulsa `F5` para iniciar la depuración.
4. Inspecciona los registros FPU en **Depurar** → **Ventanas** → **Registros** (mostrará `ST(0)`, `ST(1)`, etc.).
5. Para ver memoria, ve a **Depurar** → **Ventanas** → **Memoria 1** y escribe `&vec1[0]` o `&vec2[0]`.

---

## ❗ Problemas comunes

| Síntoma | Causa probable | Solución |
|---|---|---|
| `error A2006: undefined symbol : ExitProcess` | Configuración en **x64** con código de 32 bits | Cambia la plataforma a **Win32** en la barra superior |
| `error MSB6006: "ml.exe" exited with code 1` | Ruta del archivo `.asm` rota | Verifica que `proyecto/src/productoPunto.asm` exista |
| **masm(.targets, .props)** no aparece en *Personalizaciones de compilación* | Falta la carga de trabajo *Desarrollo C++* | Abre **Visual Studio Installer**, pulsa **"Modificar"** y agrégala |
| `git` no se reconoce como comando | Git no se instaló o no se agregó al PATH | Reinstala Git marcando *"Git from the command line and also from 3rd-party software"* |
| El `.slnx` no abre | Versión de Visual Studio anterior a 2022 17.10 | Abre directamente `Practica05_ProductoPunto.vcxproj` |
| Errores de compilación en `main.cpp` | Archivos de encabezado de C++ faltantes | Verifica que la carga de trabajo *Desarrollo C++* esté completamente instalada |

---

> **Autor:** Edson Joel Carrera Avila
