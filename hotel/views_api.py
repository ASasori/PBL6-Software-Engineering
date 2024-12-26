from django.http import JsonResponse
from rest_framework import status, viewsets, permissions, generics
from rest_framework.decorators import api_view, action, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from hotel.models import Hotel, Booking, ActivityLog, StaffOnDuty, Room, RoomType, Coupon, Notification, Cart, CartItem, Review, HotelGallery
from .serializers import HotelSerializer, RoomTypeSerializer, RoomSerializer, CartSerializer, CartItemSerializer, ReviewSerializer, BookingSerializer,CouponSerializer
from rest_framework.parsers import MultiPartParser
from rest_framework.permissions import IsAdminUser
from datetime import datetime
from django.conf import settings
import stripe
from django.urls import reverse
from django.middleware.csrf import get_token
from django.db import models
from django.db.models import Q
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
import logging
from django.core.mail import send_mail
import os

class HotelViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]

    queryset = Hotel.objects.filter(status='Live')
    serializer_class = HotelSerializer
    lookup_field = 'slug'
    
    def get_queryset(self):
        queryset = self.queryset
        name = self.request.query_params.get('name', None)
        if name:
            queryset = queryset.filter(name__icontains=name)  
        return queryset

    @action(methods=['POST'], detail=True, url_path='hide-hotel', url_name='hide_hotel')
    def hide_hotel(self, request,  slug=None):
        try:
            h = Hotel.objects.get(slug=slug)
            h.status = 'Disable'
            h.save()
        except:
            return Response({'Error': 'Not found'}, status=status.HTTP_404_NOT_FOUND)
        return Response(data=HotelSerializer(h).data, status=status.HTTP_200_OK)
    
    @action(methods=['POST'], detail=True, url_path='display-hotel', url_name='display-hotel')
    def display_hotel(self, request, slug=None):
        try:
            h = Hotel.objects.get(slug=slug)
            h.status = 'Live'
            h.save()
        except:
            return Response({'Error': 'Not found'}, status=status.HTTP_404_NOT_FOUND)
        return Response(data=HotelSerializer(h).data, status=status.HTTP_200_OK)

class RoomViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]
    queryset = Room.objects.filter(is_available=True)
    serializer_class = RoomSerializer

    @action(methods=['GET'], detail=False, url_path='hotels/<slug:h_slug>/room-type/<slug:rt_slug>/rooms/')
    def room_by_roomtype(self, request, h_slug, rt_slug):
        try:
            h  = Hotel.objects.get(status='Live', slug=h_slug)
            rt = RoomType.objects.get(hotel=h, slug=rt_slug)
            r  = Room.objects.filter(room_type=rt, is_available=True)
        except:
            return Response({'Error': 'Not found'}, status=status.HTTP_404_NOT_FOUND)
        return Response({
            'hotel': HotelSerializer(h).data,
            'roomtype': RoomTypeSerializer(rt).data,
            'listroom': RoomSerializer(r, many=True).data
        }, status=status.HTTP_200_OK)
    
class RoomTypeViewSet(viewsets.ModelViewSet):
    permission_classes = [AllowAny]
    queryset = RoomType.objects.all()
    serializer_class = RoomTypeSerializer

    @action(methods=['GET'], detail=False, url_path='hotels/<slug:h_slug>/room-types/')
    def roomtype_by_hotel(self, request, h_slug):
        try:
            h = Hotel.objects.get(slug=h_slug)
            rt = RoomType.objects.filter(hotel=h)
        except:
            return Response({'Error': 'Not found'}, status=status.HTTP_404_NOT_FOUND)
        return Response({
            'hotel': HotelSerializer(h).data,
            'roomtype': RoomTypeSerializer(rt, many=True).data
        }, status=status.HTTP_200_OK)

