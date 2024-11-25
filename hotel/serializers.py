from rest_framework import serializers
from .models import Hotel, RoomType, Room, Booking, Cart, CartItem, HotelGallery, Review
from taggit.serializers import TagListSerializerField

class HotelGallerySerializer(serializers.ModelSerializer):
    class Meta:
        model = HotelGallery
        fields = ['image']  # Add fields you want to expose


class HotelSerializer(serializers.ModelSerializer):
    hotel_gallery = HotelGallerySerializer(many=True, read_only=True) 
    tags = TagListSerializerField()
    class Meta:
        model = Hotel
        fields = [
            'user', 'name', 'description', 'map_image', 'address', 'mobile',
            'email', 'status', 'tags', 'views', 'featured', 'hid', 'slug',
            'date', 'hotel_gallery'  # Add hotel_gallery to fields
        ]

class RoomTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = RoomType
        fields = '__all__'

class RoomSerializer(serializers.ModelSerializer):
    class Meta:
        model = Room
        fields = '__all__'

class BookingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Booking
        fields = '__all__'

class CartSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cart
        fields = '__all__'

class CartItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = CartItem
        fields = '__all__'
        read_only_fields = ['cart']

class ReviewSerializer(serializers.ModelSerializer):
    # room_type = serializers.SlugRelatedField(
    #     queryset=RoomType.objects.all(),
    #     slug_field='type'  # Trường 'type' của RoomType
    # )
    class Meta:
        model = Review
        fields = ['id', 'hotel', 'room_type', 'user', 'rating', 'review_text', 'date']
        read_only_fields = ['id', 'user', 'date']
        extra_kwargs = {
            'room_type': {'required': False}  # Không bắt buộc
        }