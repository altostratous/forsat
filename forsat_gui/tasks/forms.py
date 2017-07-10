from django.forms import ModelForm
from tasks import models


class TaskForm(ModelForm):
    class Meta:
        model = models.Task
        exclude = ['id']

    def __init__(self, *args, **kwargs):
        # first call parent's constructor
        super(ModelForm, self).__init__(*args, **kwargs)
        # there's a `fields` property now
        self.fields['description'].required = False
        self.fields['predicted_time'].required = False
        self.fields['predicted_duration'].required = False
        self.fields['real_time'].required = False
        self.fields['real_duration'].required = False
        self.fields['deadline'].required = False
        self.fields['recurrence_of_id'].required = False
        self.fields['deadline'].required = False
        self.fields['assigned_user_email'].required = False
