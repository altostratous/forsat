from django.shortcuts import render, redirect
from tasks import forms


# Create your views here.
def create(request):
    if request.method == 'POST':
        task = forms.TaskForm(request.POST).save(commit=False)
        task.save()
        return redirect('panel')
    else:
        return render(request, 'form.html', {'form': forms.TaskForm()})