@api_view(['GET'])
def index(request):
    hotels = Hotel.objects.filter(status='Live')
    serializer = HotelSerializer(hotels, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def hotel_detail(request, slug):
    try:
        hotel = Hotel.objects.get(status='Live', slug=slug)
    except Hotel.DoesNotExist:
        return Response({'error': 'Hotel not found'}, status=status.HTTP_404_NOT_FOUND)
    
    serializer = HotelSerializer(hotel)
    return Response(serializer.data)

@api_view(['GET'])
def room_type_detail(request, slug, rt_slug):
    try:
        hotel = Hotel.objects.get(status='Live', slug=slug)
        room_type = RoomType.objects.get(hotel=hotel, slug=rt_slug)
        rooms = Room.objects.filter(room_type=room_type, is_available=True)
    except (Hotel.DoesNotExist, RoomType.DoesNotExist):
        return Response({'error': 'Not found'}, status=status.HTTP_404_NOT_FOUND)

    room_type_serializer = RoomTypeSerializer(room_type)
    rooms_serializer = RoomSerializer(rooms, many=True)
    
    return Response({
        'hotel': HotelSerializer(hotel).data,
        'room_type': room_type_serializer.data,
        'rooms': rooms_serializer.data
    })


class CartViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        operation_description="Get or create a cart for the authenticated user.",
        responses={200: CartSerializer, 404: 'Cart not found'},
        tags=["Cart"],
    )

    @action(detail=False, methods=['GET'], url_path='get-or-create')
    def get_or_create_cart(self, request):
        cart, created = Cart.objects.get_or_create(user=request.user, is_active=True)
        serializer = CartSerializer(cart)
        return Response(serializer.data, status=200)
    
    @swagger_auto_schema(
        operation_description="View the current user's cart with all cart items.",
        responses={
            200: openapi.Response(
                description="Cart details with items grouped by hotels.",
                examples={
                    "application/json": {
                        "total_items_in_cart": 2,
                        "hotels": [
                            {
                                "hotel_id": 1,
                                "hotel_name": "Hotel A",
                                "hotel_slug": "hotel-a",
                                "rooms": [
                                    {
                                        "room_id": 101,
                                        "room_number": "A101",
                                        "price": 100.0,
                                        "bed": 2,
                                        "room_type": "Deluxe",
                                        "item_cart_id": 1,
                                    }
                                ]
                            }
                        ]
                    }
                }
            ),
            404: 'Cart not found'
        },
        tags=["Cart"],
    )

    @action(detail=False, methods=['GET'], url_path='view_cart')
    def view_cart(self, request):
        try:
            cart = Cart.objects.get(user=request.user, is_active=True)
            cart_items = cart.cart_items.select_related('room__hotel', 'room__room_type').all()  # Tối ưu truy vấn
            hotels_dict = {}
            for item in cart_items:
                hotel_name = item.room.hotel.name  
                hotel_slug = item.room.hotel.slug,
                room_info = {
                    'room_id': item.room.id,
                    'room_number': item.room.room_number,
                    'price': item.room.room_type.price,
                    'bed': item.room.room_type.number_of_beds,
                    'room_type': item.room.room_type.type, 
                    'slug_room_type': item.room.room_type.slug,
                    'item_cart_id': item.id,
                    'check_in_date': item.check_in_date,
                    'check_out_date': item.check_out_date,
                    'adults_count': item.num_adults,
                    'childrens_count': item.num_children,
                }
                if hotel_name not in hotels_dict:
                    hotels_dict[hotel_name] = {
                        'hotel_id': item.room.hotel.id,
                        'hotel_name': hotel_name,
                        'hotel_slug': hotel_slug,
                        'rooms': [room_info]  
                    }
                else:
                    hotels_dict[hotel_name]['rooms'].append(room_info) 

            items_list = list(hotels_dict.values())
            total_items = cart_items.count()

            return Response({
                'total_items_in_cart': total_items,
                'hotels': items_list
            }, status=status.HTTP_200_OK)

        except Cart.DoesNotExist:
            return Response({'error': 'Cart not found'}, status=status.HTTP_404_NOT_FOUND)

    @action(detail=False, methods=['GET'], url_path='view_cart_item/(?P<cart_item_id>[^/.]+)')
    def view_cart_item(self, request, cart_item_id=None):
        try:
            cart_item = CartItem.objects.select_related('room__hotel', 'room__room_type').get(id=cart_item_id)

            room_info = {
                'hotel_name': cart_item.room.hotel.name,
                'hotel_slug': cart_item.room.hotel.slug,
                'hotel_id': cart_item.room.hotel.id,
                'room_id': cart_item.room.id,
                'room_number': cart_item.room.room_number,
                'price': cart_item.room.room_type.price,
                'bed': cart_item.room.room_type.number_of_beds,
                'room_type': cart_item.room.room_type.type,
                'slug_room_type': cart_item.room.room_type.slug,
                'item_cart_id': cart_item.id,
                'check_in_date': cart_item.check_in_date,
                'check_out_date': cart_item.check_out_date,
                'adults_count': cart_item.num_adults,
                'childrens_count': cart_item.num_children,
            }

            return Response(room_info, status=status.HTTP_200_OK)

        except CartItem.DoesNotExist:
            return Response({'error': 'Cart item not found'}, status=status.HTTP_404_NOT_FOUND)

    @swagger_auto_schema(
        operation_description="Add a room item to the user's cart.",
        request_body=CartItemSerializer,  # Specify the request body schema
        responses={
            201: 'Cart item successfully created', 
            400: 'Bad request, room may already be booked for the selected dates',
            404: 'Cart not found'
        },
        tags=["Cart"]
    )

    @action(detail=False, methods=['POST'], url_path='add_cart_item')
    def add_cart_item(self, request):
        cart, created = Cart.objects.get_or_create(user=request.user, is_active=True)
        room_id = request.data.get('room')
        checkin_date = request.data.get('check_in_date')
        checkout_date = request.data.get('check_out_date')

        
        # if CartItem.objects.filter(cart=cart, room_id=room_id).exists():
        #     return Response({'error': 'Room already in cart'}, status=status.HTTP_400_BAD_REQUEST)

        overlapping_items = CartItem.objects.filter(cart=cart, room_id=room_id).filter(
        (models.Q(check_in_date__lte=checkout_date) & models.Q(check_out_date__gte=checkin_date))
    )

        if overlapping_items.exists():
            return Response({'error': 'Room is already booked for these dates'}, status=status.HTTP_400_BAD_REQUEST)
            
        serializer  = CartItemSerializer(data=request.data)

        if serializer.is_valid():
            cart_item = serializer.save(cart=cart)
            total_items = cart.cart_items.count()

            return Response({
                'cart_item_id': cart_item.id,
                'total_items_in_cart': total_items,
                'cart_item': serializer.data
            }, status = status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['GET'], url_path='cart-item-count')
    def get_cart_item_count(self, request):
        cart = Cart.objects.filter(user=request.user, is_active=True).first()
        total_items = cart.cart_items.count() if cart else 0
        return Response({'total_items_in_cart': total_items}, status=status.HTTP_200_OK)

    @action(detail=False, methods=['POST'], url_path='delete_cart_item')
    def delete_cart_item(self, request):
        item_cart_id = request.data.get('item_cart_id')
        try:
            cart = Cart.objects.get(user=request.user, is_active=True)      
            cart_item = CartItem.objects.get(cart=cart, id=item_cart_id)
            cart_item.delete()
            total_items = cart.cart_items.count()
            return Response({
                'message': 'Cart item deleted successfully', 
                'total_items': total_items
            }, status=status.HTTP_204_NO_CONTENT)
        
        except CartItem.DoesNotExist:
            return Response({'error': 'Cart item not found'}, status=status.HTTP_404_NOT_FOUND)
        except Cart.DoesNotExist:
            return Response({'error': 'Cart not found'}, status=status.HTTP_404_NOT_FOUND)

