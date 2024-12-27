from rest_framework import status
from rest_framework.response import Response
from datetime import datetime
from django.utils import timezone
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from .serializers import RoomSerializer, RoomTypeSerializer, BookingSerializer, CouponSerializer
from .permissions import IsReceptionist

from hotel.models import Room, RoomType, Hotel, Booking, Coupon
from userauths.models import Receptionist, Profile, User
from userauths.serializers import ProfileSerializer, UserSerializer

from django.middleware.csrf import get_token
from django.http import JsonResponse


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_receptionist_profile(request):
    try:
        # Lấy đối tượng user từ request.user
        user = request.user
        profile = user.profile  # Lấy profile liên kết với user
        
        # Sử dụng serializer để trả về thông tin profile
        serializer = ProfileSerializer(profile)
        return Response(serializer.data, status=status.HTTP_200_OK)
    except Profile.DoesNotExist:
        return Response({"error": "Không tìm thấy thông tin profile."}, status=status.HTTP_404_NOT_FOUND)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_info(request):
    try:
        user = request.user
        serializer = UserSerializer(user)

        return Response(serializer.data, status=status.HTTP_200_OK)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def change_password(request):
    user = request.user
    current_password = request.data.get("current_password")
    new_password = request.data.get("new_password")
    confirm_password = request.data.get("confirm_password")

    # Kiểm tra mật khẩu cũ
    if not user.check_password(current_password):
        return Response({"error": "Mật khẩu cũ không chính xác."}, status=status.HTTP_400_BAD_REQUEST)

    # Kiểm tra mật khẩu mới và xác nhận mật khẩu mới
    if new_password != confirm_password:
        return Response({"error": "Mật khẩu mới và xác nhận mật khẩu không trùng khớp."}, status=status.HTTP_400_BAD_REQUEST)

    # Đổi mật khẩu
    user.set_password(new_password)
    user.save()

    return Response({"message": "Mật khẩu đã được đổi thành công."}, status=status.HTTP_200_OK)

