from django.shortcuts import render
from hotel.models import  Hotel, Room, Booking, HotelGallery, HotelFeatures, RoomType
# Create your views here.
def index(request):
    hotels = Hotel.objects.filter(status="Live")
    context = {
        "hotel":hotels
    }
    return render(request, "hotel/hotel.html", context)

