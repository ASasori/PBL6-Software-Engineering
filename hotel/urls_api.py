from django.urls import path
from hotel.views_api import index, hotel_detail, room_type_detail, create_booking, create_checkout_session, payment_success, payment_failed, checkout_api

app_name = "hotel_api"

urlpatterns = [
    path('hotels/', index, name='hotel_list'),  # List all live hotels
    path('hotels/<slug>/', hotel_detail, name='hotel_detail'),  # Get hotel details by slug
    path('hotels/<slug:slug>/room-types/<slug:rt_slug>/', room_type_detail, name='room_type_detail'),  # Get room type details for a specific hotel
    path('bookings/create/', create_booking, name='create_booking'),  # Create a new booking
    path('checkout-api/<int:booking_id>/', checkout_api, name='checkout_api'), # API to handle checkout and coupon application
    path('checkout/<int:booking_id>/', create_checkout_session, name='create_checkout_session'),  # Checkout for booking
    path('payment-success/<int:booking_id>/', payment_success, name='payment_success'),  # Payment success
    path('payment-failed/<int:booking_id>/', payment_failed, name='payment_failed'),  # Payment failed
]
