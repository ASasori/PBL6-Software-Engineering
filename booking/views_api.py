from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from hotel.models import Hotel, RoomType
from hotel.serializers import HotelSerializer, RoomTypeSerializer
from django.core.exceptions import ObjectDoesNotExist
from datetime import datetime


@api_view(['POST'])
def check_room_availability(request):
    try:
        hotel_id = request.data.get("hotel-id")
        checkin = request.data.get("checkin")
        checkout = request.data.get("checkout")
        adult = request.data.get("adult")
        children = request.data.get("children")
        room_type_slug = request.data.get("room-type")
        
        if not all([hotel_id, checkin, checkout, adult, children, room_type_slug]):
            return Response({"error": "Thiếu thông tin yêu cầu!"}, status=status.HTTP_400_BAD_REQUEST)

        hotel = Hotel.objects.get(id=hotel_id, status="Live")
        room_type = RoomType.objects.get(hotel=hotel, slug=room_type_slug)
    
        hotel_serializer = HotelSerializer(hotel)
        room_type_serializer = RoomTypeSerializer(room_type)
        
        return Response({
            "hotel": hotel_serializer.data,
            "room_type": room_type_serializer.data,
            "checkin": checkin,
            "checkout": checkout,
            "adult": adult,
            "children": children
        }, status=status.HTTP_200_OK)
    except Hotel.DoesNotExist:
        return Response({"error": "Khách sạn không tồn tại"}, status=status.HTTP_404_NOT_FOUND)
    except RoomType.DoesNotExist:
        return Response({"error": "Loại phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
@api_view(['GET'])
def booking_data(request, slug):
    try:
        hotel = Hotel.objects.get(status="Live", slug=slug)
        hotel_serializer = HotelSerializer(hotel)
        return Response(hotel_serializer.data, status=status.HTTP_200_OK)
    except ObjectDoesNotExist:
        return Response({"error": "Khách sạn không tồn tại"}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
@api_view(['POST'])
def add_to_selection(request):
    room_selection = {}
    
    room_selection[str(request.data.get('id'))] = {
        'hotel_id': request.data.get('hotel_id'),
        'hotel_name': request.data.get('hotel_name'),
        'room_name': request.data.get('room_name'),
        'room_price': request.data.get('room_price'),
        'number_of_beds': request.data.get('number_of_beds'),
        'room_number': request.data.get('room_number'),
        'room_type': request.data.get('room_type'),
        'room_id': request.data.get('room_id'),
        'checkin': request.data.get('checkin'),
        'checkout': request.data.get('checkout'),
        'adult': request.data.get('adult'),
        'children': request.data.get('children'),
    }
    
    try:
        selection_data = request.session.get('selection_data_obj', {})
        
        if str(request.data.get('id')) in selection_data:
            selection_data[str(request.data.get('id'))]['adult'] = int(room_selection[str(request.data.get('id'))]['adult'])
            selection_data[str(request.data.get('id'))]['children'] = int(room_selection[str(request.data.get('id'))]['children'])
        else:
            selection_data.update(room_selection)
        
        request.session['selection_data_obj'] = selection_data

    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    data = {
        "data": request.session['selection_data_obj'],
        'total_selected_items': len(request.session['selection_data_obj'])
    }
    
    return Response(data, status=status.HTTP_200_OK)

#Xoá toàn bộ dữ liệu chọn phòng trong session
@api_view(['DELETE'])
def delete_session(request):
    request.session.pop('selection_data_obj', None)
    return Response({"message": "Selection data has been deleted successfully."}, status=status.HTTP_204_NO_CONTENT)

#Xoá 1 phòng khỏi sanh sách lựa chọn
@api_view(['DELETE'])
def delete_selection(request):
    
    hotel_id = str(request.data.get('id'))
    
    if 'selection_data_obj' in request.session:
        if hotel_id in request.session['selection_data_obj']:
            del request.session['selection_data_obj'][hotel_id]
            
    total = 0
    total_days = 0
    room_count = 0
    adult = 0
    children = 0
    checkin = ""
    checkout = ""
    hotel = None
    
    if 'selection_data_obj' in request.session:
        for item in request.session['selection_data_obj'].values():
            id = int(item['hotel_id'])
            checkin = item["checkin"]
            checkout = item["checkout"]
            adult += int(item["adult"])
            children += int(item["children"])
            room_type_ = item["room_type"]

            hotel = Hotel.objects.get(id=id)
            room_type = RoomType.objects.get(id=room_type_)

            date_format = "%Y-%m-%d"
            checkin_date = datetime.strptime(checkin, date_format)
            checkout_date = datetime.strptime(checkout, date_format)
            time_difference = checkout_date - checkin_date
            total_days = time_difference.days

            room_count += 1
            days = total_days
            price = room_type.price

            room_price = price * room_count
            total = room_price * days
    
    # Tạo phản hồi JSON
    response_data = {
        "data": request.session.get('selection_data_obj', {}),
        "total_selected_items": len(request.session.get('selection_data_obj', {})),
        "total": total,
        "total_days": total_days,
        "adult": adult,
        "children": children,
        "checkin": checkin,
        "checkout": checkout,
        "hotel": hotel.name if hotel else None
    }

    return Response(response_data, status=status.HTTP_200_OK)