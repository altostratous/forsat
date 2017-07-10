from django.shortcuts import render, redirect
from main.forms import UserForm
from main.models import User
from django.contrib.auth import authenticate, login
from django.contrib import auth


def register(request):
    if request.method == 'POST':
        form = UserForm(request.POST)
        user = form.save(commit=False)
        raw_password = user.password
        user.password = User.hash(user.password)
        if user.save():
            request.message = 'Successfully registered.'
            authenticated_user = authenticate(username=user.email, password=raw_password)
            if authenticated_user is not None:
                auth.login(request, user=authenticated_user, backend='main.authentication_backends.ForsatAuthenticationBackend')
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
    print(request.user)
    print(request.user.is_anonymous)
    return render(request, 'main/panel.html', {'message': message})


def logout(request):
    auth.logout(request)
    return render(request, 'main/login.html', {'message': 'Logged out successfully.'})


def login(request):
    if request.method == 'POST':
        authenticated_user = authenticate(username=request.POST['username'], password=request.POST['password'])
        if authenticated_user is not None:
            auth.login(request, authenticated_user, 'main.authentication_backends.ForsatAuthenticationBackend')
            return redirect('panel')
        else:
            return render(request, 'main/login.html', {'message': 'Wrong credentials.'})
    else:
        return render(request, 'main/login.html', {'message': None})
