@echo off
title Run Bytecode Bundle

:: Путь к файлу settings.json
set SETTINGS_FILE=settings.json
set CLIENT_PORT=5173

:: Проверяем существует ли файл settings.json
if exist "%SETTINGS_FILE%" (
    :: Читаем порт из JSON файла с помощью PowerShell
    for /f "usebackq tokens=*" %%a in (`powershell -Command "try { $json = Get-Content '%SETTINGS_FILE%' | ConvertFrom-Json; if ($json.CLIENT_PORT) { Write-Output $json.CLIENT_PORT } else { Write-Output '5173' } } catch { Write-Output '5173' }"`) do (
        set CLIENT_PORT=%%a
    )
)
start http://localhost:%CLIENT_PORT%
:: Запускаем сервер и клиент
npx concurrently "npx bytenode server.jsc" "npx serve -s client -l %CLIENT_PORT%"

:: После запуска открываем браузер
if %errorlevel% equ 0 (
    timeout /t 2 /nobreak >nul
) else (
    echo An error occurred while running the script.
)

pause