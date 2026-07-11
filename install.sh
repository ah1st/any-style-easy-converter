#!/bin/bash

# 1. التأكد من التحديث وتثبيت الحزم الأساسية
sudo apt update
sudo apt install -y python3-venv ruby-full ruby-dev poppler-utils

# 2. تثبيت Anystyle
if ! command -v anystyle &> /dev/null; then
    echo "جاري تثبيت Anystyle..."
    sudo gem install anystyle anystyle-cli
else
    echo "Anystyle مثبت بالفعل."
fi

# 3. إعداد البيئة الافتراضية
if [ ! -d "venv" ]; then
    echo "إنشاء بيئة افتراضية جديدة..."
    python3 -m venv venv
fi

# 4. تثبيت المتطلبات المحددة في ملف requirements.txt
echo "جاري تثبيت المكتبات المطلوبة..."
./venv/bin/pip install --upgrade pip
./venv/bin/pip install -r requirements.txt

# 5. إنشاء ملف التشغيل المكتبي (anystyle.desktop) تلقائياً ليناسب جهاز المستخدم
echo "[Desktop Entry]
Name=AnyStyle Converter
Comment=Bibliographic Reference Converter
Exec=$PWD/run.sh
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=Utility;Education;" > anystyle.desktop

# 6. إضافة التطبيق لقائمة تطبيقات Ubuntu
chmod +x anystyle.desktop
mkdir -p ~/.local/share/applications/
cp anystyle.desktop ~/.local/share/applications/

echo "=========================================================="
echo "تم إعداد كل شيء بنجاح!"
echo "يمكنك الآن العثور على البرنامج في قائمة تطبيقات أوبنتو."
echo "=========================================================="
