from django.urls import path
from . import views_api

app_name = 'booking_api'

urlpatterns = [
    # path('test-check-room-availability/', views_api.test_post, name='test_post'),
    path('check-room-availability/', views_api.check_room_availability, name='check_room_availability'),
    path('add-to-selection/', views_api.add_to_selection, name='add_to_selection'),
    path('delete-selection/', views_api.delete_selection, name='delete_selection'),
    path('delete-session/', views_api.delete_session, name='delete_session'),
    path('check-booking-availability/', views_api.check_booking_availability, name='check_booking_availability'),
]