#Room management
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_room(request):
    try:
        receptionist = Receptionist.objects.get(user=request.user)
        
        if not receptionist.hotel:
            return Response({"error": "Receptionist chưa được liên kết với khách sạn."}, status=status.HTTP_400_BAD_REQUEST)
        
        hotel = receptionist.hotel
        data = request.data

        room_number = data.get('room_number')
        room_type_id = data.get('room_type')
        is_available = data.get('is_available', True)

        if not room_type_id:
            return Response({"error": "room_type không được để trống."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            room_type = RoomType.objects.get(id=room_type_id, hotel=hotel)
        except RoomType.DoesNotExist:
            return Response({"error": "Loại phòng không tồn tại."}, status=status.HTTP_404_NOT_FOUND)

        # Kiểm tra trùng số phòng trong cùng khách sạn
        if Room.objects.filter(room_number=room_number, hotel=hotel).exists():
            return Response({"error": "Phòng với số phòng này đã tồn tại trong khách sạn."}, status=status.HTTP_400_BAD_REQUEST)

        # Kiểm tra trùng số phòng và loại phòng
        if Room.objects.filter(room_number=room_number, room_type=room_type, hotel=hotel).exists():
            return Response({"error": "Phòng với số phòng và loại phòng này đã tồn tại trong khách sạn."}, status=status.HTTP_400_BAD_REQUEST)

        # Tạo phòng mới nếu không có trùng lặp
        new_room = Room(
            room_number=room_number,
            room_type=room_type,
            hotel=hotel,
            is_available=is_available
        )

        new_room.save()
        serializer = RoomSerializer(new_room)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    except Receptionist.DoesNotExist:
        return Response({"error": "Không tìm thấy lễ tân."}, status=status.HTTP_404_NOT_FOUND)

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
def update_room(request, rid):
    try:
        room = Room.objects.get(rid=rid, hotel=request.user.receptionist.hotel)
    except Room.DoesNotExist:
        return Response({"error": "Phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

    serializer = RoomSerializer(room, data=request.data, partial=True, context={'request': request})  # Đảm bảo context có 'request'
    
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
@permission_classes([IsAuthenticated, IsReceptionist])
def delete_room(request, rid):
    try:
        # Lấy đối tượng receptionist từ user
        receptionist = request.user.receptionist
        hotel = receptionist.hotel  # Lấy khách sạn từ receptionist

        room = Room.objects.get(rid=rid, hotel=hotel)
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
def get_customer(request, customer_id):
    try:
        customer = User.objects.get(id=customer_id, role='Customer')
        serializer = UserSerializer(customer)
        return Response(serializer.data, status=status.HTTP_200_OK)
    except User.DoesNotExist:
        return Response({"error": "Customer not found"}, status=status.HTTP_404_NOT_FOUND)
    
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

#fixx
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

        if check_in >= check_out:
            return Response({"error": "Check-out date must be after check-in date."}, status=status.HTTP_400_BAD_REQUEST)

        receptionist = getattr(request.user, 'receptionist', None)
        if not receptionist or not receptionist.hotel:
            return Response({"error": "User does not have valid receptionist permissions or is not linked to a hotel."}, status=status.HTTP_403_FORBIDDEN)

        hotel = receptionist.hotel

        unavailable_rooms = Booking.objects.filter(
            room__hotel=hotel,
            check_in_date__lt=check_out,
            check_out_date__gt=check_in
        ).values_list('room__id', flat=True)

        available_rooms = Room.objects.filter(hotel=hotel).exclude(id__in=unavailable_rooms).distinct()

        serializer = RoomSerializer(available_rooms, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    except ValueError:
        return Response({"error": "Invalid date format. Please use YYYY-MM-DD."}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

#fixx
@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def list_coupons(request):
    today = datetime.today().date() 
    coupons = Coupon.objects.filter(
        active=True, 
        valid_from__lte=today,
        valid_to__gte=today   
    )
    serializer = CouponSerializer(coupons, many=True)
    return Response(serializer.data)

@api_view(['POST'])
@permission_classes([IsAuthenticated, IsReceptionist])
def add_booking(request):
    try:
        receptionist = request.user.receptionist
        hotel = receptionist.hotel
    except AttributeError:
        return Response({"error": "Người dùng không phải là receptionist hoặc không có thông tin receptionist."}, status=400)
    
    if not hotel:
        return Response({"error": "Receptionist không được liên kết với khách sạn."}, status=400)
    
    user_id = request.data.get('user_id') 
    rooms_rid = request.data.get('rooms', [])
    coupon_cid = request.data.get('coupons', [])

    full_name = request.data.get('full_name')
    email = request.data.get('email')
    phone = request.data.get('phone')
    check_in_date = request.data.get('check_in_date')
    check_out_date = request.data.get('check_out_date')
    num_adults = request.data.get('num_adults', 1)
    num_children = request.data.get('num_children', 0)
    payment_intent = request.data.get('payment_intent')

    try:
        customer = User.objects.get(id=user_id, role='Customer') 
    except User.DoesNotExist:
        return Response({"error": "Customer không tồn tại hoặc không hợp lệ."}, status=400)

    check_in_date = datetime.strptime(check_in_date, '%Y-%m-%d').date()
    check_out_date = datetime.strptime(check_out_date, '%Y-%m-%d').date()

    total_days = (check_out_date - check_in_date).days

    if total_days <= 0:
        return Response({"error": "Ngày check-out phải sau ngày check-in."}, status=400)

    rooms = Room.objects.filter(rid__in=rooms_rid, hotel=hotel, is_available=True)
    if len(rooms) != len(rooms_rid):  
        return Response({"detail": "One or more rooms are not available."}, status=status.HTTP_400_BAD_REQUEST)

    coupons = Coupon.objects.filter(cid__in=coupon_cid, active=True)

    total_price = sum(room.price() * total_days for room in rooms)

    booking = Booking.objects.create(
        user=customer,
        full_name=full_name,
        email=email,
        phone=phone,
        hotel=hotel,
        check_in_date=check_in_date,
        check_out_date=check_out_date,
        num_adults=num_adults,
        num_children=num_children,
        stripe_payment_intent=payment_intent,
        total_days=total_days,
        before_discount=total_price,
        total=total_price,  
        saved=0,  
    )
    booking.room.set(rooms)

    if coupons.exists():
        booking.coupons.set(coupons)

    if coupons.exists():
        discount_amount = sum(coupon.discount for coupon in coupons)
        booking.saved = discount_amount
        booking.total = booking.before_discount - discount_amount
        booking.save()

    return Response({
        "detail": "Booking created successfully",
        "booking_id": booking.booking_id
    }, status=status.HTTP_201_CREATED)

@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def list_bookings(request):
    try:
        receptionist=request.user.receptionist
        hotel=receptionist.hotel
    except AttributeError:
        return Response({"error": "Người dùng không phải là receptionist hoặc không có thông tin receptionist."}, status=400)

    if not hotel:
        return Response({"error": "Receptionist không được liên kết với khách sạn."}, status=400)
    
    bookings = Booking.objects.filter(hotel=hotel)

    if not bookings:
        return Response({"detail": "Không có booking nào."}, status=status.HTTP_404_NOT_FOUND)

    serializer = BookingSerializer(bookings, many=True)
    
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['DELETE'])
@permission_classes([IsAuthenticated, IsReceptionist])
def delete_booking(request, booking_id):
    try:
        receptionist = request.user.receptionist
        hotel = receptionist.hotel
    except AttributeError:
        return Response({"error": "Người dùng không phải là receptionist hoặc không có thông tin receptionist."}, status=400)

    if not hotel:
        return Response({"error": "Receptionist không được liên kết với khách sạn."}, status=400)

    try:
        # Lấy đối tượng booking theo booking_id
        booking = Booking.objects.get(booking_id=booking_id, hotel=hotel)
    except Booking.DoesNotExist:
        return Response({"error": "Không tìm thấy booking hoặc booking không thuộc khách sạn này."}, status=404)

    # Xóa booking
    booking.delete()

    return Response({"detail": "Booking đã được xóa thành công."}, status=status.HTTP_204_NO_CONTENT)
