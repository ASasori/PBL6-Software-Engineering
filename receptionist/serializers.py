from rest_framework import serializers
from hotel.models import Room, RoomType

class RoomTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = RoomType
        fields = ['id', 'type', 'price', 'number_of_beds', 'room_capacity', 'rtid', 'slug']
        read_only_fields = ['hotel']

    # def validate(self, data):
    #     # Kiểm tra xem loại phòng đã tồn tại hay chưa
    #     if RoomType.objects.filter(type=data['type'], hotel=data['hotel']).exists():
    #         raise serializers.ValidationError("A room type with this name already exists for this hotel.")
    #     return data

    def create(self, validated_data):
        # Lấy hotel từ request context
        user = self.context['request'].user
        print(f"User: {user}, Role: {user.role}")

        if hasattr(user, 'receptionist') and user.receptionist.hotel:
            hotel = user.receptionist.hotel
            validated_data['hotel'] = hotel
        else:
            raise serializers.ValidationError("User is not a receptionist or doesn't have an associated hotel.")

        return super().create(validated_data)

class RoomSerializer(serializers.ModelSerializer):

    room_type=RoomTypeSerializer(read_only=True)

    class Meta:
        model = Room
        fields = '__all__'

    def validate(self, data):
        user = self.context['request'].user
        print(f"User: {user}, Role: {user.role if hasattr(user, 'role') else 'No Role'}")

        if hasattr(user, 'receptionist'):
            hotel = user.receptionist.hotel
            if 'room_number' in data and 'room_type' in data:
                if Room.objects.filter(room_number=data['room_number'], room_type=data['room_type'], hotel=hotel).exists():
                    raise serializers.ValidationError("A room with this number and type already exists in this hotel.")
        else:
            raise serializers.ValidationError("User is not a receptionist or doesn't have an associated hotel.")

        return data


