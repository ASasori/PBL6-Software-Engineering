from django.urls import path, re_path, include
from hotel.views_api import location, search_hotel_by_location_name, index, hotel_detail, room_type_detail, create_checkout_session, payment_success, payment_failed, checkout_api, ReviewViewSet, BookingViewSet, get_public_coupon, get_featured_hotels, search_hotel_by_location_and_price
from hotel import views_api
from rest_framework.routers import DefaultRouter

app_name = "hotel_api"

router = DefaultRouter()
router.register('hotels', views_api.HotelViewSet)
router.register('rooms', views_api.RoomViewSet)
router.register('roomtypes', views_api.RoomTypeViewSet)
router.register('reviews', ReviewViewSet, basename='review')
router.register('bookings', BookingViewSet, basename='booking')

urlpatterns = [
     path('checkout-api/<str:booking_id>/', checkout_api, name='checkout_api'),  # API to handle checkout and coupon application
     path('checkout/<str:booking_id>/', create_checkout_session, name='create_checkout_session'),  # Checkout for booking
     path('payment-success/<str:booking_id>/', payment_success, name='payment_success'),  # Payment success
     path('payment-failed/<str:booking_id>/', payment_failed, name='payment_failed'),

     path('', include(router.urls)),
     path('search-hotels/', search_hotel_by_location_and_price, name='search_hotels'),
     path('featured-hotels/', get_featured_hotels, name='featured_hotels'),
     path('hotels/<slug:h_slug>/room-types/<slug:rt_slug>/rooms/', 
         views_api.RoomViewSet.as_view({'get': 'room_by_roomtype'}), name='room-by-roomtype'),
     path('hotels/<slug:h_slug>/room-types/', 
         views_api.RoomTypeViewSet.as_view({'get': 'roomtype_by_hotel'}), name='roomtype-by-hotel'),
     path('cart/',
          views_api.CartViewSet.as_view({'get': 'get_or_create_cart'}), name='get-cart-by-user'),
     path('add-cart-item/', 
          views_api.CartViewSet.as_view({'post': 'add_cart_item'}), name='add-cart-item'),
     path('get_cart_item_count/', 
          views_api.CartViewSet.as_view({'get': 'get_cart_item_count'}), name='get_cart_item_count'),
     path('delete_cart_item/', 
          views_api.CartViewSet.as_view({'post': 'delete_cart_item'}), name='delete_cart_item'),
     path('view_cart/', 
          views_api.CartViewSet.as_view({'get': 'view_cart'}), name='view_cart'),
     path('cart/view_cart_item/<int:cart_item_id>/', 
         views_api.CartViewSet.as_view({'get': 'view_cart_item'}), name='view_cart_item'),
     path('bookings/create/', 
          views_api.BookingViewSet.as_view({'post': 'create_booking'}), name='create_booking'),
     path('bookings/my-bookings/', 
          views_api.BookingViewSet.as_view({'get': 'get_user_bookings'}), name='get_user_bookings'),
     path('bookings/get-detail-booking/<str:booking_id>/', 
          views_api.BookingViewSet.as_view({'get': 'get_detail_booking'}), name='get_detail_booking'),

     # Custom Review Endpoints
     path('reviews/post/', 
         ReviewViewSet.as_view({'post': 'create_review'}), name='create_review'),
     path('reviews/hotel-reviews/<str:pk>/', 
         ReviewViewSet.as_view({'get': 'get_reviews_by_hotel'}), name='get_hotel_reviews'),   
     path('reviews/my-reviews/', 
         ReviewViewSet.as_view({'get': 'get_my_reviews'}), name='get_my_reviews'),   
     path('reviews/delete/<str:pk>/', 
         ReviewViewSet.as_view({'delete': 'delete_review'}), name='delete_review'),   

     # Location 
     path('locations/', location, name = 'location'),
     path('locations/hotels_by_location/', search_hotel_by_location_name, name = 'hotels_by_location'),

     #Coupon public
     path('public-coupons/', get_public_coupon, name='get_coupon'),
     path('coupons/', get_public_coupon, name='get_coupon'),

]
