from django.urls import path
from .views_api import index, hotel_detail, room_type_detail

app_name = "hotel_api"

urlpatterns = [
    path('', index, name='index'),
    path('<slug:slug>/', hotel_detail, name='hotel_detail'),
    path('<slug:slug>/room-type/<slug:rt_slug>/', room_type_detail, name='room_type_detail'),
]