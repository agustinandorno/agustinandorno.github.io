@echo off

cd /d "%~dp0"

echo.
echo =========================================
echo    AGREGAR NUEVO PROYECTO
echo =========================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0agregar_proyecto.ps1"

echo.
pause