from django.db import models


class User(models.Model):
    email = models.EmailField()
    password = models.CharField(max_length=8192)
    nickname = models.CharField(max_length=8192)
    pic_url = models.URLField(default='http://www.gravatar.com/avatar/00095965ca2e9b81c365d541b9cc73ec?s=40&d=identicon')
    last_activity = models.DateTimeField()


class Folder(models.Model):
    path = models.CharField(max_length=8192)
    email = models.EmailField()
    child_of_path = models.CharField(max_length=8192)

