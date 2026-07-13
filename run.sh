#!/bin/bash
# إيقاف السكريبت في حال حدوث خطأ حرج
set -e 

echo "=== بدء الإعداد الشامل لبيئة العمل ==="

# 1. إعداد مسارات Ruby بشكل صريح لتجنب مشاكل PATH نهائياً
export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
export PATH="$GEM_HOME/bin:$PATH"

# 2. تثبيت أداة AnyStyle وملحقاتها (إن لم تكن موجودة)
echo ">> [1/4] فحص وتجهيز أداة AnyStyle (Ruby)..."
if ! command -v anystyle &> /dev/null; then
    echo "جاري تثبيت حزم anystyle و anystyle-cli..."
    gem install anystyle anystyle-cli --user-install --quiet --no-document
else
    echo "أداة AnyStyle جاهزة."
fi

# التقاط المسار الدقيق وتصديره لبايثون
ANYSTYLE_EXACT_PATH=$(which anystyle)
export ANYSTYLE_EXACT_PATH
echo "تم تحديد مسار الأداة: $ANYSTYLE_EXACT_PATH"

# 3. إعداد بيئة بايثون الافتراضية
echo ">> [2/4] إعداد البيئة الافتراضية لبايثون (venv)..."
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate

# 4. تثبيت مكتبات بايثون المطلوبة
echo ">> [3/4] تثبيت مكتبات الواجهة الرسومية..."
pip install --upgrade pip --quiet
pip install customtkinter arabic-reshaper python-bidi --quiet

# 5. تشغيل البرنامج
echo ">> [4/4] جاري تشغيل الواجهة..."
python3 anystyle-converter.py
