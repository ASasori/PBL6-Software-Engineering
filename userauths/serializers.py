# userauths/serializers.py

from rest_framework import serializers
from django.contrib.auth import get_user_model

User = get_user_model()

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'full_name', 'phone']
        extra_kwargs = {
            'password': {'write_only': True}  # Mật khẩu sẽ không được trả về trong phản hồi
        }

    def create(self, validated_data):
        # Tạo người dùng mới với mật khẩu được mã hóa
        user = User(
            username=validated_data['username'],
            email=validated_data['email'],
            full_name=validated_data['full_name'],
            phone=validated_data['phone'],
        )
        user.set_password(validated_data['password'])  # Sử dụng phương thức set_password để mã hóa mật khẩu
        user.save()
        return user

class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)  # Đặt write_only cho mật khẩu
