#!/usr/bin/env bash
# =====================================================================
#  My Portfolio — PythonAnywhere uchun virtualenv ("env") tayyorlash
# =====================================================================
#  PythonAnywhere hujjatidagi 3 qadamni bajaradi:
#    1) virtualenv yaratish — web app bilan BIR XIL Python versiyasida
#    2) kerakli paketlarni o'rnatish (requirements.txt)
#    3) Web bo'limi uchun aniq qiymatlarni chop etish
#       (Virtualenv yo'li, Source code, WSGI config uchun namuna)
#
#  ISHLATISH (PythonAnywhere → Consoles → Bash):
#      cd ~/my-portfolio          # loyiha papkasi
#      bash scripts/pythonanywhere_setup.sh
#
#  Sozlash (kerak bo'lsa):
#      PYTHON_BIN=/usr/bin/python3.12 \
#      VENV_DIR=$HOME/.virtualenvs/portfolio \
#      PROJECT_DIR=$HOME/my-portfolio \
#      bash scripts/pythonanywhere_setup.sh
#
#  MUHIM: veb-ilovada tanlangan Python versiyasi bilan virtualenv
#  versiyasi bir xil bo'lishi kerak, aks holda paketlar mos kelmaydi.
#
#  Bu skript /var/www/ ichidagi WSGI faylga TEGMAYDI va bazani
#  o'zgartirmaydi (migrate qilmaydi) — faqat "env" ni tayyorlaydi.
# =====================================================================
set -euo pipefail

PYTHON_BIN="${PYTHON_BIN:-/usr/bin/python3.13}"
VENV_NAME="${VENV_NAME:-portfolio}"
VENV_DIR="${VENV_DIR:-$HOME/.virtualenvs/$VENV_NAME}"
PROJECT_DIR="${PROJECT_DIR:-}"

# --- 0. Loyiha papkasini topish ---------------------------------------
if [ -z "$PROJECT_DIR" ]; then
  for candidate in "$HOME/MY-portfolio" "$HOME/my-portfolio" "$HOME/ABDURAHMON_django" "$HOME/portfolio" "$(pwd)"; do
    if [ -f "$candidate/manage.py" ]; then
      PROJECT_DIR="$candidate"
      break
    fi
  done
fi

if [ -z "$PROJECT_DIR" ] || [ ! -f "$PROJECT_DIR/manage.py" ]; then
  echo "XATO: manage.py topilmadi." >&2
  echo "Skriptni loyiha papkasidan ishga tushiring yoki PROJECT_DIR=... bering." >&2
  exit 1
fi
cd "$PROJECT_DIR"
echo "Loyiha papkasi : $PROJECT_DIR"

# --- 1. Python versiyasi ----------------------------------------------
if [ ! -x "$PYTHON_BIN" ]; then
  echo "XATO: $PYTHON_BIN topilmadi. PythonAnywhere'da mavjud versiyalar:" >&2
  ls -1 /usr/bin/python3.* 2>/dev/null | grep -v -- '-config' >&2 || true
  echo "Web bo'limida tanlagan versiyangizni PYTHON_BIN=... orqali bering." >&2
  exit 1
fi
echo "Python versiyasi: $("$PYTHON_BIN" --version 2>&1) ($PYTHON_BIN)"

# --- 2. Virtualenv yaratish -------------------------------------------
if [ -x "$VENV_DIR/bin/python" ] || [ -x "$VENV_DIR/Scripts/python.exe" ]; then
  echo "Virtualenv allaqachon bor: $VENV_DIR (qayta yaratilmadi)"
else
  mkdir -p "$(dirname "$VENV_DIR")"
  "$PYTHON_BIN" -m venv "$VENV_DIR"
  echo "Virtualenv yaratildi: $VENV_DIR"
fi

# Linux'da bin/, Windows'da Scripts/ (skriptni lokal sinash uchun ham ishlaydi)
if [ -d "$VENV_DIR/bin" ]; then
  VENV_BIN="$VENV_DIR/bin"
else
  VENV_BIN="$VENV_DIR/Scripts"
fi
VENV_PY="$VENV_BIN/python"
[ -x "$VENV_PY" ] || VENV_PY="$VENV_BIN/python.exe"
VENV_PIP="$VENV_BIN/pip"
[ -x "$VENV_PIP" ] || VENV_PIP="$VENV_BIN/pip.exe"

if [ ! -x "$VENV_PY" ]; then
  echo "XATO: virtualenv ichida python topilmadi ($VENV_BIN)." >&2
  exit 1
fi
echo "Virtualenv python: $("$VENV_PY" --version 2>&1)"

# --- 3. Paketlarni o'rnatish ------------------------------------------
echo
echo "=== pip install -r requirements.txt ==="
"$VENV_PY" -m pip install --upgrade pip --quiet
"$VENV_PY" -m pip install -r requirements.txt

echo
echo "=== Virtualenv ichidagi asosiy paketlar ==="
"$VENV_PY" -m pip list --format=freeze | grep -Ei '^(django|asgiref|sqlparse|tzdata|pillow|python-dotenv)=' || true

# --- 4. Tekshirish -----------------------------------------------------
echo
echo "=== Django tekshiruvi (manage.py check) ==="
"$VENV_PY" manage.py check

if [ ! -f "$PROJECT_DIR/.env" ]; then
  echo
  echo "OGOHLANTIRISH: $PROJECT_DIR/.env topilmadi!"
  echo "  Serverda .env majburiy (SECRET_KEY, domen, email paroli)."
  echo "  Tayyor mazmun: loyihadagi .env.pythonanywhere fayli."
fi

# --- 5. Web bo'limi uchun qiymatlar -----------------------------------
cat <<EOF

=====================================================================
 Web bo'limiga (PythonAnywhere → Web) quyidagilarni kiriting
=====================================================================
  Source code        : $PROJECT_DIR
  Working directory  : $PROJECT_DIR
  Virtualenv         : $VENV_DIR
                       (virtualenvwrapper ishlatgan bo'lsangiz, shunchaki
                        nomini yozish ham mumkin: $VENV_NAME)

  DIQQAT! "Virtualenv" maydoniga \`.env\` yoki \`.env.pythonanywhere\`
  FAYLINING yo'lini yozmang — u yerga faqat virtualenv PAPKASI
  yoziladi. Aks holda PythonAnywhere "No virtualenv detected at this
  path" deb ogohlantiradi va paketlar tizimdan olinadi.

  Static files (ikki mapping):
    URL /static/  →  $PROJECT_DIR/staticfiles
    URL /media/   →  $PROJECT_DIR/media

  WSGI configuration file (/var/www/..._wsgi.py) ichidagi
  muhim qatorlar:

      import os, sys
      path = '$PROJECT_DIR'
      if path not in sys.path:
          sys.path.insert(0, path)
      os.environ['DJANGO_SETTINGS_MODULE'] = 'config.settings'
      from django.core.wsgi import get_wsgi_application
      application = get_wsgi_application()

=====================================================================
 Keyingi qadamlar (virtualenv ichida, loyiha papkasida)
=====================================================================
  source $VENV_BIN/activate
  python scripts/rename_app_in_db.py $PROJECT_DIR/db.sqlite3   # bir marta
  python manage.py migrate
  python manage.py collectstatic --noinput
  # keyin Web bo'limida "Reload" tugmasini bosing

  Python versiyasi: Web bo'limida tanlangan versiya bilan
  bir xil bo'lishi shart — $("$PYTHON_BIN" --version 2>&1)

  Bepul hisob eslatmasi: sayt o'chib qolmasligi uchun oyiga bir marta
  Web bo'limi tepasidagi "Run until 1 month from today" tugmasini
  bosib turing.
=====================================================================
EOF
