from django.urls import path
from .views_api import list_available_rooms, add_booking, list_bookings, list_coupons, delete_booking


urlpatterns = [
    path('available_rooms/', list_available_rooms, name='list_available_rooms'),
    path('list_coupons/', list_coupons, name='list_coupons'),
    path('add/', add_booking, name='add-booking'),
    path('list/', list_bookings, name='list_bookings'),
    path('delete/<booking_id>/', delete_booking, name='delete-booking')
]
