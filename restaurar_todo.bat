@echo off
set ADB=d:\3-Development\miAndroidTV\platform-tools\adb.exe
set TV_IP=192.168.1.17:5555

echo ========================================================
echo RESTAURANDO TU TELEVISOR AL ESTADO ORIGINAL DE FABRICA
echo ========================================================

%ADB% connect %TV_IP%

echo 1. Re-habilitando launcher stock y servicios oficiales...
%ADB% shell "pm enable com.google.android.tvlauncher"
%ADB% shell "cmd package set-home-activity --user 0 com.google.android.tvlauncher/.MainActivity"

echo 2. Re-habilitando todos los paquetes previamente deshabilitados...
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
    com.google.android.katniss
    com.google.android.apps.mediashell
    com.homwee.multiscreenshare
    com.homwee.mmp.screenshare
) do (
    echo Re-habilitando %%P ...
    %ADB% shell pm enable %%P
)

echo 3. Desinstalando CleanYourTV si esta presente...
%ADB% shell "pm uninstall com.gathin.tvhome"

echo 4. Abriendo pantalla de inicio oficial...
%ADB% shell "input keyevent KEYCODE_HOME"

echo.
echo ========================================================
echo RESTAURACION COMPLETADA AL 100%%
echo ========================================================
pause
