from django.conf.urls import url
from tasks import views

urlpatterns = [
    url(r'^create', view=views.create, name='create_task'),
]
