from django.conf.urls import url
from main import views

urlpatterns = [
    url(r'register', view=views.register, name='register')
]