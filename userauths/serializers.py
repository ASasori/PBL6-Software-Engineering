# userauths/serializers.py

from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Profile
User = get_user_model()

class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = Profile
        fields = ['image', 'full_name', 'phone', 'gender', 'country', 'city', 'state', 'address', 'indentity_type', 'indentity_image', 'facebook', 'twitter']

    def validate_image(self, value):
        # Kiểm tra định dạng file
        if not value.name.endswith(('.png', '.jpg', '.jpeg')):
            raise serializers.ValidationError("Only PNG and JPEG images are allowed for avatar.")
        
        # Kiểm tra kích thước file
        max_size = 5 * 1024 * 1024  # 5 MB
        if value.size > max_size:
            raise serializers.ValidationError("Image file too large (max 5MB).")

        return value

    def validate_indentity_image(self, value):
        # Kiểm tra định dạng file
        if not value.name.endswith(('.png', '.jpg', '.jpeg')):
            raise serializers.ValidationError("Only PNG and JPEG images are allowed for identity images.")
        
        # Kiểm tra kích thước file
        max_size = 5 * 1024 * 1024  # 5 MB
        if value.size > max_size:
            raise serializers.ValidationError("Identity image file too large (max 5MB).")

        return value

    def update(self, instance, validated_data):
        # Chỉ cập nhật profile của chính mình
        request_user = self.context['request'].user
        if request_user != instance.user:
            raise serializers.ValidationError("You can only update your own profile.")

        # Cập nhật thông tin profile
        for attr, value in validated_data.items():
            setattr(instance, attr, value)

        if 'image' in validated_data:
            instance.image = validated_data.get('image', instance.image)
        
        if 'indentity_image' in validated_data:
            instance.indentity_image = validated_data.get('indentity_image', instance.indentity_image)
        
        instance.save()
        return instance
    
# User Serializer
class UserSerializer(serializers.ModelSerializer):
    # Thêm trường date từ Profile
    date_joined = serializers.DateTimeField(source='profile.date', read_only=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'full_name', 'phone', 'date_joined']
        extra_kwargs = {
            'password': {'write_only': True}  # Mật khẩu sẽ không được trả về trong phản hồi
        }

    def create(self, validated_data):
        # Tạo người dùng mới với mật khẩu được mã hóa
        profile_data = validated_data.pop('profile', {})  # Lấy dữ liệu từ profile nếu có
        user = User(
            username=validated_data['username'],
            email=validated_data['email'],
            full_name=validated_data['full_name'],
            phone=validated_data['phone'],
        )
        user.set_password(validated_data['password'])  # Sử dụng phương thức set_password để mã hóa mật khẩu
        user.save()
        
        # Tạo profile cho user
        Profile.objects.create(user=user, **profile_data)
        
        return user


# Login Serializer
class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)  # Đặt write_only cho mật khẩu

    def validate(self, attrs):
        email = attrs.get('email')
        password = attrs.get('password')
        
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            user = None
        
        if user is not None and user.check_password(password):
            attrs['user'] = user
        else:
            raise serializers.ValidationError("Invalid credentials")

        return attrs
