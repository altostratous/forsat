from django.shortcuts import render
from main.forms import UserForm


def register(request):
    if request.method == 'POST':
        pass
    else:
        form = UserForm()
    return render(request, 'main/register.html', {'form': form})
