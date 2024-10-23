from django.urls import path, include

urlpatterns = [
    path('api/rooms/', include('receptionist.api_urls_rooms')),
    path('api/roomtypes/', include('receptionist.api_urls_roomtypes'))
]