from django.forms import ModelForm
from django import forms

from main.models import User


class UserForm(ModelForm):
    class Meta:
        model = User
        widgets = {
            'password': forms.PasswordInput(),
        }
        exclude = ['last_activity']
