@echo off
chcp 65001 >nul
setlocal EnableExtensions
cd /d "%~dp0"

echo ========================================
echo   HealthCare - Triagem Hospitalar
echo ========================================
echo.

where node >nul 2>&1
if errorlevel 1 (
  echo [ERRO] Node.js nao encontrado.
  echo Instale o Node.js 20 ou superior em https://nodejs.org
  echo Depois feche e abra este INICIAR.bat de novo.
  pause
  exit /b 1
)

for /f "tokens=*" %%v in ('node -v') do set NODEVER=%%v
echo Node encontrado: %NODEVER%
echo.

if not exist ".env" (
  echo Criando .env a partir do exemplo...
  copy /Y ".env.example" ".env" >nul
)
if not exist "server\.env" (
  (
    echo PORT=3001
    echo DATABASE_URL="file:./dev.db"
    echo APP_API_TOKEN=
  ) > "server\.env"
)
if not exist "client\.env" (
  (
    echo VITE_API_URL=http://localhost:3001/api
    echo VITE_API_TOKEN=
  ) > "client\.env"
)

if not exist "node_modules\" (
  echo Primeira execucao: instalando dependencias...
  echo Isso pode demorar alguns minutos.
  call npm.cmd install
  if errorlevel 1 (
    echo [ERRO] npm install falhou.
    pause
    exit /b 1
  )
  echo.
)

echo Preparando banco SQLite...
call npm.cmd run db:push
if errorlevel 1 (
  echo [ERRO] Falha ao preparar o banco.
  pause
  exit /b 1
)
echo.

echo Subindo API (3001) e front (5173)...
echo Nao feche esta janela enquanto estiver usando.
echo Para parar, use PARAR.bat ou Ctrl+C aqui.
echo.
start "" "http://localhost:5173/"
call npm.cmd run dev
pause
