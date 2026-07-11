@echo off
title AnyStyle Converter Installer
echo Starting Installation and Launch...

:: 1. التحقق من وجود Python
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed. Please install Python first.
    pause
    exit /b
)

:: 2. إنشاء بيئة افتراضية (Virtual Environment)
if not exist venv (
    echo Creating virtual environment...
    python -m venv venv
    if %errorlevel% neq 0 goto error_handler
)

:: 3. تثبيت المتطلبات
echo Installing requirements...
call venv\Scripts\activate
pip install -r requirements.txt
if %errorlevel% neq 0 goto error_handler

:: 4. التحقق من وجود Ruby (ضروري لـ AnyStyle)
ruby --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Ruby is not installed. Please install Ruby and 'anystyle' gem.
    goto error_handler
)

:: 5. تشغيل البرنامج
echo Launching Application...
python anystyle-converter.py
if %errorlevel% neq 0 goto error_handler

echo Success!
pause
exit /b

:: معالجة الأخطاء
:error_handler
echo.
echo ===========================================
echo [ERROR] An error occurred during execution.
echo Please check the error message above.
echo ===========================================
pause
exit /b