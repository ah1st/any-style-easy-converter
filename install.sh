#!/bin/bash

# التأكد من التحديث وتثبيت الحزم الأساسية
sudo apt update
sudo apt install -y python3-pip python3-venv ruby ruby-dev poppler-utils

# تثبيت Anystyle إذا لم يكن موجوداً
if ! command -v anystyle &> /dev/null; then
    echo "جاري تثبيت Anystyle..."
    sudo gem install anystyle anystyle-cli
else
    echo "Anystyle مثبت بالفعل."
fi

# إعداد البيئة الافتراضية
if [ ! -d "venv" ]; then
    echo "إنشاء بيئة افتراضية جديدة..."
    python3 -m venv venv
fi

# تثبيت المتطلبات داخل البيئة
# نقوم بالتثبيت مباشرة عبر المسار الكامل لـ pip داخل البيئة لتجنب التضارب
./venv/bin/pip install --upgrade pip
./venv/bin/pip install customtkinter

echo "تم إعداد كل شيء بنجاح."