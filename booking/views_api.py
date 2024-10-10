from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from hotel.models import Hotel, RoomType
from datetime import datetime
from django.urls import reverse

@api_view(['POST'])
def check_room_availability(request):
    try:
        # Extract data from the request
        data = request.data
        hotel = Hotel.objects.get(status="Live", id=data['hotel_id'])
        room_type = RoomType.objects.get(hotel=hotel, slug=data['room_type'])

        # Parse checkin and checkout dates
        checkin = datetime.strptime(data['checkin'], '%Y-%m-%d')
        checkout = datetime.strptime(data['checkout'], '%Y-%m-%d')
        adult = data['adult']
        children = data['children']

        # Logic to handle room availability checks can be added here
        # For example, checking if rooms are available for the given dates

        # Generate the room detail URL as in the original view function
        room_type_url = reverse("hotel:room_type_detail", args=[hotel.slug, room_type.slug])
        url_with_params = f"{room_type_url}?hotel-id={data['hotel_id']}&checkin={data['checkin']}&checkout={data['checkout']}&adult={adult}&children={children}&room_type={room_type.slug}"

        # Return the URL and booking details in response
        return Response({
            'hotel': hotel.name,
            'room_type': room_type.name,
            'checkin': checkin.date(),
            'checkout': checkout.date(),
            'adult': adult,
            'children': children,
            'room_type_url': url_with_params  # URL with parameters for further action
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
            'room_name': data['room_name'],
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
