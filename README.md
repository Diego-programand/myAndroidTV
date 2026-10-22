# 📺 myAndroidTV — Optimización Segura y Launcher Minimalista para Android TV

Repositorio de documentación, scripts y launcher personalizado para optimizar al máximo televisores con **Android TV / Google TV**, eliminando publicidad invasiva, telemetría y bloatware sin comprometer la estabilidad del sistema ni perder la garantía.

Inspirado en la filosofía y herramientas del proyecto [CleanYourTV](https://github.com/Gathin23/cleanyourtv).

---

## 📑 Tabla de Contenidos
1. [Diagnóstico e Información Rescatada del Televisor](#-diagnóstico-e-información-rescatada-del-televisor)
2. [Principios y Reglas de Oro de Seguridad](#-principios-y-reglas-de-oro-de-seguridad)
3. [¿Qué se hizo? (Optimizaciones Aplicadas)](#-qué-se-hizo-optimizaciones-aplicadas)
4. [¿Qué NO se debe hacer? (Componentes Críticos Protegidos)](#-qué-no-se-debe-hacer-componentes-críticos-protegidos)
5. [Estructura del Proyecto](#-estructura-del-proyecto)
6. [Guía de Uso Rápido](#-guía-de-uso-rápido)
7. [Reversión Total al Estado de Fábrica (1-Click)](#-reversión-total-al-estado-de-fábrica-1-click)

---

## 🔍 Diagnóstico e Información Rescatada del Televisor

Durante la auditoría remota vía ADB en la red local (`192.168.1.17:5555`), se extrajo el inventario completo de hardware, propiedades del sistema y configuraciones base (respaldadas en la carpeta [`backup/`](backup/)):

| Parámetro | Valor Registrado | Observaciones |
| :--- | :--- | :--- |
| **Fabricante** | `Changhong` | Plataforma base común en marcas como CHiQ, Caixun, Aiwa, RCA |
| **Modelo / Placa** | `AI PONT` | Arquitectura de placa MediaTek / MStar (familia samseong/deto) |
| **Versión de Android** | `Android 11 (Android TV)` | Nivel de API 30 |
| **Arquitectura de CPU** | `armeabi-v7a` | ARM de 32 bits |
| **Memoria RAM** | ~`1.3 GB` | Memoria limitada que sufría saturación por servicios en segundo plano |
| **Launcher Original de Fábrica** | `com.google.android.tvlauncher` | Cargado con filas de publicidad comercial y recomendaciones pesadas |
| **Capa de Software del Fabricante** | `Homwee` (`com.homwee.*`) | Servicios de tienda duplicada, portal de marca y auto-instaladores |
| **Sintonizador de TV / Live TV** | `com.mediatek.wwtv.tvcenter` | Manejador de canales de aire / TDT |
| **Estado Previo de Deshabilitación** | `0 paquetes` | El televisor conservaba el 100% de la carga publicitaria de fábrica |

---

## 🛡️ Principios y Reglas de Oro de Seguridad

1. **Deshabilitar (`pm disable-user --user 0`), NUNCA desinstalar (`pm uninstall`)**:
   - `pm uninstall` borra los archivos APK del sistema de la partición de sólo lectura; si una dependencia del sistema la requiere, el televisor puede sufrir un *bootloop* irrecuperable.
   - `pm disable-user --user 0` congela la app para el usuario principal, liberando el 100% de la memoria RAM y ciclos de CPU, pero manteniendo el APK intacto en la memoria ROM para poder restaurarse al instante con `pm enable`.
2. **Privacidad absoluta en la pantalla de inicio**:
   - El launcher compilado (`com.gathin.tvhome`) **NO solicita ni tiene el permiso `android.permission.INTERNET`**.
   - El sistema Android le prohíbe comunicarse con el exterior. No envía telemetría ni recopila datos de cuentas. Las aplicaciones de streaming (Netflix, Prime Video, Disney+, YouTube) sí mantienen su conexión a internet al 100%.
3. **Persistencia garantizada ante reinicios**:
   - Los comandos `pm disable-user`, las opciones del sistema en `settings` y el launcher por defecto se guardan en la base de datos persistente de Android (`package-restrictions.xml` y `settings_*.xml`), por lo que no se pierden al apagar la tele o desconectarla de la corriente.

---

## 🚀 ¿Qué se hizo? (Optimizaciones Aplicadas)

### 1. Deshabilitación de 16 Paquetes de Telemetría y Basura
Se liberaron recursos de CPU y memoria RAM congelando los siguientes procesos en segundo plano:

* **Publicidad y portales del fabricante**:
  - `com.homwee.aipont`: Portal de marca y recomendaciones comerciales de Changhong.
  - `com.homwee.store`: Tienda de apps duplicada del fabricante.
  - `com.homwee.help`: Aplicación de ayuda del fabricante.
  - `android.autoinstalls.config.homwee`: Instalador silencioso de apps asociadas.
  - `com.mstar.android.tv.disclaimercustomization`: Aviso legal y términos del chip al inicio.
* **Anuncios y servicios innecesarios de Google**:
  - `com.google.android.tvrecommendations`: Motor de filas de sugerencias comerciales en la pantalla de inicio.
  - `com.google.android.feedback`: Reportero de fallos y telemetría en segundo plano.
  - `com.google.android.play.games`: Servicio de Google Play Juegos.
  - `com.google.android.videos`: Google Play Películas / TV (obsoleto).
  - `com.google.android.backdrop`: Salvapantallas publicitario de Google.
  - `com.google.android.syncadapters.calendar`: Sincronización de calendario de Google.
* **Accesibilidad no utilizada (a solicitud del usuario)**:
  - `com.google.android.marvin.talkback`: Lector de pantalla en voz alta.
  - `com.google.android.tts`: Motor de síntesis de voz (Texto a Voz).
* **Música no requerida**:
  - `com.google.android.youtube.tvmusic`: YouTube Music para TV.
* **Asistentes de bienvenida residentes en RAM**:
  - `com.mediatek.wwtv.setupwizard`: Asistente de primera configuración de MediaTek.
  - `com.google.android.tungsten.setupwraith`: Asistente de bienvenida de Google (se verificó previamente que no fuera dueño de la red Wi-Fi para no perder conexión).
* **Launcher de fábrica sobrecargado**:
  - `com.google.android.tvlauncher`: Congelado tras configurar el nuevo launcher limpio.

### 2. Compilación e Instalación de CleanYourTV Launcher
* Compilado directamente en el entorno local con OpenJDK 17 y Android Build-Tools 34.
* Tamaño optimizado con R8: **393 KB** (frente a los más de 80 MB que pesa el launcher de fábrica).
* Precompilado en modo **AOT (Ahead-Of-Time / speed mode)** mediante `cmd package compile -m speed -f com.gathin.tvhome` para eliminar cualquier retraso al pulsar botones en el mando.

### 3. Organización Visual del Dock Personalizado
Se configuró el orden de las aplicaciones principales del dock en la fila inferior:
1. **Netflix** (`com.netflix.ninja`)
2. **Prime Video** (`com.amazon.amazonvideo.livingroom`)
3. **Disney+** (`com.disney.disneyplus`) — *Instalada oficialmente desde Google Play Store con soporte 4K/HDR*
4. **YouTube** (`com.google.android.youtube.tv`)

*La aplicación **MultiScreenShare** se trasladó de forma limpia a la segunda fila (cajón de aplicaciones deslizable con la flecha Abajo).*

### 4. Ajustes del Sistema Operativo
* **Reloj en formato 12 Horas con indicador AM/PM**: Configurado vía `settings put system time_12_24 12`.
* **Salvapantallas Minimalista (`ClockDream`)**: Activado como protector de pantalla predeterminado (`settings put secure screensaver_components com.gathin.tvhome/.ClockDream`) con algoritmo de protección anti-quemado de píxeles (*pixel drift*).
* **Animaciones del sistema aceleradas a 0.5x**: Se redujo a la mitad el tiempo de apertura y transiciones de ventanas (`window_animation_scale`, `transition_animation_scale`, `animator_duration_scale`).

---

## ⛔ ¿Qué NO se debe hacer? (Componentes Críticos Protegidos)

Durante la optimización es indispensable **NO TOCAR** los siguientes paquetes, descubiertos durante la auditoría:

> [!CAUTION]
> **NUNCA deshabilitar `com.google.android.leanbacklauncher.partnercustomizer`**  
> Aunque su nombre parece bloatware comercial, provee el proveedor de contenido `tvlauncher.widget`. Si se deshabilita, el servicio `com.mediatek.tv.service` entra en un bucle infinito de caídas (*crash-loop*) tras el siguiente reinicio, provocando que el selector de entradas HDMI y el botón de fuentes del control remoto dejen de responder por completo.

Otros componentes intocables:
- `com.homwee.synckey`: Servicio de sincronización de botones del mando a distancia.
- `com.homwee.chtvmanager`: Gestor de entradas de vídeo y canales del fabricante.
- `com.mediatek.wwtv.tvcenter`: Interfaz de sintonización de TV en vivo y entradas físicas.
- `com.google.android.inputmethod.latin`: Teclado en pantalla (Gboard). Sin él, es imposible escribir contraseñas de Wi-Fi o hacer búsquedas.
- `com.google.android.gms` / `gsf`: Google Play Services y Play Store.

### Funciones personales conservadas al 100%:
- **Chromecast Built-in** (`com.google.android.apps.mediashell`): Transmisión desde celular/tablet.
- **Asistente de Google / Búsqueda por Voz** (`com.google.android.katniss`): Micrófono del mando.
- **Duplicación de Pantalla** (`com.homwee.multiscreenshare`): Proyección de pantalla inalámbrica.
- **Control remoto móvil** (`com.google.android.tv.remote.service`): Manejo de la TV desde el celular.
- **Visor multimedia USB y Explorador de Archivos**: Conservados para reproducción local.

---

## 📁 Estructura del Proyecto

```text
miAndroidTV/
├── backup/                        # Respaldo original del televisor
│   ├── getprop.txt               # Propiedades del sistema y modelo
│   ├── packages_all.txt          # Inventario completo de paquetes
│   ├── settings_global.txt       # Ajustes globales de Android
│   ├── settings_secure.txt       # Ajustes de seguridad
│   └── settings_system.txt       # Ajustes del sistema
├── release/                       # Binarios compilados listos para instalar
│   └── CleanYourTV_Custom_v2.4.apk  # Launcher compilado (393 KB, 0 internet)
├── repo/                          # Código fuente completo de CleanYourTV
│   ├── launcher/                 # Proyecto Android Studio / Gradle del launcher
│   └── tools/                    # Herramientas de diagnóstico y scripts Python
├── aplicar_optimizaciones.bat     # Script automático para aplicar todo en 1 clic
├── restaurar_todo.bat             # Script de restauración de fábrica en 1 clic
├── restaurar_todo.ps1             # Versión PowerShell del script de restauración
├── tv_screen.png                  # Captura de pantalla de diagnóstico
└── README.md                      # Esta documentación técnica
```

---

## 🛠️ Guía de Uso Rápido

### Requisitos Previos:
1. Tu computador y la TV deben estar conectados a la **misma red Wi-Fi**.
2. En la TV: ve a **Ajustes** $\rightarrow$ **Sistema / Preferencias** $\rightarrow$ **Información** $\rightarrow$ pulsa **7 veces** sobre **Compilación** hasta activar el modo desarrollador.
3. Entra en **Opciones de desarrollador** y activa **Depuración por USB**.

### Aplicar las optimizaciones:
Ejecuta el script interactivo con doble clic:
```cmd
aplicar_optimizaciones.bat
```
El script te pedirá la IP de la TV (por defecto `192.168.1.17`), deshabilitará los 16 paquetes prescindibles, instalará el launcher limpio, fijará el dock y configurará el reloj y animaciones automáticamente.

---

## 🔄 Reversión Total al Estado de Fábrica (1-Click)

Si en algún momento deseas regresar la televisión exactamente a su estado de fábrica original:
1. Haz doble clic en [`restaurar_todo.bat`](restaurar_todo.bat).
2. El script se conectará por ADB, re-habilitará todos los 16 paquetes congelados, re-activará el launcher oficial de Google TV, desinstalará CleanYourTV y dejará la TV exactamente como vino de la tienda.

---

## 🔒 Cierre de Seguridad Recomendado
Una vez aplicadas las modificaciones en la TV:
1. Ve a **Ajustes $\rightarrow$ Opciones de desarrollador**.
2. **Desactiva la Depuración por USB**.

*El puerto ADB (5555) quedará cerrado, blindando el televisor contra accesos no autorizados en tu red local.*
