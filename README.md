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
├── staticfiles/            # collectstatic natijasi (gitga qo'shilmaydi)
├── db.sqlite3              # Baza fayli
├── manage.py
├── requirements.txt
├── .env / .env.example     # Maxfiy sozlamalar (haqiqiy .env gitga qo'shilmaydi)
└── .gitignore
```

## O'rnatish (lokal kompyuterda)

```bash
# 1. Kerakli kutubxonalar
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

```bash
git pull
python scripts/rename_app_in_db.py /home/user/site/db.sqlite3   # faqat birinchi marta
pip install -r requirements.txt
python manage.py migrate
python manage.py collectstatic --noinput
# keyin Web bo'limida "Reload" tugmasini bosing
```

Serverda `.env` faylida `DJANGO_DEBUG=False` qilib qo'ying.

## Xavfsizlik

- `SECRET_KEY` va email paroli endi kodda emas, `.env` faylida saqlanadi.
- Eski `SECRET_KEY` va Gmail paroli GitHub tarixida qolgan. Ularni
  **almashtirish tavsiya etiladi**: Gmail hisobida App Password'ni o'chirib,
  yangisini `.env` ga yozing.
- `.env`, `staticfiles/` va `temp_images/` gitga qo'shilmaydi.

## Texnologiyalar

Django 5.2, SQLite, Bootstrap 3, Mashup Template (Orson.io), Font Awesome.
