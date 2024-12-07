from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status
from hotel.models import Hotel, RoomType, Booking, Room
from datetime import datetime
from django.urls import reverse
from django.db.models import Q
from django.utils import timezone

@api_view(['POST'])
@permission_classes([AllowAny])
def check_room_availability(request):
    try:
        # Extract data from the request
        data = request.data
        hotel = Hotel.objects.get(status="Live", slug=data['hotel_slug'])
        room_type = RoomType.objects.get(hotel=hotel, slug=data['room_type'])

        # Parse checkin and checkout dates
        checkin = datetime.strptime(data['checkin'], '%Y-%m-%d')
        checkout = datetime.strptime(data['checkout'], '%Y-%m-%d')
        adult = data['adult']
        children = data['children']
        total_guests = adult + children

        # Step 1: Get rooms of the selected type
        rooms = Room.objects.filter(room_type=room_type, is_available=True)

        # Step 2: Exclude rooms already booked for the given dates
        booked_rooms = Booking.objects.filter(
            room__in=rooms
        ).exclude(
            Q(check_out_date__lte=checkin) 
            | Q(check_in_date__gte=checkout)
            | Q(payment_status='paid')
        ).values_list('room', flat=True)
        available_rooms = rooms.exclude(id__in=booked_rooms)

        # Step 3: Check room capacity
        suitable_rooms = available_rooms.filter(room_type__room_capacity__gte=total_guests)

        # If no rooms are available after filtering
        if not suitable_rooms.exists():
            return Response({
                'message': 'No rooms available for the selected criteria.',
                'checkin': checkin.date(),
                'checkout': checkout.date(),
                'adults': adult,
                'children': children
            }, status=status.HTTP_404_NOT_FOUND)

        # Generate the room detail URL
        room_type_url = reverse("hotel:room_type_detail", args=[hotel.slug, room_type.slug])
        url_with_params = f"{room_type_url}?hotel_slug={data['hotel_slug']}&checkin={data['checkin']}&checkout={data['checkout']}&adult={adult}&children={children}&room_type={room_type.slug}" 

        # Return the room details
        return Response({
            'slug': hotel.slug,
            'hotel': hotel.name,
            'room_type': room_type.type,
            'checkin': checkin.date(),
            'checkout': checkout.date(),
            'adults': adult,
            'children': children,
            'room_type_url': url_with_params,
            'available_rooms': [
                {
                    "room_id": room.id,
                    'room_number': room.room_number,
                    'capacity': room.room_type.room_capacity,
                    'bed': room.room_type.number_of_beds,
                    'price': room.room_type.price
                } for room in suitable_rooms
            ]
        }, status=status.HTTP_200_OK)

    except Hotel.DoesNotExist:
        return Response({'error': 'Hotel not found'}, status=status.HTTP_404_NOT_FOUND)
    except RoomType.DoesNotExist:
        return Response({'error': 'Room type not found'}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def add_to_selection(request):
    try:
        data = request.data
        selection_data = request.session.get('selection_data_obj', {})

        room_selection = {
            'hotel_id': data['hotel_id'],
            'hotel_name': data['hotel_name'],
            'room_price': data['room_price'],
            'number_of_beds': data['number_of_beds'],
            'room_number': data['room_number'],
            'room_type': data['room_type'],
            'room_id': data['room_id'],
            'checkin': data['checkin'],
            'checkout': data['checkout'],
            'adult': data['adult'],
            'children': data['children'],
        }

        selection_data[str(data['id'])] = room_selection
        request.session['selection_data_obj'] = selection_data

        return Response({
            'selection': request.session['selection_data_obj'],
            'total_selected_items': len(request.session['selection_data_obj'])
        }, status=status.HTTP_200_OK)

    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['DELETE'])
def delete_selection(request):
    try:
        hotel_id = request.GET.get('id')
        if 'selection_data_obj' in request.session:
            selection_data = request.session['selection_data_obj']
            if hotel_id in selection_data:
                del selection_data[hotel_id]
                request.session['selection_data_obj'] = selection_data

        return Response({'message': 'Selection deleted'}, status=status.HTTP_200_OK)
    
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
def delete_session(request):
    try:
        request.session.pop('selection_data_obj', None)
        return Response({'message': 'Session deleted'}, status=status.HTTP_200_OK)
    
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)