$adb = "d:\3-Development\miAndroidTV\platform-tools\adb.exe"
$tvIp = "192.168.1.17:5555"

Write-Host "Conectando con la TV en $tvIp ..." -ForegroundColor Cyan
& $adb connect $tvIp

$packages = @(
    "com.homwee.aipont",
    "com.google.android.tvrecommendations",
    "android.autoinstalls.config.homwee",
    "com.homwee.store",
    "com.homwee.help",
    "com.google.android.feedback",
    "com.google.android.play.games",
    "com.google.android.youtube.tvmusic",
    "com.google.android.videos",
    "com.google.android.backdrop",
    "com.google.android.syncadapters.calendar",
    "com.google.android.katniss",
    "com.google.android.apps.mediashell",
    "com.homwee.multiscreenshare",
    "com.homwee.mmp.screenshare"
)

foreach ($pkg in $packages) {
    Write-Host "Habilitando $pkg ..." -ForegroundColor Yellow
    & $adb shell "pm enable $pkg"
}

Write-Host "¡Restauración completada con éxito!" -ForegroundColor Green
