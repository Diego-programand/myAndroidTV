@echo off
setlocal enabledelayedexpansion

set ADB=platform-tools\adb.exe
if not exist "%ADB%" (
    set ADB=adb.exe
)

set /p TV_IP="Ingresa la IP de tu Android TV (ejemplo: 192.168.1.17): "
if "%TV_IP%"=="" set TV_IP=192.168.1.17

echo ========================================================
echo   OPTIMIZANDO ANDROID TV VIA ADB (MODO 100%% SEGURO)
echo   IP Destino: %TV_IP%:5555
echo ========================================================

%ADB% connect %TV_IP%:5555

echo.
echo [1/5] Deshabilitando telemetria, anuncios y bloatware innecesario...
for %%P in (
    com.homwee.aipont
    com.google.android.tvrecommendations
    android.autoinstalls.config.homwee
    com.homwee.store
    com.homwee.help
    com.google.android.feedback
    com.google.android.play.games
    com.google.android.youtube.tvmusic
    com.google.android.videos
    com.google.android.backdrop
    com.google.android.syncadapters.calendar
    com.google.android.marvin.talkback
    com.google.android.tts
    com.mstar.android.tv.disclaimercustomization
    com.mediatek.wwtv.setupwizard
    com.google.android.tungsten.setupwraith
) do (
    echo   - Deshabilitando %%P
    %ADB% shell pm disable-user --user 0 %%P >nul 2>&1
)

echo.
echo [2/5] Instalando CleanYourTV Launcher compilado a medida...
if exist "release\CleanYourTV_Custom_v2.4.apk" (
    %ADB% install -r release\CleanYourTV_Custom_v2.4.apk
    %ADB% shell "cmd package set-home-activity --user 0 com.gathin.tvhome/.MainActivity"
    %ADB% shell "pm disable-user --user 0 com.google.android.tvlauncher"
    %ADB% shell "cmd package compile -m speed -f com.gathin.tvhome" >nul 2>&1
) else (
    echo   [AVISO] No se encontro el APK en release\, se mantiene el launcher actual.
)

echo.
echo [3/5] Configurando reloj en formato 12 Horas (AM/PM)...
%ADB% shell "settings put system time_12_24 12"

echo.
echo [4/5] Activando salvapantallas minimalista ClockDream...
%ADB% shell "settings put secure screensaver_components com.gathin.tvhome/.ClockDream"
%ADB% shell "settings put secure screensaver_enabled 1"
%ADB% shell "settings put secure screensaver_activate_on_sleep 1"

echo.
echo [5/5] Acelerando animaciones del sistema a 0.5x...
%ADB% shell "settings put global window_animation_scale 0.5"
%ADB% shell "settings put global transition_animation_scale 0.5"
%ADB% shell "settings put global animator_duration_scale 0.5"

echo.
echo Presionando boton Home para iniciar...
%ADB% shell "input keyevent KEYCODE_HOME"

echo ========================================================
echo   OPTIMIZACION COMPLETADA CON EXITO
echo ========================================================
echo Recuerda desactivar la Depuracion USB en los Ajustes de Desarrollador de tu TV.
pause
