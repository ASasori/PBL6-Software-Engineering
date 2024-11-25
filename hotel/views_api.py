from django.http import JsonResponse
from rest_framework import status, viewsets, permissions, generics
from rest_framework.decorators import api_view, action
from rest_framework.permissions import AllowAny
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from hotel.models import Hotel, Booking, ActivityLog, StaffOnDuty, Room, RoomType, Coupon, Notification, Cart, CartItem, Review
from .serializers import HotelSerializer, RoomTypeSerializer, RoomSerializer, CartSerializer, CartItemSerializer, ReviewSerializer
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

class HotelViewSet(viewsets.ModelViewSet):
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

    @action(detail=False, methods=['GET'], url_path='get-or-create')
    def get_or_create_cart(self, request):
        cart, created = Cart.objects.get_or_create(user=request.user, is_active=True)
        serializer = CartSerializer(cart)
        return Response(serializer.data, status=200)
    
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
                    'item_cart_id': item.id
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

@api_view(['POST'])
def create_booking(request):
    try:
        # Retrieve data from the session
        if 'selection_data_obj' not in request.session:
            return Response({'error': 'No selected rooms found in session'}, status=status.HTTP_400_BAD_REQUEST)

        selection_data = request.session['selection_data_obj']
        # Assuming there's only one hotel selection in session
        hotel_data = next(iter(selection_data.values()))

        # Extract data from session
        hotel_id = hotel_data['hotel_id']
        room_ids = hotel_data['room_id']  # You may have to adjust this depending on how you store room IDs in the session
        check_in_date = hotel_data['checkin']
        check_out_date = hotel_data['checkout']
        num_adults = hotel_data['adult']
        num_children = hotel_data['children']
        room_type_slug = hotel_data['room_type']

        # You can still allow some data to be passed through the request body, like user details
        full_name = request.data.get('full_name')
        email = request.data.get('email')
        phone = request.data.get('phone')

        # Now use session data to create the booking
        hotel = Hotel.objects.get(id=hotel_id, status='Live')
        room_type = RoomType.objects.get(slug=room_type_slug, hotel=hotel)
        rooms = Room.objects.filter(room_type=room_type, id=room_ids, is_available=True)

        if not rooms:
            return Response({'error': 'No available rooms'}, status=status.HTTP_400_BAD_REQUEST)

        # Calculate total days
        total_days = (datetime.strptime(check_out_date, '%Y-%m-%d') - datetime.strptime(check_in_date, '%Y-%m-%d')).days

        # Create the booking
        booking = Booking.objects.create(
            hotel=hotel,
            room_type=room_type,
            check_in_date=check_in_date,
            check_out_date=check_out_date,
            total_days=total_days,
            num_adults=num_adults,
            num_children=num_children,
            full_name=full_name,
            email=email,
            phone=phone
        )

        for room in rooms:
            booking.room.add(room)

        booking.save()

        return Response({'message': 'Booking created successfully'}, status=status.HTTP_201_CREATED)

    except (Hotel.DoesNotExist, RoomType.DoesNotExist):
        return Response({'error': 'Invalid hotel or room type'}, status=status.HTTP_400_BAD_REQUEST)


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
    try:
        booking = Booking.objects.get(booking_id=booking_id)
        stripe.api_key = settings.STRIPE_SECRET_KEY

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
            success_url=request.build_absolute_uri(reverse('api:payment_success', args=[booking.booking_id])) + "?session_id={CHECKOUT_SESSION_ID}",
            cancel_url=request.build_absolute_uri(reverse('api:payment_failed', args=[booking.booking_id])),
        )

        booking.payment_status = "processing"
        booking.stripe_payment_intent = checkout_session['id']
        booking.save()

        return Response({'sessionId': checkout_session.id}, status=status.HTTP_200_OK)

    except Booking.DoesNotExist:
        return Response({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
def payment_success(request, booking_id):
    session_id = request.GET.get('session_id')
    booking = get_object_or_404(Booking, booking_id=booking_id)

    if booking.stripe_payment_intent == session_id and booking.payment_status == "processing":
        booking.payment_status = "paid"
        booking.save()
        return Response({'message': 'Payment successful'}, status=status.HTTP_200_OK)
    return Response({'error': 'Payment verification failed'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def payment_failed(request, booking_id):
    booking = get_object_or_404(Booking, booking_id=booking_id)
    booking.payment_status = "failed"
    booking.save()
    return Response({'message': 'Payment failed'}, status=status.HTTP_200_OK)


class ReviewViewSet(viewsets.ViewSet):
    """
    A ViewSet for handling Reviews.
    """
    queryset = Review.objects.all()
    serializer_class = ReviewSerializer

    @swagger_auto_schema(
        operation_description="Create a new review",
        request_body=ReviewSerializer,  # Specify the serializer here
        responses={201: ReviewSerializer}  # Define the response schema
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

    @action(detail=True, methods=['get'], url_path='hotel-reviews')
    def get_reviews_by_hotel(self, request, pk=None):
        """Fetch all reviews for a specific hotel."""
        try:
            hotel = Hotel.objects.get(hid=pk)
            #hotel = get_object_or_404(Hotel, hid=pk)
            reviews = Review.objects.filter(hotel=hotel)
            serializer = ReviewSerializer(reviews, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Hotel.DoesNotExist:
            return Response({'error': 'Hotel not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)