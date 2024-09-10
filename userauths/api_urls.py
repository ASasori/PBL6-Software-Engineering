# userauths/api_urls.py

from django.urls import path
from .views_api import register_view, login_view, logout_view

app_name = "userauths_api"

urlpatterns = [
    path('register/', register_view, name='register'),
    path('login/', login_view, name='login'),
    path('logout/', logout_view, name='logout'),
]
