from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from hotel.models import Room, RoomType
from .serializers import RoomSerializer, RoomTypeSerializer
from .permissions import IsReceptionist

#Room management
@api_view(['POST'])
@permission_classes([IsAuthenticated, IsReceptionist])
def create_room(request):
    serializer = RoomSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def list_rooms(request):
    rooms = Room.objects.all()
    serializer = RoomSerializer(rooms, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def get_room(request, room_id):
    try:
        room = Room.objects.get(pk=room_id)
    except Room.DoesNotExist:
        return Response({"error": "Phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)
    
    serializer = RoomSerializer(room)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['PUT', 'PATCH'])
@permission_classes([IsAuthenticated, IsReceptionist])
def update_room(request, room_id):
    try:
        room = Room.objects.get(pk=room_id)
    except Room.DoesNotExist:
        return Response({"error": "Phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

    serializer = RoomSerializer(room, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
@permission_classes([IsAuthenticated, IsReceptionist])
def delete_room(request, room_id):
    try:
        room = Room.objects.get(pk=room_id)
    except Room.DoesNotExist:
        return Response({"error": "Phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

    room.delete()
    return Response({"message": "Phòng đã xóa"}, status=status.HTTP_204_NO_CONTENT)

#Room type management
@api_view(['POST'])
@permission_classes([IsAuthenticated, IsReceptionist])
def create_room_type(request):
    serializer = RoomTypeSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def list_room_types(request):
    room_types = RoomType.objects.all()
    serializer = RoomTypeSerializer(room_types, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([IsAuthenticated, IsReceptionist])
def get_room_type(request, room_type_id):
    try:
        room_type = RoomType.objects.get(pk=room_type_id)
    except RoomType.DoesNotExist:
        return Response({"error": "Loại phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)
    
    serializer = RoomTypeSerializer(room_type)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['PUT', 'PATCH'])
@permission_classes([IsAuthenticated, IsReceptionist])
def update_room_type(request, room_type_id):
    try:
        room_type = RoomType.objects.get(pk=room_type_id)
    except RoomType.DoesNotExist:
        return Response({"error": "Loại phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

    serializer = RoomTypeSerializer(room_type, data=request.data, partial=True)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
@permission_classes([IsAuthenticated, IsReceptionist])
def delete_room_type(request, room_type_id):
    try:
        room_type = RoomType.objects.get(pk=room_type_id)
    except RoomType.DoesNotExist:
        return Response({"error": "Loại phòng không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

    room_type.delete()
    return Response({"message": "Loại phòng đã xóa"}, status=status.HTTP_204_NO_CONTENT)