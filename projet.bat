@echo off
chcp 65001 >nul
TITLE Lanceur Global - Moteur de Fusion Multimodale

:: Se placer directement dans le dossier du script pour utiliser des chemins relatifs propres
cd /d "%~dp0"

echo ========================================================
echo    DEMARRAGE DE L'ARCHITECTURE MULTIMODALE - IVY
echo ========================================================
echo.

:: 1. Verification ou Creation automatique du .venv
if exist ".venv\Scripts\python.exe" goto VENV_OK

echo [INFO] Premier lancement detecte : creation de l'environnement Python 3.12...
py -3.12 -m venv ".venv"
if errorlevel 1 (
    echo [ERREUR] Impossible de creer le venv avec Python 3.12.
    echo Verifiez que Python 3.12 est bien installe : winget install Python.Python.3.12
    pause
    exit /b
)

echo [INFO] Installation des dependances MediaPipe et Ivy...
if exist "requirement.txt" ".venv\Scripts\python.exe" -m pip install -r "requirement.txt"
if exist "requirements.txt" ".venv\Scripts\python.exe" -m pip install -r "requirements.txt"
echo [OK] Environnement Python pret !
echo.

:VENV_OK

:: 2. Lancement de la reconnaissance vocale SRA5
echo [1/5] Demarrage de SRA5...
start "SRA5" /D "sra5\sra5" "sra5.exe"
timeout /t 1 /nobreak >nul

:: 3. Lancement du script Camera
echo [2/5] Demarrage de la camera MediaPipe...
start "CameraGesture" ".venv\Scripts\python.exe" "camera_gesture.py"
timeout /t 1 /nobreak >nul

:: 4. Lancement de OneDollarIvy (Exécutable exporté)
echo [3/5] Demarrage de OneDollarIvy...
start "OneDollarIvy" /D "OneDollarIvy-main\OneDollarIvy-main\windows-amd64" "OneDollarIvy-main.exe"
timeout /t 1 /nobreak >nul

:: 5. Lancement de la Palette (Exécutable exporté)
echo [4/5] Demarrage de la Palette...
start "Palette" /D "Palette\Palette\windows-amd64" "Palette.exe"
timeout /t 1 /nobreak >nul

:: 6. Lancement de Fusion (Exécutable exporté)
echo [5/5] Demarrage du Dashboard Fusion...
start "Fusion" /D "fusion\windows-amd64" "fusion.exe"

echo.
echo ========================================================
echo    TOUS LES EXECUTABLES SONT LANCES !
echo ========================================================
pause