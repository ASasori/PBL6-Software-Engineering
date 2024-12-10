from django.urls import path, include
from .views_api import update_profile
urlpatterns = [
    path('api/rooms/', include('receptionist.api_urls_rooms')),
    path('api/roomtypes/', include('receptionist.api_urls_roomtypes')),
    path('api/customers/', include('receptionist.api_urls_customers')),
    path('api/bookings/', include('receptionist.api_urls_bookings')),



    path('api/profile/update/', update_profile, name='update_profile'),
]