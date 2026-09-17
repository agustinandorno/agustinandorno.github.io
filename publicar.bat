@echo off

cd /d "C:\Users\Agus_\Documents\GitHub\agustinandorno.github.io"

echo.
echo ================================
echo PUBLICANDO SITIO WEB
echo ================================
echo.

git add .

git diff --cached --quiet
if %errorlevel%==0 (
    echo No hay cambios nuevos para publicar.
    pause
    exit /b
)

set /p mensaje="Nombre del cambio: "

if "%mensaje%"=="" set mensaje=Update website

git commit -m "%mensaje%"

git push origin main

echo.
echo ================================
echo SITIO PUBLICADO
echo ================================
echo.

pause