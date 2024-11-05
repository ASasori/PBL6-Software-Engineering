from rest_framework import status, viewsets, permissions, generics
from rest_framework.decorators import api_view, action
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from hotel.models import Hotel, Booking, ActivityLog, StaffOnDuty, Room, RoomType, Coupon, Notification
from .serializers import HotelSerializer, RoomTypeSerializer, RoomSerializer
from rest_framework.parsers import MultiPartParser
from rest_framework.permissions import IsAdminUser
from datetime import datetime
from django.conf import settings
import stripe
from django.urls import reverse
from django.middleware.csrf import get_token

def csrf_token(request):
    token = get_token(request)
    return JsonResponse({'csrfToken': token})

class HotelViewSet(viewsets.ModelViewSet):
    queryset = Hotel.objects.filter(status='Live')
    serializer_class = HotelSerializer
    lookup_field = 'slug'
    
    def get_queryset(self):
        queryset = self.queryset
        name = self.request.query_params.get('name', None)
        if name:
            queryset = queryset.filter(name__icontains=name)  # Tìm kiếm không phân biệt chữ hoa chữ thường
        return queryset

#Endpoint : Ẩn/hiện khách sạn ....
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