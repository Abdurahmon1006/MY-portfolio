#!/usr/bin/env python
"""
Bir martalik skript: `apps` ilovasi `portfolio` deb qayta nomlangani uchun
bazadagi eski yozuvlarni yangilaydi.

Nima qiladi:
  1. `apps_*` jadvallarni `portfolio_*` nomiga o'tkazadi
  2. `django_migrations` jadvalidagi ilova nomini yangilaydi
  3. `django_content_type` jadvalidagi app_label ni yangilaydi

Ishlatish (loyiha ildizida):
    python scripts/rename_app_in_db.py                      # db.sqlite3 avtomatik topiladi
    python scripts/rename_app_in_db.py yo'l/db.sqlite3      # aniq fayl uchun

Skript ishga tushishidan oldin `db.sqlite3.bak` zaxira nusxasini oladi.
Uni bir necha marta ishga tushirish xavfsiz (ikkinchisida hech narsa
o'zgarmaydi). Boshqa muhitdagi (masalan PythonAnywhere) baza uchun ham
xuddi shu skriptni o'sha faylga qaratib ishlatish mumkin.
"""

import shutil
import sqlite3
import sys
from pathlib import Path

OLD_LABEL = 'apps'
NEW_LABEL = 'portfolio'
MODELS = ('ish', 'yutuq', 'game')


def find_db():
    """Bazani topish: avval argument, keyin loyiha ildizi, keyin joriy papka."""
    if len(sys.argv) > 1:
        return Path(sys.argv[1]).expanduser()

    project_root = Path(__file__).resolve().parent.parent
    for candidate in (project_root / 'db.sqlite3', Path.cwd() / 'db.sqlite3'):
        if candidate.exists():
            return candidate

    raise SystemExit("Xato: db.sqlite3 topilmadi. Yo'lni argument sifatida bering.")


def main():
    db_path = find_db()
    if not db_path.exists():
        raise SystemExit(f'Xato: fayl topilmadi -> {db_path}')

    backup = db_path.with_name(db_path.name + '.bak')
    if not backup.exists():
        shutil.copy2(db_path, backup)
        print(f'Zaxira nusxa olindi: {backup}')

    connection = sqlite3.connect(db_path)
    try:
        existing_tables = {
            row[0]
            for row in connection.execute("SELECT name FROM sqlite_master WHERE type='table'")
        }

        changes = []

        # 1. Jadval nomlari
        for model in MODELS:
            old_table = f'{OLD_LABEL}_{model}'
            new_table = f'{NEW_LABEL}_{model}'
            if old_table in existing_tables and new_table not in existing_tables:
                connection.execute(f'ALTER TABLE "{old_table}" RENAME TO "{new_table}"')
                changes.append(f'{old_table} -> {new_table}')

        # 2. django_migrations va django_content_type yozuvlari
        for table, column in (
            ('django_migrations', 'app'),
            ('django_content_type', 'app_label'),
        ):
            if table in existing_tables:
                cursor = connection.execute(
                    f'UPDATE {table} SET {column} = ? WHERE {column} = ?',
                    (NEW_LABEL, OLD_LABEL),
                )
                if cursor.rowcount:
                    changes.append(f'{table}.{column}: {cursor.rowcount} ta yozuv')

        connection.commit()
    finally:
        connection.close()

    if changes:
        print('Yangilandi:')
        for change in changes:
            print(f'  - {change}')
        print('Tayyor! Endi `python manage.py migrate` ishlaydi.')
    else:
        print("Hech narsa o'zgartirilmadi — baza allaqachon yangi holatda.")


if __name__ == '__main__':
    main()