class BookingViewSet(viewsets.ModelViewSet):
    permission_classes = [IsAuthenticated]
    serializer_class = BookingSerializer
    queryset = Booking.objects.all()

    @action(detail=False, methods=['POST'], url_path='create')
    def create_booking(self, request):
        try:
            hotel_id = request.data.get('hotel_id')
            room_id = request.data.get('room_id')
            check_in_date = request.data.get('checkin')
            check_out_date = request.data.get('checkout')
            num_adults = request.data.get('adult')
            num_children = request.data.get('children')
            room_type_slug = request.data.get('room_type')
            before_discount = request.data.get('before_discount')
            total = before_discount
            full_name = request.data.get('full_name')
            email = request.data.get('email')
            phone = request.data.get('phone')

            hotel = Hotel.objects.get(id=hotel_id, status='Live')
            room_type = RoomType.objects.get(slug=room_type_slug, hotel=hotel)

            room = Room.objects.filter(room_type=room_type, id=room_id, is_available=True).first()
            if not room:
                return Response({'error': 'Room not available'}, status=status.HTTP_400_BAD_REQUEST)

            check_in_date_obj = datetime.strptime(check_in_date, '%Y-%m-%d')
            check_out_date_obj = datetime.strptime(check_out_date, '%Y-%m-%d')
            total_days = (check_out_date_obj - check_in_date_obj).days

            if total_days <= 0:
                return Response({'error': 'Check-out date must be after check-in date'}, status=status.HTTP_400_BAD_REQUEST)

            booking = Booking.objects.create(
                user=request.user,
                hotel=hotel,
                room_type=room_type,
                check_in_date=check_in_date,
                check_out_date=check_out_date,
                total_days=total_days,
                num_adults=num_adults,
                num_children=num_children,
                full_name=full_name,
                email=email,
                phone=phone,
                before_discount=before_discount,
                total=total
            )

            booking.room.add(room) 
            booking.save()
