from django.urls import path, re_path, include
from hotel.views_api import index, hotel_detail, room_type_detail, create_booking, create_checkout_session, payment_success, payment_failed, checkout_api, ReviewViewSet 
from hotel import views, views_api
from rest_framework.routers import DefaultRouter

app_name = "hotel_api"

router = DefaultRouter()
router.register('hotels', views_api.HotelViewSet)
router.register('rooms', views_api.RoomViewSet)
router.register('roomtypes', views_api.RoomTypeViewSet)
router.register('reviews', ReviewViewSet, basename='review')

urlpatterns = [
#     path('hotels/', index, name='hotel_list'),  # List all live hotels
#     path('hotels/<slug>/', hotel_detail, name='hotel_detail'),  # Get hotel details by slug
#     path('hotels/<slug:slug>/room-types/<slug:rt_slug>/', room_type_detail, name='room_type_detail'),  # Get room type details for a specific hotel
     path('booking/create/', create_booking, name='create_booking'),  # Create a new booking
     path('checkout-api/<str:booking_id>/', checkout_api, name='checkout_api'),  # API to handle checkout and coupon application
     path('checkout/<str:booking_id>/', create_checkout_session, name='create_checkout_session'),  # Checkout for booking
     path('payment-success/<str:booking_id>/', payment_success, name='payment_success'),  # Payment success
     path('payment-failed/<str:booking_id>/', payment_failed, name='payment_failed'),

     path('', include(router.urls)),
     path('hotels/<slug:h_slug>/room-types/<slug:rt_slug>/rooms/', 
         views_api.RoomViewSet.as_view({'get': 'room_by_roomtype'}), name='room-by-roomtype'),
     path('hotels/<slug:h_slug>/room-types/', 
         views_api.RoomTypeViewSet.as_view({'get': 'roomtype_by_hotel'}), name='roomtype-by-hotel'),
     path('cart',
          views_api.CartViewSet.as_view({'get': 'get_or_create_cart'}), name='get-cart-by-user'),
     path('add-cart-item', 
          views_api.CartViewSet.as_view({'post': 'add_cart_item'}), name='add-cart-item'),
     path('get_cart_item_count', 
          views_api.CartViewSet.as_view({'get': 'get_cart_item_count'}), name='get_cart_item_count'),
     path('delete_cart_item', 
          views_api.CartViewSet.as_view({'post': 'delete_cart_item'}), name='delete_cart_item'),
     path('view_cart', 
          views_api.CartViewSet.as_view({'get': 'view_cart'}), name='view_cart'),
    
       # Custom Review Endpoints
     path('reviews/post/', 
         ReviewViewSet.as_view({'post': 'create_review'}), name='create_review'),
     path('reviews/hotel-reviews/<str:pk>/', 
         ReviewViewSet.as_view({'get': 'get_reviews_by_hotel'}), name='get_hotel_reviews'),      
]
