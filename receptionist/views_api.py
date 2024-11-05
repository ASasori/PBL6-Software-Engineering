from rest_framework import status
from rest_framework.response import Response
from datetime import datetime
from django.utils import timezone
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from .serializers import RoomSerializer, RoomTypeSerializer
from .permissions import IsReceptionist

from hotel.models import Room, RoomType, Hotel, Booking
from userauths.models import Receptionist, Profile, User
from userauths.serializers import ProfileSerializer, UserSerializer

from django.middleware.csrf import get_token
from django.http import JsonResponse

#Room management
@api_view(['POST'])
@permission_classes([IsAuthenticated, IsReceptionist])
def create_room(request):
    try:
        receptionist = Receptionist.objects.get(user=request.user)

        if not receptionist.hotel:
            return Response({"error": "Lễ tân này chưa được liên kết với khách sạn."}, status=status.HTTP_400_BAD_REQUEST)
        
        hotel = receptionist.hotel
        data = request.data
        room_number = data.get('room_number')
        room_type_id = data.get('room_type') 

        if Room.objects.filter(room_number=room_number, room_type=room_type_id, hotel=hotel).exists():
            return Response({"error": "Phòng với số phòng này và loại phòng đã tồn tại."}, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            room_type = RoomType.objects.get(id=room_type_id, hotel=hotel) 
            data['room_type'] = room_type.id

        except RoomType.DoesNotExist:
            return Response({"error": "Loại phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)
        
        data['hotel'] = hotel.id

        serializer = RoomSerializer(data=data, context={'request': request})

        if serializer.is_valid():
            serializer.save()  # Lưu phòng mới
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    except Receptionist.DoesNotExist:
        return Response({"error": "Không tìm thấy Receptionist."}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def list_rooms(request):
    try:
        # Lấy đối tượng receptionist từ user
        receptionist = request.user.receptionist
        hotel = receptionist.hotel  # Lấy khách sạn từ receptionist
        rooms = Room.objects.filter(hotel=hotel)
        serializer = RoomSerializer(rooms, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    except Receptionist.DoesNotExist:
        return Response({"error": "Không tìm thấy Receptionist."}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def get_room(request, room_id):
    try:
        # Lấy đối tượng receptionist từ user
        receptionist = request.user.receptionist
        hotel = receptionist.hotel  # Lấy khách sạn từ receptionist

        room = Room.objects.get(pk=room_id, hotel=hotel)
    except Room.DoesNotExist:
        return Response({"error": "Phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)
    
    serializer = RoomSerializer(room)
    return Response(serializer.data, status=status.HTTP_200_OK)
@api_view(['PUT', 'PATCH'])
@permission_classes([IsAuthenticated, IsReceptionist])
def update_room(request, room_id):
    try:
        room = Room.objects.get(pk=room_id, hotel=request.user.receptionist.hotel)
    except Room.DoesNotExist:
        return Response({"error": "Phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

    serializer = RoomSerializer(room, data=request.data, partial=True, context={'request': request})  # Đảm bảo context có 'request'
    
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
@permission_classes([IsAuthenticated, IsReceptionist])
def delete_room(request, room_id):
    try:
        # Lấy đối tượng receptionist từ user
        receptionist = request.user.receptionist
        hotel = receptionist.hotel  # Lấy khách sạn từ receptionist

        room = Room.objects.get(pk=room_id, hotel=hotel)
    except Room.DoesNotExist:
        return Response({"error": "Phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

    room.delete()
    return Response({"message": "Phòng đã xóa"}, status=status.HTTP_204_NO_CONTENT)

#Room type management
@api_view(['POST'])
@permission_classes([IsAuthenticated, IsReceptionist])
def create_room_type(request):
    try:
        receptionist = request.user.receptionist
        hotel = receptionist.hotel

        room_type_name = request.data.get('type')

        if RoomType.objects.filter(type=room_type_name, hotel=hotel).exists():
            return Response({"error": "Loại phòng này đã tồn tại trong khách sạn."}, status=status.HTTP_400_BAD_REQUEST)

        serializer = RoomTypeSerializer(data=request.data, context={'request': request})

        if serializer.is_valid():
            serializer.save()  # Không cần truyền 'hotel' ở đây vì nó đã được xử lý trong serializer
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    except Receptionist.DoesNotExist:
        return Response({"error": "Người dùng không phải là Receptionist và không liên kết với khách sạn nào."}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def list_room_types(request):
    user = request.user
    room_types = RoomType.objects.filter(hotel__user=user)
    serializer = RoomTypeSerializer(room_types, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def get_room_type(request, room_type_id):
    user=request.user
    try:
        room_type = RoomType.objects.get(pk=room_type_id, hotel__user=user)
    except RoomType.DoesNotExist:
        return Response({"error": "Loại phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)
    
    serializer = RoomTypeSerializer(room_type)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['PUT', 'PATCH'])
@permission_classes([IsAuthenticated, IsReceptionist])
def update_room_type(request, room_type_id):
    user=request.user
    try:
        room_type = RoomType.objects.get(pk=room_type_id, hotel__user=user)
    except RoomType.DoesNotExist:
        return Response({"error": "Loại phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

    serializer = RoomTypeSerializer(room_type, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
@permission_classes([IsAuthenticated, IsReceptionist])
def delete_room_type(request, room_type_id):
    user=request.user
    try:
        room_type = RoomType.objects.get(pk=room_type_id, hotel__user=user)
        Room.objects.filter(room_type=room_type).delete()
        room_type.delete()

        return Response({"message": "Loại phòng và các phòng liên quan đã được xoá thành công."}, status=status.HTTP_204_NO_CONTENT)
    
    except RoomType.DoesNotExist:
        return Response({"error": "Loại phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    

#Profile
@api_view(['PUT', 'PATCH'])
@permission_classes([IsAuthenticated, IsReceptionist])
def update_profile(request):
    try:
        # Kiểm tra receptionist
        receptionist = Receptionist.objects.get(user=request.user)
        profile = receptionist.user.profile

        # Cập nhật profile
        serializer = ProfileSerializer(profile, data=request.data, partial=True, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        
        # Trả về lỗi nếu không hợp lệ
        return Response({"errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

    except Receptionist.DoesNotExist:
        return Response({"error": "Receptionist không tồn tại."}, status=status.HTTP_404_NOT_FOUND)
    
    # Không cần kiểm tra Profile.DoesNotExist ở đây
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

#customers
@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def list_customers(request):
    customers = User.objects.filter(role='Customer')
    serializer = UserSerializer(customers, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def customers_registered_today(request):
    today = timezone.now().date()
    # Tìm các User với vai trò 'Customer' được tạo trong ngày hôm nay
    customers_today = User.objects.filter(
        role='Customer',
        date_joined__date=today
    )

    serializer = UserSerializer(customers_today, many=True)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def list_available_rooms(request):
    check_in_date = request.query_params.get('check_in_date')
    check_out_date = request.query_params.get('check_out_date')

    if not check_in_date or not check_out_date:
        return Response({"error": "Check-in and check-out dates are required."}, status=status.HTTP_400_BAD_REQUEST)

    try:
        check_in = datetime.strptime(check_in_date, "%Y-%m-%d").date()
        check_out = datetime.strptime(check_out_date, "%Y-%m-%d").date()

        receptionist = request.user.receptionist
        hotel = receptionist.hotel

        rooms = Room.objects.filter(hotel=hotel)

        unavailable_rooms = Booking.objects.filter(
            hotel=hotel,
            check_in_date__lt=check_out,
            check_out_date__gt=check_in
        ).values_list('room__id', flat=True)

        available_rooms = rooms.exclude(id__in=unavailable_rooms).distinct()

        serializer = RoomSerializer(available_rooms, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    except ValueError:
        return Response({"error": "Invalid date format. Please use YYYY-MM-DD."}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

def get_csrf_token(request):

    csrf_token = get_token(request)
    print(csrf_token)
    return JsonResponse({'csrfToken': csrf_token})

