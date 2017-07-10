from django.shortcuts import render, redirect
from main.forms import UserForm
from main.models import User
from django.contrib.auth import authenticate


def register(request):
    if request.method == 'POST':
        form = UserForm(request.POST)
        user = form.save(commit=False)
        raw_password = user.password
        user.password = User.hash(user.password)
        if user.save():
            request.message = 'Successfully registered.'
            authenticate(username=user.email, password=raw_password)
            return panel(request)
        else:
            request.message = 'There\'s a problem with the information. May be the ' \
                                     'email is taken or password is not strong enough.'
    else:
        form = UserForm()
    if hasattr(request, 'message'):
        message = request.message
    else:
        message = None
    return render(request, 'main/register.html', {'form': form, 'message': message})


def panel(request):
    if hasattr(request, 'message'):
        message = request.message
    else:
        message = None
    return render(request, 'main/panel.html', {'message': message})
