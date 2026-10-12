# My Portfolio

Abdurahmon Kenjaboyevning shaxsiy portfoliosi — Django asosida qurilgan sayt.
Saytda yutuqlar, HTML o'yinlar, o'zim haqimda va aloqa bo'limlari bor.

**Aloqa:** [abdurahmonk1987@gmail.com](mailto:abdurahmonk1987@gmail.com) · [+998 99 660 52 48](tel:+998996605248) · [@ABDURAHMON_KENJABOYEV](https://t.me/ABDURAHMON_KENJABOYEV) · [github.com/Abdurahmon1006](https://github.com/Abdurahmon1006)

**Manzil:** Toshkent shahar, Yashnobod tumani, Marifat MFY, Murg'ob ko'chasi, 10-uy

## Bo'limlar (sahifalar)

| Manzil | Nomi | Tavsif |
| --- | --- | --- |
| `/` | Asosiy | Kirish sahifasi, ism va kasb animatsiyasi |
| `/works/` | Yutuqlar | Yutuqlar ro'yxati (admin orqali qo'shiladi) |
| `/games/` | O'yinlar | HTML o'yinlar ro'yxati (admin orqali qo'shiladi) |
| `/about/` | Men haqimda | Shaxsiy ma'lumotlar |
| `/contact/` | Aloqa | Xabar yuborish formasi (xabar abdurahmonk1987@gmail.com ga keladi) |
| `/components/` | Components | Dizayn komponentlar namunasi |
| `/admin/` | Admin panel | Yutuq va o'yinlarni boshqarish |
| `/game/<id>/` | O'yin sahifasi | Bitta o'yin tafsiloti |
| `/yutuq/<id>/` | Yutuq sahifasi | Bitta yutuq tafsiloti |

## Papkalar tuzilishi

```
my-portfolio/
├── config/                 # Loyiha sozlamalari (settings, urls, wsgi, asgi)
├── portfolio/              # Asosiy ilova: models, views, urls, admin, forms
│   ├── migrations/         # Baza migratsiyalari
│   └── management/commands/
│       └── load_games.py   # O'yinlarni game_sources/ dan bazaga yuklaydi
├── templates/              # HTML shablonlari (base.html + sahifalar)
├── static/                 # CSS, JS, rasmlar (main.*.css, main.*.js)
│   └── oyinlar/            # load_games ko'chirib qo'yadigan o'yinlar
├── media/                  # Admin panel orqali yuklangan rasmlar
├── game_sources/           # O'yinlarning asl (manba) fayllari
├── scripts/                # Yordamchi skriptlar
│   ├── rename_app_in_db.py         # bazadagi ilova nomini portfolio ga o'tkazadi
│   └── pythonanywhere_setup.sh     # server uchun virtualenv ("env") tayyorlaydi
├── staticfiles/            # collectstatic natijasi (gitga qo'shilmaydi)
├── db.sqlite3              # Baza fayli
├── manage.py
├── requirements.txt
├── .env / .env.example     # Maxfiy sozlamalar (haqiqiy .env gitga qo'shilmaydi)
├── .env.pythonanywhere     # Server uchun tayyor .env (gitga qo'shilmaydi)
└── .gitignore
```

## O'rnatish (lokal kompyuterda)

```bash
# 1. Virtualenv va kerakli kutubxonalar
python -m venv .venv
source .venv/bin/activate      # Windows: .venv\Scripts\activate
pip install -r requirements.txt

# 2. Maxfiy sozlamalar faylini yaratish
cp .env.example .env        # Windows: copy .env.example .env
#    keyin .env ichidagi qiymatlarni to'ldiring
#    (SECRET_KEY, email manzil va parol)

# 3. Bazani tayyorlash
python manage.py migrate

# 4. Serverni ishga tushirish
python manage.py runserver
#    Sayt: http://127.0.0.1:8000/
```

