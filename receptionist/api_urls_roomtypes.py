from django.urls import path
from .views_api import (
    create_room_type, list_room_types, get_room_type, update_room_type, delete_room_type,
)

urlpatterns = [
    path('', list_room_types, name='list_room_types'),
    path('create/', create_room_type, name='create_room_type'),
    path('<int:room_type_id>/', get_room_type, name='get_room_type'), 
    path('<int:room_type_id>/update/', update_room_type, name='update_room_type'), 
    path('<int:room_type_id>/delete/', delete_room_type, name='delete_room_type'),
]
