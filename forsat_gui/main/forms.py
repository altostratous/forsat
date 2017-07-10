from django.forms import ModelForm

from main.models import User


class UserForm(ModelForm):
    class Meta:
        model = User
        exclude = ['last_activity']
