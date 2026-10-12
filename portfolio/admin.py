from django.contrib import admin

from .forms import *
from .models import *

# Admin panel sarlavhalari
admin.site.site_header = 'My Portfolio boshqaruv paneli'
admin.site.site_title = 'My Portfolio'
admin.site.index_title = "Yutuq va o'yinlarni boshqarish"


@admin.register(ish)
class IshAdmin(admin.ModelAdmin):
    """Ishlar bo'limi (rasm, narx va ma'lumot bilan)."""

    form = ishForum
    list_display = ('nomi', 'narxi')


@admin.register(yutuq)
class YutuqAdmin(admin.ModelAdmin):
    """Yutuqlar bo'limi — saytdagi `works` sahifasida ko'rinadi."""

    list_display = ('nomi', 'darajasi', 'sana')
    list_filter = ('darajasi', 'sana')
    search_fields = ('nomi', 'tavsif')
    ordering = ('-sana',)


@admin.register(game)
class GameAdmin(admin.ModelAdmin):
    """O'yinlar bo'limi — saytdagi `games` sahifasida ko'rinadi."""

    list_display = ('nomi', 'kategoriya', 'yaratilgan_sana')
    list_filter = ('kategoriya', 'yaratilgan_sana')
    search_fields = ('nomi', 'tavsif')
    ordering = ('-yaratilgan_sana',)
    readonly_fields = ('yaratilgan_sana', 'yangilangan_sana')
