from django.contrib import admin
from django.db import transaction
from django.contrib import messages
from userauths.models import User, Profile, Receptionist, Customer

# Register your models here.
class UserAdmin(admin.ModelAdmin):
    search_fields = ['full_name', 'username']
    list_display = ['username', 'full_name', 'email', 'phone', 'gender', 'role']

    def save_model(self, request, obj, form, change):
        old_role = User.objects.get(pk=obj.pk).role if obj.pk else None
        print(f"Vai trò trước khi thay đổi: {old_role}")
        super().save_model(request, obj, form, change)
        new_role = obj.role
        print(f"Vai trò sau khi thay đổi: {new_role}")

        if old_role != new_role:
            if new_role == "Receptionist":
                # Xóa Customer nếu có
                Customer.objects.filter(user=obj).delete()
                receptionist, created = Receptionist.objects.get_or_create(user=obj)
                if created:
                    print(f"Tạo Receptionist mới cho người dùng: {obj.username}")
                else:
                    print(f"Receptionist đã tồn tại cho người dùng: {obj.username}")

            elif new_role == "Customer":
                # Tìm Receptionist hiện tại
                receptionist = Receptionist.objects.filter(user=obj).first()
                if receptionist:
                    print(f"Receptionist tồn tại cho người dùng: {obj.username}")

                    # Cập nhật hotel thành None
                    hotel = receptionist.hotel
                    if hotel:
                        print(f"Cập nhật user của hotel {hotel.name} thành None.")
                        hotel.user = None  # Đặt user thành None
                        hotel.save()  # Lưu lại thay đổi

                    receptionist.hotel = None  # Đặt hotel của Receptionist thành None
                    receptionist.save()  # Lưu lại thay đổi
                    receptionist.delete()  # Xóa Receptionist

                    print(f"Đã xóa Receptionist cho người dùng: {obj.username}")
                else:
                    print(f"Không tìm thấy Receptionist cho người dùng: {obj.username}")

                # Tạo Customer mới cho người dùng
                customer, created = Customer.objects.get_or_create(user=obj)
                if created:
                    print(f"Tạo Customer mới cho người dùng: {obj.username}")
                else:
                    print(f"Customer đã tồn tại cho người dùng: {obj.username}")


class ProfileAdmin(admin.ModelAdmin):
    search_fields = ['full_name', 'user__username']
    list_display = ['full_name', 'user', 'verified']

# Đăng ký các model
admin.site.register(User, UserAdmin)
admin.site.register(Profile, ProfileAdmin)
admin.site.register(Receptionist)  # Nếu cần quản lý Receptionist trong admin
admin.site.register(Customer)  # Nếu cần quản lý Customer trong admin
