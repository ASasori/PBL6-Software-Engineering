from django.urls import path
from .views_api import list_available_rooms


urlpatterns = [
    path('available_rooms/', list_available_rooms, name='list_available_rooms'),
]
