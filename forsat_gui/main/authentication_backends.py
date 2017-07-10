import hashlib
from django.contrib.auth.backends import ModelBackend

from main.models import User


class ForsatAuthenticationBackend(ModelBackend):
    def get_user(self, user_id):
        users = User.objects.raw('SELECT * FROM "User" WHERE email = %s', [user_id])
        for user in users:
            user.is_anonymous = False
            return user
        return None

    def authenticate(self, username=None, password=None, **kwargs):
        users = User.objects.raw('SELECT * FROM "User" WHERE email = %s AND password = %s',
                                 [username, User.hash(password)])
        for user in users:
            user.is_authenticated = True
            user.is_anonymous = False
            return user
        return None
