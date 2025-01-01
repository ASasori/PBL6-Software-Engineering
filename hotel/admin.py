from django.contrib import admin
from hotel.models import Hotel, Booking, ActivityLog, StaffOnDuty, Room, RoomType, HotelGallery, Coupon, Review
from userauths.models import User, Receptionist

class HotelGalleryInline(admin.TabularInline):
    model = HotelGallery

class HotelAdmin(admin.ModelAdmin):
    inlines = [HotelGalleryInline]
    list_display = ['name', 'user', 'status']
    prepopulated_fields = {"slug": ("name", )}

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "user":
            kwargs["queryset"] = User.objects.filter(role="Receptionist")  # Chỉ lấy user có role là Receptionist
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def save_model(self, request, obj, form, change):
        # Gọi phương thức save của Hotel
        super().save_model(request, obj, form, change)

        # Cập nhật hotel của Receptionist nếu có
        if obj.user:
            receptionist = Receptionist.objects.filter(user=obj.user).first()
            if receptionist:
                receptionist.hotel = obj  # Gán hotel cho Receptionist
                receptionist.save()

        # Đảm bảo Receptionist không bị gán vào khách sạn khác
        Receptionist.objects.filter(hotel=obj).exclude(user=obj.user).update(hotel=None)

class RoomTypeAdmin(admin.ModelAdmin):
    list_display = ['type', 'hotel', 'price', 'room_capacity', 'slug']
    prepopulated_fields = {"slug": ("type", )}

class RoomAdmin(admin.ModelAdmin):
    list_display = ['hotel', 'room_type', 'room_number', 'is_available', 'rid', 'date']
    
    # def formfield_for_foreignkey(self, db_field, request, **kwargs):
    #     if db_field.name == "room_type":
           
    #         hotel_id = request.GET.get('hotel')
        
    #         if not hotel_id and request.resolver_match.kwargs.get('object_id'):
    #             room = self.get_object(request, request.resolver_match.kwargs.get('object_id'))
    #             if room and room.hotel:
    #                 hotel_id = room.hotel.id
    #             print("test"+hotel_id)
    #     # Nếu hotel_id đã được xác định, lọc RoomType theo hotel
    #         if hotel_id:
    #             kwargs["queryset"] = RoomType.objects.filter(hotel_id=hotel_id)
    #         else:
    #             kwargs["queryset"] = RoomType.objects.none()  # Không có RoomType nào nếu không có hotel
    #             print("None hotel")
    #     return super().formfield_for_foreignkey(db_field, request, **kwargs)
class ReviewAdmin(admin.ModelAdmin):
    list_display = ['id', 'hotel', 'user', 'rating', 'review_text', 'date']
    list_filter = ['hotel', 'rating', 'date']
    search_fields = ['user__username', 'hotel__name', 'review_text']
    ordering = ['-date']  # Sắp xếp theo thời gian tạo mới nhất

    def get_queryset(self, request):
        queryset = super().get_queryset(request)
        return queryset.select_related('hotel', 'user')  # Tối ưu hóa truy vấn

class BookingAdmin(admin.ModelAdmin):
    list_display = ['hotel', 'get_room_numbers', 'user', 'check_in_date', 'check_out_date', 'payment_status', 'date']
    list_filter = ['hotel', 'payment_status', 'date']
    ordering = ['-date']

    def get_queryset(self, request):
        queryset = super().get_queryset(request)
        return queryset.select_related('hotel', 'user').prefetch_related('room')

    def get_room_numbers(self, obj):
        return ", ".join([str(room.room_number) for room in obj.room.all()])
    get_room_numbers.short_description = 'Room Numbers'

# Đăng ký các model
admin.site.register(Hotel, HotelAdmin)
admin.site.register(Booking, BookingAdmin)
admin.site.register(ActivityLog)
admin.site.register(StaffOnDuty)
admin.site.register(Room, RoomAdmin)
admin.site.register(RoomType, RoomTypeAdmin)
admin.site.register(Coupon)
admin.site.register(Review, ReviewAdmin)
