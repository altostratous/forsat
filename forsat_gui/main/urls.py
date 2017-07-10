from django.conf.urls import url
from main import views

urlpatterns = [
    url(r'^register', view=views.register, name='register'),
    url(r'^panel/(?P<message>)', view=views.panel, name='panel_with_message'),
    url(r'^panel', view=views.panel, name='panel'),
]