Admin panel uchun foydalanuvchi (agar hali yaratilmagan bo'lsa):

```bash
python manage.py createsuperuser
```

## Muhim: bir martalik baza yangilanishi

`apps` ilovasi `portfolio` deb qayta nomlangani uchun eski bazada (masalan
PythonAnywhere'dagi `db.sqlite3`) ilova nomi hali ham `apps` bo'lishi mumkin.
Bunday bazada sayt ishlamaydi — jadval topilmaydi. Buni bir marta tuzatish uchun:

```bash
python scripts/rename_app_in_db.py            # db.sqlite3 avtomatik topiladi
python scripts/rename_app_in_db.py /home/user/site/db.sqlite3   # aniq fayl uchun
```

Skript zaxira nusxa (`db.sqlite3.bak`) oladi va kerakli jadvallar hamda
yozuvlarni yangilaydi. Ishga tushirgandan so'ng sayt avvalgidek ishlaydi.

## O'yin qo'shish

```bash
# 1. game_sources/ ichida yangi papka oching va ichiga o'yin fayllarini soling:
#    game_sources/mening_oyinim/  → index.html, rasmi.png, name.txt
#    name.txt ichiga o'yin nomini yozing
# 2. O'yinlarni saytga yuklang:
python manage.py load_games            # yangi o'yinlar
python manage.py load_games --update   # mavjudlarini ham yangilash
```

`load_games` o'yinni `static/oyinlar/` ichiga ko'chiradi va bazaga yozadi.

## Serverga joylash (PythonAnywhere)

### 1. Maxfiy sozlamalar (`.env`)

Serverda `.env` fayli **majburiy**: `SECRET_KEY`, domen va email paroli
shundan o'qiladi. Tayyor namuna loyihada: **`.env.pythonanywhere`**
(gitga qo'shilmaydi, chunki ichida maxfiy qiymatlar bor).

1. PythonAnywhere → **Files** → loyiha papkasi (masalan
   `/home/Abdurahmon1006/MY-portfolio/`) → **New file** → nomi: `.env`
2. `.env.pythonanywhere` mazmunini shu faylga nusxalab qo'ying.
3. `EMAIL_HOST_PASSWORD` ni Gmail'dagi **yangi** App Password bilan
   almashtiring (eski parol GitHub tarixida oshkor bo'lgan).

`.env` ichidagi asosiy qatorlar:

| O'zgaruvchi | Serverdagi qiymat |
| --- | --- |
| `DJANGO_SECRET_KEY` | yangi generatsiya qilingan kalit |
| `DJANGO_DEBUG` | `False` |
| `DJANGO_ALLOWED_HOSTS` | `Abdurahmon1006.pythonanywhere.com` |
| `DJANGO_CSRF_TRUSTED_ORIGINS` | `https://Abdurahmon1006.pythonanywhere.com` |
| `EMAIL_HOST_USER` / `EMAIL_HOST_PASSWORD` | Gmail manzil + App Password |

Eslatma: PythonAnywhere'ning **bepul** hisobida tashqi SMTP yopiq, ammo
Gmail SMTP ruxsat etilgan — shuning uchun `smtp.gmail.com:587` ishlaydi.

### 2. Virtualenv ("env") va paketlar

Veb-ilova uchun tanlangan Python versiyasi bilan virtualenv versiyasi
**bir xil** bo'lishi shart. Hujjatdagi 3 qadamni bitta skript bajaradi:

```bash
cd ~/MY-portfolio
bash scripts/pythonanywhere_setup.sh
# boshqa Python versiyasi kerak bo'lsa:
# PYTHON_BIN=/usr/bin/python3.12 bash scripts/pythonanywhere_setup.sh
```

Skript `~/.virtualenvs/portfolio` da virtualenv yaratadi, `requirements.txt`
ni o'rnatadi, `manage.py check` ni ishga tushiradi va Web bo'limiga
kiritiladigan qiymatlarni (Source code, Virtualenv yo'li, statik mappinglar,
WSGI qatorlari) chop etadi. Papka noto'g'ri bo'lsa (masalan uy papkasi `~`),
skript buni darhol aytib to'xtaydi.

Migratsiya va statik fayllarni ham skript o'zi — **to'g'ri papkada** —
bajarib bersin desangiz:

```bash
cd ~/MY-portfolio
RENAME_DB=1 RUN_DJANGO=1 bash scripts/pythonanywhere_setup.sh
```

Hujjatdagi usulda qo'lda ham mumkin:

```bash
mkvirtualenv portfolio --python=/usr/bin/python3.13
workon portfolio
pip install -r requirements.txt
```

### 3. Baza va statik fayllar

```bash
cd /home/Abdurahmon1006/MY-portfolio   # AVVAL loyiha papkasiga o'ting!
git pull
python scripts/rename_app_in_db.py /home/Abdurahmon1006/MY-portfolio/db.sqlite3   # faqat birinchi marta
python manage.py migrate
python manage.py collectstatic --noinput
```

### 4. Web bo'limi

- **Web → Reload** tugmasini bosing.
- **Virtualenv**: `/home/Abdurahmon1006/.virtualenvs/portfolio`
  (yoki shunchaki nomi: `portfolio`).
- **Source code / Working directory**: `/home/Abdurahmon1006/MY-portfolio`.
- **Static files** bo'limida ikki mapping qo'shing:
  `/static/` → `/home/Abdurahmon1006/MY-portfolio/staticfiles`
  `/media/` → `/home/Abdurahmon1006/MY-portfolio/media`
  (`DEBUG=False` bo'lganda Django statik fayllarni o'zi bermaydi.)
- **WSGI config** faylida loyiha yo'li `sys.path` ga qo'shilganini tekshiring:
  `path = '/home/Abdurahmon1006/MY-portfolio'`.

### Ko'p uchraydigan xatolar

| Xato | Sabab | Yechim |
| --- | --- | --- |
| `fatal: not a git repository` | buyruq uy papkasida (`~`) bajarilgan | `cd /home/Abdurahmon1006/MY-portfolio` |
| `ModuleNotFoundError: No module named 'config'` | uy papkasidagi eski `manage.py` nusxasi ishga tushgan (uyda `config/` yo'q) | avval `cd` loyiha papkasiga; uydagi nusxani solishtirib (`diff ~/manage.py ~/MY-portfolio/manage.py`) kerak bo'lsa chetga oling: `mv ~/manage.py ~/manage.py.eski` |
| `ERROR: Could not open requirements file: 'requirements.txt'` | noto'g'ri papka | `cd` loyiha papkasiga |
| `KeyError: 'collectstatic'` | sozlamalar yuklanmadi (yuqoridagi sabab) | o'sha — `cd` |
| `Warning: No virtualenv detected at this path` | **Virtualenv** maydoniga `.env` faylining yo'li yozilgan | u yerga papka yo'lini yozing: `/home/Abdurahmon1006/.virtualenvs/portfolio` |

`manage.py` buyruqlari **faqat** loyiha papkasida ishlaydi: papka ichida
`manage.py`, `requirements.txt` va `config/settings.py` birga turishi shart.

### Sayt 500 xato bersa

1. **Web → Error log** ni ochib, birinchi xatoni o'qing.
2. Ko'p uchraydigan sabab — eski bazada ilova nomi hali `apps`:
   `python scripts/rename_app_in_db.py <db yo'li>` ni bir marta ishga tushiring.
3. `.env` fayli aynan shu nom bilan loyiha papkasida turganini tekshiring
   (nusxa `.env.txt` bo'lib qolsa o'qilmaydi).
4. Web bo'limida **Reload** qiling.

## Xavfsizlik

- `SECRET_KEY` va email paroli endi kodda emas, `.env` faylida saqlanadi.
- Eski `SECRET_KEY` va Gmail paroli GitHub tarixida qolgan. Ularni
  **almashtirish tavsiya etiladi**: Gmail hisobida App Password'ni o'chirib,
  yangisini `.env` ga yozing.
- `.env`, `.env.pythonanywhere`, `staticfiles/` va `temp_images/` gitga qo'shilmaydi.

## Texnologiyalar

Django 5.2, SQLite, Bootstrap 3, Mashup Template (Orson.io), Font Awesome.
