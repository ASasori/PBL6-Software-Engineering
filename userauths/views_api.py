# userauths/views_api.py
from datetime import datetime, timedelta
from django.conf import settings
from rest_framework import status
from rest_framework_simplejwt.tokens import AccessToken, RefreshToken
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth import get_user_model
from .serializers import UserSerializer, LoginSerializer, ProfileSerializer
from .models import Profile

User = get_user_model()


@api_view(['POST'])
@permission_classes([AllowAny])  
def register_view(request):
    print("Received request at register_view")
    serializer = UserSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        
        # Tạo access và refresh token
        access_token = AccessToken.for_user(user)
        refresh_token = RefreshToken.for_user(user)
        
        return Response({
            'refresh': str(refresh_token),
            'access': str(access_token),
        }, status=status.HTTP_201_CREATED)
    
    print(serializer.errors)  # In ra lỗi
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request):
    serializer = LoginSerializer(data=request.data)
    if serializer.is_valid():
        email = serializer.validated_data['email']
        password = serializer.validated_data['password']
        
        # Xác thực người dùng
        user = authenticate(email=email, password=password)
        if user:
            # Tạo access và refresh token
            access_token = AccessToken.for_user(user)
            refresh_token = RefreshToken.for_user(user)
            access_expiry = datetime.utcnow() + settings.SIMPLE_JWT['ACCESS_TOKEN_LIFETIME']
            refresh_expiry = datetime.utcnow() + settings.SIMPLE_JWT['REFRESH_TOKEN_LIFETIME']
            
            return Response({
                'refresh': str(refresh_token),
                'access': str(access_token),
                'access_expiry': access_expiry.isoformat(),  
                'refresh_expiry': refresh_expiry.isoformat(),
                'role': user.role  
            }, status=status.HTTP_200_OK)
        
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def logout_view(request):
    request.user.auth_token.delete()
    logout(request)
    return Response({'message': 'Logged out successfully'}, status=status.HTTP_200_OK)

@api_view(['GET'])
def user_profile_view(request):
    try:
        profile = Profile.objects.get(user=request.user)
        user = request.user
        data = {
            "profile": {
                "full_name": profile.full_name,
                "image": profile.image.url if profile.image else None,
                "phone": profile.phone,
                "gender": profile.gender,
                "country": profile.country,
                "city": profile.city,
                "state": profile.state,
                "address": profile.address,
                "indentity_type": profile.indentity_type,
                "indentity_image": profile.indentity_image.url if profile.indentity_image else None,
                "wallet": profile.wallet,
                "verified": profile.verified,
                "date": profile.date,
            },
            "user": {
                "username": user.username,
                "email": user.email,
            }
        }
        return Response(data, status=status.HTTP_200_OK)
    except Profile.DoesNotExist:
        return Response({"detail": "Profile not found."}, status=status.HTTP_404_NOT_FOUND)