# Send booking confirmation email
            subject = "Booking Confirmation"
            message = (
                f"Dear {full_name},\n\n"
                f"Thank you for booking with us at {hotel.name}.\n"
                f"Here are your booking details:\n\n"
                f"Booking ID: {booking.booking_id}\n"
                f"Hotel: {hotel.name}\n"
                f"Room Type: {room_type.type}\n"
                f"Room Number: {room.room_number}\n"
                f"Check-in: {check_in_date}\n"
                f"Check-out: {check_out_date}\n"
                f"Total Days: {total_days}\n"
                f"Guests: {num_adults} Adults, {num_children} Children\n"
                f"Total Price: ${total}\n\n"
                f"We look forward to hosting you!\n\n"
                f"Best regards,\n{hotel.name} Team"
            )

            send_mail(
                subject=subject,
                message=message,
                #from_email="no-reply@hotelbooking.com",
                from_email="minamisasori28@gmail.com",
                recipient_list=[email],
                fail_silently=False,
            )

            return Response({
                'message': 'Booking created successfully',
                'booking_id': booking.booking_id
            }, status=status.HTTP_201_CREATED)


        except Hotel.DoesNotExist:
            return Response({'error': 'Invalid hotel'}, status=status.HTTP_400_BAD_REQUEST)
        except RoomType.DoesNotExist:
            return Response({'error': 'Invalid room type'}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['GET'], url_path='my-bookings')
    def get_user_bookings(self, request):
        user_bookings = Booking.objects.filter(user=request.user, payment_status='paid')
        serializer = self.get_serializer(user_bookings, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(detail=False, methods=['GET'], url_path='detail-booking')
    def get_detail_booking(self, request, booking_id=None):
        try:
            # booking = Booking.objects.get(booking_id=booking_id)
            booking = Booking.objects.select_related('user__profile').get(booking_id=booking_id)
            booking_info = {
                'accommodation_information': [booking.full_name, booking.email, booking.phone],
                'accommodation_information': {
                    'full_name_accommodation': booking.full_name,
                    'phone_accommodation': booking.phone,
                    'email_accommodation': booking.email,
                    },
                'hotel_name': booking.hotel.name,
                'room_type': booking.room_type.type,
                'payment_status': booking.payment_status,
                'full_name': booking.full_name,
                'phone': booking.phone,
                'email': booking.email,
                'before_discount': booking.before_discount,
                'total_bookings': booking.total,
                'discount': booking.saved,
                'check_in_date': booking.check_in_date,
                'check_out_date': booking.check_out_date,
                'num_adults': booking.num_adults,
                'num_children': booking.num_children,
                'date': booking.date,
                'address_hotel': booking.hotel.address,
                'email_hotel': booking.hotel.email,
                'total_days': booking.total_days,
                'orderer_information': {
                    'username_order': booking.user.username,
                    'full_name_order': booking.user.profile.full_name,
                    'phone_order': booking.user.profile.phone,
                    'address_order': booking.user.profile.address,
                    'city_order': booking.user.profile.city,
                    'country_order': booking.user.profile.country,
                    'email_order': booking.user.email,
                    }
            }
            return Response(booking_info, status=status.HTTP_200_OK)
        except Booking.DoesNotExist:
            return Response({'error': 'Booking does not exist'}, status=status.HTTP_404_NOT_FOUND)
@api_view(['POST'])
def checkout_api(request, booking_id):
    try:
        # Fetch the booking by ID
        booking = Booking.objects.get(booking_id=booking_id)

        # Extract the coupon code from the request
        code = request.data.get("code")
        print("code====", code)

        # If no code is provided, return an error
        if not code:
            return Response({'error': 'Coupon code is required'}, status=status.HTTP_400_BAD_REQUEST)

        # Try to fetch the coupon
        try:
            coupon = Coupon.objects.get(code=code, active=True)

            # Check if the coupon is already used for this booking
            if coupon in booking.coupons.all():
                return Response({'error': 'Coupon already activated'}, status=status.HTTP_400_BAD_REQUEST)
            if coupon.valid_to < datetime.now().date():
                return Response({'error': 'Coupon expired'}, status=status.HTTP_400_BAD_REQUEST)
            
            # Calculate the discount
            if coupon.type == "Percentage":
                discount = booking.total * coupon.discount / 100
            else:
                discount = coupon.discount

            # Apply the coupon to the booking
            booking.coupons.add(coupon)
            booking.total -= discount
            booking.saved += discount
            booking.save()

            # Return success response
            return Response({
                'message': 'Coupon activated',
                'booking_total': booking.total,
                'discount': discount
            }, status=status.HTTP_200_OK)

        except Coupon.DoesNotExist:
            return Response({'error': 'Coupon does not exist'}, status=status.HTTP_404_NOT_FOUND)

    except Booking.DoesNotExist:
        return Response({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)
    
@api_view(['POST'])
def create_checkout_session(request, booking_id):
    cart_item_id = request.data.get('cart_item_id')
    print(cart_item_id)
    try:
        booking = Booking.objects.get(booking_id=booking_id)
        stripe.api_key = settings.STRIPE_SECRET_KEY
        # success_url = f"http://localhost:3000/success-payment?session_id={{CHECKOUT_SESSION_ID}}&booking_id={booking.booking_id}&cart_item_id={cart_item_id}"
        # cancel_url = "http://localhost:3000/payment-failed"
        #{settings.FRONTEND_URL}
        success_url = f"{settings.FRONTEND_URL}/success-payment?session_id={{CHECKOUT_SESSION_ID}}&booking_id={booking.booking_id}&cart_item_id={cart_item_id}"
        cancel_url = f"{settings.FRONTEND_URL}/payment-failed"

        # domain = os.getenv('DOMAIN', 'http://localhost:3000')

        # success_url = f"{domain}/success-payment?session_id={{CHECKOUT_SESSION_ID}}&booking_id={booking.booking_id}&cart_item_id={cart_item_id}"
        # cancel_url = f"{domain}/payment-failed"

        checkout_session = stripe.checkout.Session.create(
            customer_email=booking.email,
            payment_method_types=['card'],
            line_items=[{
                'price_data': {
                    'currency': 'usd',
                    'product_data': {'name': f"Booking for {booking.full_name}"},
                    'unit_amount': int(booking.total * 100),
                },
                'quantity': 1,
            }],
            mode='payment',
            success_url=success_url,
            cancel_url=cancel_url,
        )

        booking.payment_status = "processing"
        booking.stripe_payment_intent = checkout_session['id']
        booking.save()

        return Response({
            'sessionId': checkout_session.id,
            'bookingId': booking_id
            }, status=status.HTTP_200_OK)

    except Booking.DoesNotExist:
        return Response({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['POST'])
def payment_success(request, booking_id):
    session_id = request.data.get('sessionId')
    booking = get_object_or_404(Booking, booking_id=booking_id)
    if booking.stripe_payment_intent == session_id and booking.payment_status == "processing":
        booking.payment_status = "paid"
        booking.save()
        return Response({'message': 'Payment successful'}, status=status.HTTP_200_OK)
    return Response({'error': 'Payment verification failed'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def payment_failed(request, booking_id):
    booking = get_object_or_404(Booking, booking_id=booking_id)
    booking.payment_status = "failed"
    booking.save()
    return Response({'message': 'Payment failed'}, status=status.HTTP_200_OK)


class ReviewViewSet(viewsets.ModelViewSet):
    """
    A ViewSet for handling Reviews.
    """
    permission_classes = [AllowAny]
    queryset = Review.objects.all()
    serializer_class = ReviewSerializer

    @swagger_auto_schema(
        operation_description="Create a new review",
        request_body=ReviewSerializer,  # Specify the serializer here
        responses={201: ReviewSerializer},  # Define the response schema
        tags=["Review"]
    )
    @action(detail=False, methods=['post'], url_path='post')
    def create_review(self, request):
        """Create a review."""
        try:
            serializer = ReviewSerializer(data=request.data)
            if serializer.is_valid():
                serializer.save(user=request.user)  # Ensure user is set to the logged-in user
                return Response(serializer.data, status=status.HTTP_201_CREATED)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @swagger_auto_schema(
        operation_description="Get reviews by hotel",
        responses={200: ReviewSerializer(many=True)},  # Define the response schema for a list of reviews
        tags=["Review"]
    )
    @action(detail=True, methods=['get'], url_path='hotel-reviews')
    def get_reviews_by_hotel(self, request, pk=None):
        """Fetch all reviews for a specific hotel."""
        try:
            hotel = Hotel.objects.get(hid=pk)
            #hotel = get_object_or_404(Hotel, hid=pk)
            reviews = Review.objects.filter(hotel=hotel)
            serializer = ReviewSerializer(reviews, many=True)
            return Response({'hotel_id': hotel.id, 'reviews': serializer.data}, status=status.HTTP_200_OK)
        except Hotel.DoesNotExist:
            return Response({'error': 'Hotel not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @action(detail=False, methods=['GET'], url_path='my-reviews')
    def get_my_reviews(self, request):
        my_reviews = Review.objects.filter(user=request.user)
        serializer = self.get_serializer(my_reviews, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    @action(detail=True, methods=['delete'], url_path='delete')
    def delete_review(self, request, pk=None):
        try:
            review = Review.objects.get(id=pk, user=request.user)
            review.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Review.DoesNotExist:
            return Response({'error': 'Review not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        

logger = logging.getLogger(__name__)

@api_view(['GET'])
def location(request):
    location_images_map = {}

    hotels = Hotel.objects.filter(status='Live')

    for hotel in hotels:
        logger.debug(f"Processing hotel: {hotel}")
        
        address_parts = hotel.address.split(',')
        if len(address_parts) >= 2:
            city = address_parts[-2].strip()
        else:
            city = hotel.address.strip()  # Nếu không thể tách, dùng địa chỉ gốc

        # Nhóm các khách sạn theo thành phố
        if city not in location_images_map:
            location_images_map[city] = []
        # Lấy danh sách hình ảnh của khách sạn từ bảng HotelGallery
        hotel_gallery_images = HotelGallery.objects.filter(hotel=hotel)

        # Xử lý khi danh sách hình ảnh trống
        if hotel_gallery_images.exists():
            if len(hotel_gallery_images) >= 3:
                image_path = hotel_gallery_images[2].image.url
            else:
                image_path = hotel_gallery_images[0].image.url
            full_image_url = request.build_absolute_uri(image_path)
        else:
            logger.debug(f"Hotel {hotel} has no images, returning null.")
            full_image_url = None  # Trả về null nếu không có ảnh

        # Thêm ảnh vào danh sách ảnh của địa chỉ
        location_images_map[city].append(full_image_url)

    # Chuẩn bị dữ liệu trả về
    response_data = []
    for location, image_paths in location_images_map.items():
        response_data.append({
            'location': location,
            'imageLocationList': [{'imagePath': image_path} for image_path in image_paths]
        })
    
    return Response(response_data)

@api_view(['POST'])
def search_hotel_by_location_name(request):
    location = request.data.get('location', '').strip()
    name = request.data.get('name', '').strip()

    # Tạo bộ lọc dựa trên location và name
    filters = {}
    if location:
        filters['address__icontains'] = location  # Dùng icontains để tìm kiếm không phân biệt hoa thường
    if name:
        filters['name__icontains'] = name

    # Lấy các khách sạn khớp với bộ lọc
    hotels = Hotel.objects.filter(**filters)

    # Serialize kết quả và trả về
    serializer = HotelSerializer(hotels, many=True, context={'request': request})
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([AllowAny])
def get_public_coupon(request):
    try:
        # Retrieve active and public coupons
        coupons = Coupon.objects.filter(active=True, make_public=True)
        
        # Check if there are coupons available
        if not coupons.exists():
            return Response(
                {'message': 'No public coupons available.'}, 
                status=status.HTTP_404_NOT_FOUND
            )

        # Serialize the data
        serializer = CouponSerializer(coupons, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    except Exception as e:
        # Log the error and return a generic error response
        return Response(
            {'error': 'An error occurred while fetching public coupons.', 'details': str(e)},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )
