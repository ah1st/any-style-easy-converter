#!/bin/bash

# 1. التأكد من وجود البيئة الافتراضية، وإلا قم بإنشائها
if [ ! -d "venv" ]; then
    echo "إعداد البيئة الافتراضية لأول مرة..."
    python3 -m venv venv
fi

# 2. تفعيل البيئة وتثبيت المكتبات المطلوبة
source venv/bin/activate
pip install --upgrade pip --quiet
pip install arabic-reshaper python-bidi --quiet

# 3. التأكد من تثبيت مكتبة anystyle (Ruby Gem)
if ! gem list -i anystyle > /dev/null; then
    echo "جاري تثبيت أداة AnyStyle..."
    gem install anystyle --user-install --quiet
fi

# 4. تشغيل البرنامج
echo "تشغيل البرنامج..."
python3 any-style-converter.py
