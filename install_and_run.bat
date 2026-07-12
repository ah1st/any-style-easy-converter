@echo off
title AnyStyle Converter - Setup
echo Checking requirements...

:: 1. التحقق من وجود Python وتثبيته إذا لزم الأمر
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found. Installing Python via winget...
    winget install Python.Python.3.12 --silent
    echo Please restart this script after installation completes.
    pause & exit /b
)

:: 2. التحقق من وجود Ruby وتثبيته إذا لزم الأمر
ruby --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Ruby not found. Installing Ruby via winget...
    winget install RubyInstallerTeam.Ruby.3.3 --silent
    echo Please restart this script after installation completes.
    pause & exit /b
)

:: 3. تثبيت مكتبة Anystyle المطلوبة
echo Checking Anystyle...
call gem install anystyle anystyle-cli --no-document

:: 4. إعداد البيئة الافتراضية وتثبيت مكتبات بايثون
if not exist venv (
    echo Creating virtual environment...
    python -m venv venv
)
call venv\Scripts\activate
echo Installing Python requirements...
pip install -r requirements.txt

:: 5. التشغيل
echo Launching Application...
python anystyle-converter.py
pause
