from django.urls import path
from .views_api import create_room, list_rooms, get_room, update_room, delete_room


urlpatterns = [
    path('', list_rooms, name='list_rooms'),
    path('create/', create_room, name='create_room'),
    path('<int:room_id>/', get_room, name='get_room'), 
    path('<int:room_id>/update/', update_room, name='update_room'), 
    path('<int:room_id>/delete/', delete_room, name='delete_room'),
]
