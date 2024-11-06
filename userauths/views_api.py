# userauths/views_api.py
from rest_framework import status
from rest_framework_simplejwt.tokens import AccessToken, RefreshToken
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth import get_user_model
from .serializers import UserSerializer, LoginSerializer

User = get_user_model()

# @api_view(['POST'])
# @permission_classes([AllowAny]) 
# def register_view(request):
#     print("Received request at register_view")
#     serializer = UserSerializer(data=request.data)
#     if serializer.is_valid():
#         user = serializer.save()
#         token, created = Token.objects.get_or_create(user=user)
#         return Response({'token': token.key}, status=status.HTTP_201_CREATED)
#     print(serializer.errors)  # In ra lỗi
#     return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

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
            
            return Response({
                'refresh': str(refresh_token),
                'access': str(access_token),
                'role': user.role  # Nếu bạn có thuộc tính role trong model User
            }, status=status.HTTP_200_OK)
        
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)
    
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# @api_view(['POST'])
# @permission_classes([AllowAny])  # Cho phép truy cập không cần xác thực
# def login_view(request):
#     username = request.data.get('username')
#     password = request.data.get('password')

#     if username is None or password is None:
#         return Response({'error': 'Please provide both username and password.'}, status=status.HTTP_400_BAD_REQUEST)

#     user = authenticate(username=username, password=password)
    
#     if user is not None:
#         access_token = AccessToken.for_user(user)
#         refresh_token = RefreshToken.for_user(user)
        
#         return Response({
#             'refresh': str(refresh_token),
#             'access': str(access_token),
#         }, status=status.HTTP_200_OK)
    
#     return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

@api_view(['POST'])
def logout_view(request):
    request.user.auth_token.delete()
    logout(request)
    return Response({'message': 'Logged out successfully'}, status=status.HTTP_200_OK)

