from django.contrib import messages
from django.shortcuts import redirect, render

from .models import *
from django.core.mail import send_mail
from django.conf import settings
import random


def random_percent():
    return f"{random.randint(0, 100)}%"

def random_delay():
    return f"{random.uniform(0.1, 3):.2f}s"

def about(request):
    particles = [{
        'top': random_percent(),
        'left': random_percent(),
        'delay': random_delay()
    } for _ in range(30)]  # 30 ta zarracha

    return render(request, 'about.html', {'particles': particles})  # ✅ BU YER TO‘G‘RILANDI


# Create your views here.
def index(request):
    return render(request, 'index.html')

def secretpage(request):
    return render(request, 'secretpage.html')

def balloon(request):
    return render(request, 'balloon.html')

def components(request):
    return render(request, 'components.html')

def contact(request):
    """Aloqa formasi: xabar settings.EMAIL_HOST_USER manziliga yuboriladi."""
    if request.method == 'POST':
        name = request.POST.get('name', '').strip()
        email = request.POST.get('email', '').strip()
        message = request.POST.get('message', '').strip()
        full_message = f"{email} dan sizga quyidagi habar keldi:\n\n\n{message}"

        try:
            send_mail(
                f'{name} sizga habar yubordi.',
                full_message,
                settings.EMAIL_HOST_USER,
                [settings.EMAIL_HOST_USER],
                fail_silently=False,
            )
            messages.success(request, "Xabaringiz yuborildi. Tez orada javob beraman!")
        except Exception as error:
            print(f'Email yuborishda xato: {error}')
            messages.error(
                request,
                "Kechirasiz, xabar yuborilmadi. Keyinroq qayta urinib ko'ring.",
            )
        return redirect('contact')

    return render(request, 'contact.html')

def work(request):
    works = ish.objects.all()
    return render(request, 'work.html', {'works': works})

def works(request):
    # Endi works sahifasida yutuqlar ko'rsatiladi
    yutuqlar = yutuq.objects.all()
    return render(request, 'works.html', {'yutuqlar': yutuqlar})

def yutuq_detail(request, id):
    yutuq_obj = yutuq.objects.get(id=id)
    return render(request, 'yutuq_detail.html', {'yutuq': yutuq_obj})

def games(request):
    # O'yinlar sahifasida barcha o'yinlarni ko'rsatamiz
    oyinlar = game.objects.all()
    return render(request, 'games.html', {'oyinlar': oyinlar})

def game_detail(request, id):
    game_obj = game.objects.get(id=id)
    return render(request, 'game_detail.html', {'game': game_obj})
