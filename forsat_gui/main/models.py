from django.db import models, connection, Error
import hashlib


class User(models.Model):
    class Meta:
        db_table = 'User'
    email = models.EmailField(primary_key=True)
    password = models.CharField(max_length=8192)
    nickname = models.CharField(max_length=8192)
    pic_url = models.URLField(default='http://www.gravatar.com/avatar/00095965ca2e9b81c365d541b9cc73ec?s=40&d=identicon')
    last_activity = models.DateTimeField()

    def save(self, force_insert=False, force_update=False, using=None,
             update_fields=None):
        with connection.cursor() as cursor:
            try:
                cursor.execute(
                    'INSERT INTO "User" (email, nickname, password, pic_url, last_activity) '
                    'VALUES (%s, %s, %s, %s, current_timestamp);',
                    [self.email, self.nickname, self.password, self.pic_url]
                )
                return True
            except Error:
                return False

    @staticmethod
    def hash(raw_password):
        hasher = hashlib.md5()
        hasher.update(raw_password.encode('utf-8'))
        return hasher.hexdigest()


class Folder(models.Model):
    path = models.CharField(max_length=8192, primary_key=True)
    email = models.EmailField()
    child_of_path = models.CharField(max_length=8192)

