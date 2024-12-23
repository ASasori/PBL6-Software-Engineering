    # userauths/api_urls.py

from django.urls import path

from .views_api import register_view, login_view, logout_view, user_profile_view, edit_profile_view, change_password_view
from userauths.views_api import send_reset_password_email, reset_password
app_name = "userauths_api"

urlpatterns = [
    path('register/', register_view, name='register'),
    path('login/', login_view, name='login'),
    path('logout/', logout_view, name='logout'),
    path('auth/reset-password/', send_reset_password_email, name='send_reset_password_email'),
    path('auth/reset-password/<str:uidb64>/<str:token>/', reset_password, name='reset_password'),
    path('profile/', user_profile_view, name='profile'),
    path('profile/edit/', edit_profile_view, name='edit_profile'),  # Add URL for edit_profile
    path('change-password/', change_password_view, name='change_password'),  # Add URL for change_password
]
