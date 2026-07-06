# Godot Engine - Prueba Técnica

Este proyecto es una prueba técnica desarrollada en **Godot Engine 4** donde se implementan mecánicas fundamentales de un juego de acción top-down, priorizando la arquitectura limpia, la modularidad y el cumplimiento estricto de las buenas prácticas de desarrollo en **GDScript**.

---

## 🛠️ Características Técnicas del Proyecto

El desarrollo se enfocó en crear componentes reutilizables y un flujo de control robusto para las entidades del juego.

### 🧠 Arquitectura y Patrones de Diseño
* **Moveset del Player:** Configuración de controles, aceleraciones y animaciones fluidas para el movimiento del personaje principal.
* **Máquina de Estados Finita (FSM) para el Player:** Implementación de un patrón de diseño *State* para desacoplar la lógica de los diferentes estados del jugador (Idle, Run, Jump, Fall, Attack, Hurt, etc.), facilitando la escalabilidad y el mantenimiento de las mecánicas.
* **Comportamiento de Enemigos con LimboAI:** Utilización de herramientas avanzadas mediante la extensión **LimboAI** para lograr una IA enemiga con comportamiento inteligente, estructurado y eficiente.
* **Diseño Basado en Componentes:** Uso de nodos especializados e independientes para desacoplar la lógica de combate y salud:
	* `Hitbox`: Componente encargado de delimitar el área y emitir el daño.
	* `Hurtbox`: Componente encargado de recibir y detectar los impactos.
	* `Health`: Componente que gestiona de manera aislada los puntos de vida, el daño recibido y la muerte de la entidad.

### 🎨 Escenario y Estilo
* **Tilemaps:** Estructuración del entorno utilizando el sistema nativo de capas, colisiones y navegación de Godot para un diseño de niveles óptimo.
* **Guía de Estilo y Buenas Prácticas:** Todo el código fuente en GDScript fue escrito respetando rigurosamente la **guía de estilo oficial de Godot** (naming conventions, uso correcto de static typing, orden de variables `@onready` y consistencia en el formateo).

---

## 🚀 Instrucciones para Ejecutar en Local

Para clonar este proyecto y probarlo en tu máquina, sigue estos pasos:

### Prerrequisitos
* Tener instalado **Godot Engine** (se recomienda la versión 4.x estable).
* Si el proyecto incluye la extensión de LimboAI dentro de la carpeta `addons/`, se activará automáticamente al importar. En caso contrario, asegúrate de tener el plugin instalado o la versión del editor correspondiente.

### Pasos de Instalación

1. **Clonar el repositorio:**
   Abre tu terminal favorita y ejecuta el siguiente comando:
   ```bash
   git clone https://github.com/matiturock/mini-tecnica
   ```

2. **Importar el proyecto en Godot:**
   * Abre el **Godot Project Manager**.
   * Haz clic en el botón **Importar** (Import).
   * Navega hasta la carpeta donde clonaste el repositorio y selecciona el archivo `project.godot`.
   * Haz clic en **Importar y Editar** (Import & Edit).

3. **Activar Plugins (Si es necesario):**
   * Ve a `Proyecto` -> `Configuración del Proyecto` -> pestaña `Plugins`.
   * Asegúrate de que **LimboAI** esté marcado como `Activo`.

4. **Ejecutar el juego:**
   * Presiona **F5** (o el botón de *Play* en la esquina superior derecha del editor) para iniciar la escena principal.

---

## ⌨️ Controles por Defecto
* **Movimiento:** Flechas del teclado o teclas `W`, `A`, `S`, `D`.
* **Atacar:** Barra Espaciadora.
* **Interactuar:** `E` (a futuro).
