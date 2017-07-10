from django.conf.urls import url
from tasks import views

urlpatterns = [
    url(r'^create', view=views.create, name='create_task'),
    url(r'^single/([0-9])', view=views.single, name='single_task'),
]
