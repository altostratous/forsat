from django.db import models


# Create your models here.

class Folder(models.Model):
    path = models.CharField(max_length=8192, primary_key=True)
    email = models.EmailField()
    child_of_path = models.CharField(max_length=8192)


class SubTask(models.Model):
    task_id = models.IntegerField()
    title = models.CharField(max_length=8192)
    starred = models.BooleanField()


class Reminder(models.Model):
    time = models.DateTimeField()
    task_id = models.IntegerField()
    send_email = models.BooleanField()
    notify = models.BooleanField()


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
    def get_starred_tasks(email):
        tasks = Task.objects.raw(
            'SELECT * FROM task'
            ' WHERE assigned_user_email = %s AND starred AND'
            '  predicted_time BETWEEN current_date AND current_date + INTERVAL \'1 days\';', [email])
        return tasks

    @staticmethod
    def get_archived_tasks(email):
        tasks = Task.objects.raw(
            'SELECT * FROM task'
            ' WHERE assigned_user_email = %s AND real_duration IS NOT NULL;', [email])
        return tasks

    @staticmethod
    def get_subtasks(task_id):
        tasks = SubTask.objects.raw(
            'SELECT id as task_id, * FROM subtask'
            ' WHERE id = %s;', [task_id])
        return tasks

    @staticmethod
    def get_reminders(task_id):
        reminders = Reminder.objects.raw(
            'SELECT id as task_id, * FROM reminder'
            ' WHERE id = %s;', [task_id])
        return reminders

    @staticmethod
    def get_single_task(task_id):
        tasks = Task.objects.raw(
            'SELECT * FROM task'
            ' WHERE id = %s', [task_id])
        return tasks[0]

    @staticmethod
    def update_task(task_id, task):
        from django.db import connection
        if task.predicted_duration is not None:
            task.predicted_duration = None  # 'INTERVAL\'' + task.predicted_duration.__str__() + ' hour\''
        if task.real_duration is not None:
            task.real_duration = None  # 'INTERVAL\'' + task.real_duration.__str__() + ' hour\''
        with connection.cursor() as cursor:
            cursor.execute(
                'UPDATE task SET title = %s, description = %s, deadline = %s, starred = %s, predicted_time = %s,'
                ' predicted_duration = %s, real_time = %s, real_duration = %s, path = %s, assigned_user_email = %s'
                ' WHERE id = %s',
                [task.title, task.description, task.deadline, task.starred, task.predicted_time,
                 task.predicted_duration, task.real_time, task.real_duration,
                 task.path, task.assigned_user_email, task_id])
        return

    @staticmethod
    def get_hours_worked(email):
        from django.db import connection
        with connection.cursor() as cursor:
            cursor.execute(
                'SElECT extract(HOUR FROM sum(real_duration)) FROM task WHERE assigned_user_email = %s',
                [email])
            return [row[0] for row in cursor.fetchall()][0]
