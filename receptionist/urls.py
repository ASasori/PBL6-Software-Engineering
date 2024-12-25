from django.urls import path, include
from .views_api import update_profile, get_receptionist_profile, get_user_info, change_password
urlpatterns = [
    path('api/rooms/', include('receptionist.api_urls_rooms')),
    path('api/roomtypes/', include('receptionist.api_urls_roomtypes')),
    path('api/customers/', include('receptionist.api_urls_customers')),
    path('api/bookings/', include('receptionist.api_urls_bookings')),



    path('api/profile/update/', update_profile, name='update_profile'),
    path('api/profile/', get_receptionist_profile, name='get_receptionist_profile'),
    path('api/user/info/', get_user_info, name='get_user_info'),
    path('api/user/change_password/', change_password, name='change_password'),
]