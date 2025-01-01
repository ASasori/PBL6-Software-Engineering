from rest_framework import serializers
from .models import Hotel, RoomType, Room, Booking, Cart, CartItem, HotelGallery, Review, Coupon
from taggit.serializers import TagListSerializerField
from django.db.models import Min, Max, Avg, Count

class HotelGallerySerializer(serializers.ModelSerializer):
    class Meta:
        model = HotelGallery
        fields = ['image']  # Add fields you want to expose

class ReviewSerializer(serializers.ModelSerializer):
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
    #reviews = ReviewSerializer(many=True, read_only=True)
    tags = TagListSerializerField()
    price_min = serializers.SerializerMethodField()
    price_max = serializers.SerializerMethodField()
    review_count = serializers.SerializerMethodField()
    average_rating = serializers.SerializerMethodField()

    class Meta:
        model = Hotel
        fields = [
            'id', 'user', 'name', 'description', 'map_image', 'address', 'mobile',
            'email', 'status', 'tags', 'views', 'featured', 'hid', 'slug',
            'date', 'hotel_gallery',  'review_count', 'average_rating', 'price_min', 'price_max'
        ]

    def get_price_min(self, obj):
        return RoomType.objects.filter(hotel=obj).aggregate(Min('price'))['price__min'] or 0.00

    def get_price_max(self, obj):
        return RoomType.objects.filter(hotel=obj).aggregate(Max('price'))['price__max'] or 0.00
    
    def get_review_count(self, obj):
        return Review.objects.filter(hotel=obj).count()

    def get_average_rating(self, obj):
        return Review.objects.filter(hotel=obj).aggregate(Avg('rating'))['rating__avg'] or 0.00

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

class CouponSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coupon
        fields = '__all__'
        read_only_fields = ['user']
