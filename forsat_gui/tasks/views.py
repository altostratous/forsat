from django.shortcuts import render, redirect
from tasks import forms


# Create your views here.
from tasks.models import Task


def create(request):
    if request.method == 'POST':
        task = forms.TaskForm(request.POST).save(commit=False)
        task.save()
        return redirect('panel')
    else:
        return render(request, 'form.html', {'form': forms.TaskForm()})


def single(request, task_id):
    if request.method == 'POST':
        Task.update_task(task_id, forms.TaskForm(request.POST).save(commit=False))
    return render(request, 'form.html', {'form': forms.TaskForm(instance=Task.get_single_task(task_id)),
                                         'form_action': request.get_full_path(),
                                         'subtasks': Task.get_subtasks(task_id),
                                         'reminders': Task.get_reminders(task_id)})
