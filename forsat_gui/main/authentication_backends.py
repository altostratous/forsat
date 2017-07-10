import hashlib
from django.contrib.auth.backends import ModelBackend

from forsat_gui.main.models import User


class ForsatAuthenticationBackend(ModelBackend):
    def get_user(self, user_id):
        users = User.objects.raw('SELECT * FROM User WHERE email = %s', [user_id])
        for user in users:
            return user
        return None

    def authenticate(self, username=None, password=None, **kwargs):
        hasher = hashlib.md5()
        hasher.update(password)
        users = User.objects.raw('SELECT * FROM User WHERE email = %s AND password = %s', [username,  hasher.hexdigest()])
        for user in users:
            return user
        return None
