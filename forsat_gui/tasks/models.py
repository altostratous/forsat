from django.db import models


# Create your models here.

class Folder(models.Model):
    path = models.CharField(max_length=8192, primary_key=True)
    email = models.EmailField()
    child_of_path = models.CharField(max_length=8192)


class Task(models.Model):
    id = models.IntegerField(primary_key=True)
    title = models.CharField(max_length=8192)
    starred = models.BooleanField()
    description = models.TextField(null=True)
    predicted_time = models.DateTimeField(null=True)
    real_time = models.DateTimeField(null=True)
    predicted_duration = models.FloatField(null=True)
    real_duration = models.FloatField(null=True)
    deadline = models.DateTimeField(null=True)
    email = models.EmailField(verbose_name='List owner email')
    path = models.CharField(max_length=8192)
    recurrence_of_id = models.IntegerField(null=True)
    assigned_user_email = models.EmailField(null=True)

    def save(self, force_insert=False, force_update=False, using=None,
             update_fields=None):
        pass

    @staticmethod
    def get_tasks_of_today(email):
        tasks = Task.objects.raw(
            'SELECT * FROM task'
            ' WHERE assigned_user_email = %s AND'
            '  predicted_time BETWEEN current_date AND current_date + INTERVAL \'1 days\';', [email])
        return tasks

    @staticmethod
    def get_single_task(task_id):
        tasks = Task.objects.raw(
            'SELECT * FROM task'
            ' WHERE id = %s', [task_id])
        return tasks[0]
