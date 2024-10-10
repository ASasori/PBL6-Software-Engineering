# userauths/serializers.py

from rest_framework import serializers
from django.contrib.auth import get_user_model, authenticate

User = get_user_model()

# User Serializer
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['email', 'password', 'full_name', 'phone']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        # Use create_user to ensure password hashing
        user = User.objects.create_user(
            email=validated_data['email'],
            password=validated_data['password'],  # Automatically hashed by create_user()
            full_name=validated_data['full_name'],
            phone=validated_data['phone']
        )
        return user

# Login Serializer
class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, data):
        # Authenticate the user using email and password
        user = authenticate(email=data['email'], password=data['password'])
        if user and user.is_active:
            return user
        raise serializers.ValidationError("Invalid email or password")
