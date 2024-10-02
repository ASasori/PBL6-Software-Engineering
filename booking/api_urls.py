from django.urls import path
from .views_api import check_room_availability, delete_session, add_to_selection, delete_selection, booking_data

app_name = "booking_api"

urlpatterns = [
    path("check-room-availability/", check_room_availability, name="check_room_availability"),
    path("delete-session/", delete_session, name="delete_session"),
    path("add-to-selection/", add_to_selection, name="add_to_selection"),
    path("delete-selection/", delete_selection, name="delete_selection"),
    path("booking-data/<slug:slug>/", booking_data, name="booking_data"),
]
