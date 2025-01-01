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
from django.contrib.auth.tokens import default_token_generator
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.utils.encoding import force_bytes
from django.template.loader import render_to_string
from django.core.mail import send_mail
from django.conf import settings
from .serializers import UserSerializer, LoginSerializer, ProfileSerializer, ReceptionistSerializer
from .models import Profile, Receptionist
from rest_framework import status, viewsets, permissions


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
    
    print(serializer.errors) 
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



@api_view(['POST'])
@permission_classes([AllowAny])
def send_reset_password_email(request):
    """
    API to send a reset password link to the user's email.
    """
    email = request.data.get('email')
    if not email:
        return Response({'error': 'Email is required'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        user = User.objects.get(email=email)
    except User.DoesNotExist:
        return Response({'error': 'No account associated with this email.'}, status=status.HTTP_404_NOT_FOUND)

    # Generate reset link
    token = default_token_generator.make_token(user)
    uid = urlsafe_base64_encode(force_bytes(user.pk))
    reset_url = f"{settings.FRONTEND_URL}/reset-password/{uid}/{token}/"

    # Send email
    subject = "Reset Your Password"
    # message = render_to_string('reset_password_email.html', {
    #     'user': user,
    #     'reset_url': reset_url
    # })

    message = f"""
    Hello {user.first_name},

    You requested to reset your password. Click the link below to reset it:

    {reset_url}

    If you did not request a password reset, please ignore this email.

    Regards,
    Hotel Management System
    """

    send_mail(subject, message, settings.DEFAULT_FROM_EMAIL, [user.email])

    return Response({'message': 'Reset password email has been sent.'}, status=status.HTTP_200_OK)

@api_view(['POST'])
@permission_classes([AllowAny])
def reset_password(request, uidb64, token):
    """
    API to reset the password using the token and user ID.
    """
    new_password = request.data.get('new_password')
    if not new_password:
        return Response({'error': 'New password is required'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        uid = force_bytes(urlsafe_base64_decode(uidb64))
        user = User.objects.get(pk=uid)
    except (TypeError, ValueError, OverflowError, User.DoesNotExist):
        return Response({'error': 'Invalid token or user ID.'}, status=status.HTTP_400_BAD_REQUEST)

    if not default_token_generator.check_token(user, token):
        return Response({'error': 'Invalid or expired token.'}, status=status.HTTP_400_BAD_REQUEST)

    # Set new password
    user.set_password(new_password)
    user.save()

    return Response({'message': 'Password has been reset successfully.'}, status=status.HTTP_200_OK)
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

@api_view(['PATCH'])
@permission_classes([IsAuthenticated])
def edit_profile_view(request):
    """
    API to partially update a user's profile.
    """
    user = request.user
    profile, _ = Profile.objects.get_or_create(user=user)

    # Validate input fields
    allowed_fields = ['full_name', 'phone', 'gender', 'country', 'city', 'state', 'address']
    for field, value in request.data.items():
        if field in allowed_fields:
            setattr(profile, field, value)

     # Update files
    profile.image = request.FILES.get('image', profile.image)
    profile.indentity_image = request.FILES.get('indentity_image', profile.indentity_image)

    profile.save()

    serializer = ProfileSerializer(profile)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['PATCH'])
@permission_classes([IsAuthenticated])
def change_password_view(request):
    """
    API to change a user's password.
    """
    user = request.user
    old_password = request.data.get('old_password')
    new_password = request.data.get('new_password')

    if not old_password or not new_password:
        return Response({'error': 'Both old and new passwords are required.'}, status=status.HTTP_400_BAD_REQUEST)

    if not user.check_password(old_password):
        return Response({'error': 'Incorrect old password.'}, status=status.HTTP_400_BAD_REQUEST)

    if len(new_password) < 8:  # Example password validation
        return Response({'error': 'New password must be at least 8 characters long.'}, status=status.HTTP_400_BAD_REQUEST)

    user.set_password(new_password)
    user.save()

    return Response({'message': 'Password changed successfully.'}, status=status.HTTP_200_OK)

@api_view(['POST'])
@permission_classes([AllowAny])
def send_contact_email(request):
    try:
        # Extract data from the request
        email = request.data.get('email')
        message = request.data.get('message')

        # Validate the input
        if not email or not message:
            return Response({'error': 'Email and message are required'}, status=status.HTTP_400_BAD_REQUEST)

        # Prepare the email
        subject = "Customer Contact Form Submission"
        admin_email = "minamisasori28@gmail.com"  # Replace with your admin email
        email_message = (
            f"You have received a new message from a customer:\n\n"
            f"Email: {email}\n"
            f"Message:\n{message}"
        )

        # Send the email
        send_mail(
            subject=subject,
            message=email_message,
            from_email="no-reply@yourcompany.com",  # Replace with your no-reply email
            #from_email=email,
            recipient_list=[admin_email],
            fail_silently=False,
        )

        # Send success response
        return Response({'message': 'Your message has been sent successfully!'}, status=status.HTTP_200_OK)

    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class ReceptionistViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = ReceptionistSerializer
    permission_classes = [AllowAny]
    def get_receptionist_by_hotel(self, request, hotel_id=None):
        try:
            receptionist = Receptionist.objects.get(hotel__id=hotel_id)
            serializer = self.get_serializer(receptionist)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Receptionist.DoesNotExist:
            return Response({'error': 'Receptionist not found for the specified hotel.'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
