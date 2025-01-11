from django.urls import path,include
from django.contrib import admin
from .admin import admin_site, StatisticAdminView
from hotel import views

app_name = "hotel"

urlpatterns = [
    path("", views.index, name="index"),
    path("detail/<slug>/", views.hotel_detail, name="hotel_detail"),
    path("detail/<slug:slug>/room-type/<slug:rt_slug>/", views.room_type_detail, name="room_type_detail"),
    #path('admin/', admin.site.urls),
    path('statistics/', StatisticAdminView.as_view(), name='statistics'),

    path("selected_rooms/", views.selected_rooms, name="selected_rooms"),
    # path("checkout/<booking_id>",views.checkout, name="checkout"),
    
    #Payment routes
    path('api/checkout-session/<booking_id>/', views.create_checkout_session, name='api_checkout_session'),
    path('success/<booking_id>/', views.payment_success, name='success'),
    path('failed/<booking_id>/', views.payment_failed, name='failed'),
    
    # API routes
    path('api/', include('hotel.urls_api')), 

]