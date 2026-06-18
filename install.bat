@echo off
setlocal enabledelayedexpansion

echo ========================================
echo  Checking dependencies and setup
echo ========================================

:: 0. Check Node.js version (should be v26.1.0)
echo [0] Checking Node.js version...
for /f "tokens=*" %%i in ('node -v 2^>nul') do set NODE_VERSION=%%i
if "%NODE_VERSION%"=="" (
    echo Node.js is not installed or not in PATH.
    echo Please install Node.js v26.1.0 from:
    echo https://nodejs.org/dist/v26.1.0/node-v26.1.0-x64.msi
    pause
    exit /b 1
)
echo Detected version: %NODE_VERSION%
if not "%NODE_VERSION%"=="v26.1.0" (
    echo ERROR: Expected Node.js version v26.1.0, but found %NODE_VERSION%.
    echo Please reinstall Node.js v26.1.0. Download from:
    echo https://nodejs.org/dist/v26.1.0/node-v26.1.0-x64.msi
    pause
    exit /b 1
)
echo Node.js version is correct (v26.1.0).

:: 1. Check node_modules and prompt for deletion
if exist node_modules (
    echo [1] WARNING: node_modules folder already exists.
    echo To reinstall all modules, the existing node_modules should be removed.
    set /p DELETE_NM="Delete node_modules and proceed? (Y/N): "
    if /i "!DELETE_NM!"=="Y" (
        echo Deleting node_modules...
        rmdir /s /q node_modules
        if errorlevel 1 (
            echo Failed to delete node_modules. It might be in use.
            pause
            exit /b 1
        )
        echo node_modules successfully removed.
    ) else (
        echo Skipping deletion. The script will continue with existing node_modules.
        echo However, it is recommended to delete it if you experience issues.
    )
) else (
    echo [1] node_modules folder not found. Good to go.
)

:: 2. Run npm install
echo [2] Running npm install...
call npm install
if errorlevel 1 (
    echo npm install failed.
    pause
    exit /b 1
)
echo npm install completed successfully.

echo ========================================
echo All done! Dependencies are ready.
echo ========================================
pause