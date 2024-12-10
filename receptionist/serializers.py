from rest_framework import serializers
from hotel.models import Room, RoomType, Booking, Coupon

class RoomTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = RoomType
        fields = ['id', 'type', 'price', 'number_of_beds', 'room_capacity', 'rtid', 'slug']
        read_only_fields = ['hotel']

    def create(self, validated_data):
        user = self.context['request'].user
        print(f"User: {user}, Role: {user.role}")

        # Kiểm tra nếu user là receptionist và có khách sạn
        if hasattr(user, 'receptionist') and user.receptionist.hotel:
            hotel = user.receptionist.hotel
            validated_data['hotel'] = hotel
        else:
            raise serializers.ValidationError("User is not a receptionist or doesn't have an associated hotel.")

        return super().create(validated_data)


class RoomSerializer(serializers.ModelSerializer):
    room_type = RoomTypeSerializer(read_only=True)  # Giữ lại RoomType để trả về dữ liệu

    class Meta:
        model = Room
        fields = ['rid', 'room_number', 'room_type', 'is_available']  # Chỉ trả về số phòng và loại phòng

    def validate(self, data):
        user = self.context['request'].user
        print(f"User: {user}, Role: {user.role if hasattr(user, 'role') else 'No Role'}")

        # Kiểm tra nếu user là receptionist và có khách sạn liên kết
        if hasattr(user, 'receptionist'):
            hotel = user.receptionist.hotel
            if 'room_number' in data and 'room_type' in data:
                # Kiểm tra xem phòng với số phòng và loại phòng đã tồn tại trong khách sạn chưa
                if Room.objects.filter(room_number=data['room_number'], room_type=data['room_type'], hotel=hotel).exists():
                    raise serializers.ValidationError("A room with this number and type already exists in this hotel.")
        else:
            raise serializers.ValidationError("User is not a receptionist or doesn't have an associated hotel.")

        return data


class BookingSerializer(serializers.ModelSerializer):
    room = serializers.PrimaryKeyRelatedField(queryset=Room.objects.all(), many=True)
    coupon = serializers.PrimaryKeyRelatedField(queryset=Coupon.objects.all(), many=True, required=False)
    class Meta:
        model = Booking
        fields = '__all__'
    def create(self, validated_data):
        rooms_data = validated_data.pop('rooms',[])
        coupons_data = validated_data.pop('coupons', [])

        booking = Booking.objects.create(**validated_data)

        booking.room.set(rooms_data)

        booking.coupons.set(coupons_data)
        booking.save()

        return booking
    
class CouponSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coupon
        fields = '__all__'