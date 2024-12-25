from rest_framework import serializers
from .models import Hotel, RoomType, Room, Booking, Cart, CartItem, HotelGallery, Review
from taggit.serializers import TagListSerializerField

class HotelGallerySerializer(serializers.ModelSerializer):
    class Meta:
        model = HotelGallery
        fields = ['image']  # Add fields you want to expose

class ReviewSerializer(serializers.ModelSerializer):
    # room_type = serializers.SlugRelatedField(
    #     queryset=RoomType.objects.all(),
    #     slug_field='type'  # Trường 'type' của RoomType
    # )
    profile_image = serializers.CharField(source='user.profile.image.url', read_only=True) 
    email = serializers.CharField(source='user.email', read_only=True)
    hotel_name = serializers.CharField(source='hotel.name', read_only=True)
    class Meta:
        model = Review
        fields = ['id', 'hotel', 'profile_image', 'hotel_name', 'email', 'room_type', 'user', 'rating', 'review_text', 'date']
        read_only_fields = ['id', 'user', 'date']
        extra_kwargs = {
            'room_type': {'required': False}  # Không bắt buộc
        }

class HotelSerializer(serializers.ModelSerializer):
    hotel_gallery = HotelGallerySerializer(many=True, read_only=True) 
    reviews = ReviewSerializer(many=True, read_only=True)
    tags = TagListSerializerField()
    class Meta:
        model = Hotel
        fields = [
            'id', 'user', 'name', 'description', 'map_image', 'address', 'mobile',
            'email', 'status', 'tags', 'views', 'featured', 'hid', 'slug',
            'date', 'hotel_gallery', 'reviews'
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
    profile_image = serializers.CharField(source='user.profile.image.url', read_only=True) 
    hotel_name = serializers.CharField(source='hotel.name', read_only=True)
    room_type_name = serializers.CharField(source='room_type.type', read_only=True) 

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
