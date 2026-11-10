@echo off
chcp 65001 >nul
setlocal EnableExtensions
echo Encerrando HealthCare nas portas 3001 e 5173...

for %%P in (3001 5173) do (
  for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%%P" ^| findstr LISTENING') do (
    echo Matando PID %%a (porta %%P)
    taskkill /F /PID %%a >nul 2>&1
  )
)

echo Pronto.
timeout /t 2 >nul
