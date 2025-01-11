from django.contrib import admin
from hotel.models import Hotel, Booking, ActivityLog, StaffOnDuty, Room, RoomType, HotelGallery, Coupon, Review
from userauths.models import User, Receptionist
from django.db.models import Sum
from django.urls import path
from django.template.response import TemplateResponse
from django.shortcuts import render
import json
from django.views import View

class HotelGalleryInline(admin.TabularInline):
    model = HotelGallery

class HotelAdmin(admin.ModelAdmin):
    inlines = [HotelGalleryInline]
    list_display = ['name', 'user', 'status', 'total_bookings', 'total_revenue']
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
    def total_bookings(self, obj):
        return Booking.objects.filter(hotel=obj).count()
    total_bookings.short_description = "Total Bookings"

    def total_revenue(self, obj):
        revenue = Booking.objects.filter(hotel=obj).aggregate(total=Sum('total'))
        return revenue['total'] or 0  # Trả về 0 nếu không có doanh thu
    total_revenue.short_description = "Total Revenue (USD)"

class RoomTypeAdmin(admin.ModelAdmin):
    list_display = ['type', 'hotel', 'price', 'room_capacity', 'slug']
    prepopulated_fields = {"slug": ("type", )}

class RoomAdmin(admin.ModelAdmin):
    list_display = ['hotel', 'room_type', 'room_number', 'is_available', 'rid', 'date']
    
    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "room_type":
           
            hotel_id = request.GET.get('hotel')
        
            if not hotel_id and request.resolver_match.kwargs.get('object_id'):
                room = self.get_object(request, request.resolver_match.kwargs.get('object_id'))
                if room and room.hotel:
                    hotel_id = room.hotel.id
                print("test"+hotel_id)
        # Nếu hotel_id đã được xác định, lọc RoomType theo hotel
            if hotel_id:
                kwargs["queryset"] = RoomType.objects.filter(hotel_id=hotel_id)
            else:
                kwargs["queryset"] = RoomType.objects.none()  # Không có RoomType nào nếu không có hotel
                print("None hotel")
        return super().formfield_for_foreignkey(db_field, request, **kwargs)
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
    actions = ['export_booking_stats']

    def export_booking_stats(self, request, queryset):
        from django.http import HttpResponse
        import csv

        # Xuất dữ liệu ra file CSV
        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="booking_stats.csv"'

        writer = csv.writer(response)
        writer.writerow(['Hotel', 'Total Bookings', 'Total Revenue (USD)'])

        # Thống kê dữ liệu
        for hotel in Hotel.objects.all():
            total_bookings = Booking.objects.filter(hotel=hotel).count()
            total_revenue = Booking.objects.filter(hotel=hotel).aggregate(total=Sum('payment_status__amount'))['total'] or 0
            writer.writerow([hotel.name, total_bookings, total_revenue])

        return response

    export_booking_stats.short_description = "Export Booking Statistics"



class StatisticAdminView(View):
    def get(self, request, *args, **kwargs):
        hotels = Hotel.objects.all()
        labels = [hotel.name for hotel in hotels]
        total_revenues = [
            float(Booking.objects.filter(hotel=hotel).aggregate(total=Sum('total'))['total'] or 0)
            for hotel in hotels
        ]
        total_bookings = [
            Booking.objects.filter(hotel=hotel).count()
            for hotel in hotels
        ]

        context = {
            "labels": json.dumps(labels),
            "total_revenues": json.dumps(total_revenues),
            "total_bookings": json.dumps(total_bookings),
        }
        return render(request, "admin/statistics.html", context)

    
class MyAdminSite(admin.AdminSite):
    site_header = "Hotel Management System Admin"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._custom_views = {}  # To store custom views

    def register_view(self, name, view):
        from django.urls import path
        self._custom_views[name] = view
        self.get_urls = self.get_urls_override

    def get_urls_override(self):
        from django.urls import path
        original_urls = super().get_urls()
        custom_urls = [
            path(name, self.admin_view(view), name=name)
            for name, view in self._custom_views.items()
        ]
        return custom_urls + original_urls

# Đăng ký các model
admin.site.register(Hotel, HotelAdmin)
admin.site.register(Booking, BookingAdmin)
admin.site.register(ActivityLog)
admin.site.register(StaffOnDuty)
admin.site.register(Room, RoomAdmin)
admin.site.register(RoomType, RoomTypeAdmin)
admin.site.register(Coupon)
admin.site.register(Review, ReviewAdmin)
# admin.site.register(StatisticAdminView)
admin_site = MyAdminSite(name="admin")
admin_site.register_view("statistics", view=StatisticAdminView.as_view())
