from typing import Iterable
from django.utils.text import slugify
from django.db import models
from django.utils.html import mark_safe
from userauths.models import User
from shortuuid.django_fields import ShortUUIDField
import shortuuid
from django_ckeditor_5.fields import CKEditor5Field
from taggit.managers import TaggableManager
from django.core.validators import MinValueValidator, MaxValueValidator

HOTEL_STATUS =(
    ("Draft","Draft"),
    ("Disable","Disable"),
    ("Rejected","Rejected"),
    ("In review","In review"),
    ("Live","Live"),

)
ICON_TPYE = (
    ("Bootstap Icons", "Bootstap Icons"),
    ("Fontawesome Icons", "Fontawesome Icons"),
    ("Box Icons","")
)

PAYMENT_STATUS = (
    ("paid", "Paid"),
    ("pending", "Pending"),
    ("processing", "Processing"),
    ("cancelled", "Cancelled"),
    ("initiated", 'Initiated'),
    ("failed", 'failed'),
    ("refunding", 'refunding'),
    ("refunded", 'refunded'),
    ("unpaid", 'unpaid'),
    ("expired", 'expired'),
)

DISCOUNT_TYPE = (
    ("Percentage", "Percentage"),
    ("Flat Rate", "Flat Rate"),
)

NOTIFICATION_TYPE = (
    ("Booking Confirmed", "Booking Confirmed"),
    ("Booking Cancelled", "Booking Cancelled"),
)


# Create your models here.
class Hotel(models.Model):
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null = True)
    
    name = models.CharField(max_length=100)
    description = CKEditor5Field(null=True, blank=True, config_name='extends')
    map_image = models.ImageField(upload_to="hotel_gallery", null=True, blank=True)
    address = models.CharField(max_length=200)
    mobile = models.CharField(max_length=200)
    email = models.EmailField(max_length=100)
    status = models.CharField(max_length=20, choices=HOTEL_STATUS, default="Live")

    tags = TaggableManager(blank=True)
    views = models.IntegerField(default=0) #số lượt xem
    featured = models.BooleanField(default=False) #khách sạn có nổi bật hay không
    hid = ShortUUIDField(unique=True, length=10, max_length=20, alphabet="abcdefghijklmopqrstuvwxyz") #tạo ID tự động
    slug = models.SlugField(unique=True)
    date = models.DateField(auto_now_add=True)

    def __str__(self) -> str:
        return self.name or ""
    
    def save(self,*args,**kwargs):
        if self.slug == "" or self.slug == None:
            uuid_key = shortuuid.uuid()
            uniqueid = uuid_key[:4]     
            self.slug = slugify(self.name) + '-' + str(uniqueid.lower())

        super(Hotel, self).save(*args, **kwargs)

    def thumbnail(self):
        return mark_safe("<img src='%s' width='50' height='50' style='object-fit': cover; border-radius: 6px;' />" % (self.image.url))

    def hotel_gallery(self):
        return HotelGallery.objects.filter(hotel=self)

    def hotel_room_types(self):
        return RoomType.objects.filter(hotel=self)

#Lưu trữ hình ảnh khách sạn  
class HotelGallery(models.Model):
    hotel = models.ForeignKey(Hotel, on_delete=models.CASCADE)
    image = models.FileField(upload_to="hotel_gallery")
    hgid = ShortUUIDField(unique=True, length=10, max_length=20, alphabet="abcdefghijklmnopqrstuvxyz")

    def __str__(self):
        return str(self.hotel) if self.hotel else "No Hotel"

    class Meta:
        verbose_name_plural = "Hotel Gallery"

#Tính năng của khách sạn
class HotelFeatures(models.Model):
    hotel = models.ForeignKey(Hotel, on_delete=models.CASCADE)
    icon_type = models.CharField(max_length=100, null=True, blank=True, choices=ICON_TPYE)
    icon = models.CharField(max_length=100, null=True, blank=True)
    name = models.CharField(max_length=100, null=True, blank=True)
    hfid = ShortUUIDField(unique=True, length=10, max_length=20, alphabet="abcdefghijklmnopqrstuvxyz")

    def __str__(self):
        return str(self.hotel) if self.hotel else "No Hotel"
    
    class Meta:
        verbose_name_plural = "Hotel Features"

#Câu hỏi thưởng gặp 
class HotelFAQs(models.Model):
    hotel = models.ForeignKey(Hotel, on_delete=models.CASCADE)
    question = models.CharField(max_length=1000)
    answer = models.TextField(null=True, blank=True)
    date = models.DateTimeField(auto_now_add=True)
    hfid = ShortUUIDField(unique=True, length=10, max_length=20, alphabet="abcdefghijklmnopqrstuvxyz")

    def __str__(self):
        return str(self.hotel) if self.hotel else "No Hotel"
    
    class Meta:
        verbose_name_plural = "Hotel FAQs"

#Loại phòng
class RoomType(models.Model):
    hotel = models.ForeignKey(Hotel, on_delete=models.CASCADE)
    type = models.CharField(max_length=10)
    price = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    number_of_beds = models.PositiveIntegerField(default=0)
    image = models.ImageField(upload_to="hotel_gallery", blank=True, null=True)
    room_capacity = models.PositiveIntegerField(default=0)
    rtid = ShortUUIDField(unique=True, length=10, max_length=20, alphabet="abcdefghijklmnopqrstuvxyz")
    slug = models.SlugField(null=True, blank=True)
    date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.type} - {self.hotel.name if self.hotel else 'No Hotel'} - {self.price}"

    def rooms_count(self):
        return Room.objects.filter(room_type=self).count()
    
    def save(self, *args, **kwargs):
        if self.slug == "" or self.slug == None:
            uuid_key = shortuuid.uuid()
            uniqueid = uuid_key[:4]
            self.slug = slugify(self.type) + "-" + str(uniqueid.lower())
            
        super(RoomType, self).save(*args, **kwargs) 

#Phòng
class Room(models.Model):
    hotel = models.ForeignKey(Hotel, on_delete=models.CASCADE)
    room_type = models.ForeignKey(RoomType, on_delete=models.CASCADE)
    room_number = models.CharField(max_length=10)
    is_available = models.BooleanField(default=True)
    rid = ShortUUIDField(unique=True, length=10, max_length=20, alphabet="abcdefghijklmnopqrstuvxyz")
    date = models.DateTimeField(auto_now_add=True) 

    def __str__(self):
        return f"{self.hotel.name if self.hotel else 'No Hotel'} - {self.room_type.type if self.room_type else 'No Type'} - Room {self.room_number}"

    def price(self):
        return self.room_type.price
    
    def number_of_beds(self):
        return self.room_type.number_of_beds

#Đặt phòng
class Booking(models.Model):
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    payment_status = models.CharField(max_length=100, choices=PAYMENT_STATUS, default="initiated")
    coupons = models.ManyToManyField("hotel.Coupon", blank=True)
    full_name = models.CharField(max_length=1000, null=True, blank=True)
    email = models.EmailField(null=True, blank=True)
    phone = models.CharField(max_length=1000, null=True, blank=True)
    
    hotel = models.ForeignKey(Hotel, on_delete=models.SET_NULL, null=True)
    room_type = models.ForeignKey(RoomType, on_delete=models.SET_NULL, null=True)
    room = models.ManyToManyField(Room)
    before_discount = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    total = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    saved = models.DecimalField(max_digits=12, decimal_places=2, default=0.00)
    
    check_in_date = models.DateField()
    check_out_date = models.DateField()
    
    total_days = models.PositiveIntegerField(default=0)
    num_adults = models.PositiveIntegerField(default=1)
    num_children = models.PositiveIntegerField(default=0)
    
    checked_in = models.BooleanField(default=False)
    checked_out = models.BooleanField(default=False)
    
    is_active = models.BooleanField(default=True) #Phòng có đang hoạt động hay không
    
    checked_in_tracker = models.BooleanField(default=False, help_text="DO NOT CHECK THIS BOX") #Quá trình
    checked_out_tracker = models.BooleanField(default=False, help_text="DO NOT CHECK THIS BOX") #Quá trình
    
    date = models.DateTimeField(auto_now_add=True, null=True, blank=True)
    #coupons = models.ManyToManyField("hotel.Coupon", blank=True)
    stripe_payment_intent = models.CharField(max_length=200,null=True, blank=True)
    success_id = ShortUUIDField(length=300, max_length=505, alphabet="abcdefghijklmnopqrstuvxyz1234567890", null=True, blank=True)
    booking_id = ShortUUIDField(unique=True, length=10, max_length=20, alphabet="abcdefghijklmnopqrstuvxyz")


    def __str__(self):
        return f"{self.booking_id or 'No Booking ID'}"
    
    def rooms(self):
        return self.room.all().count()
    
#Hoạt động ra vào của khách hàng
class ActivityLog(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE)
    guest_out = models.DateTimeField()
    guest_in = models.DateTimeField()
    description = models.TextField(null=True, blank=True)
    date = models.DateTimeField(auto_now_add=True, null=True, blank=True)

    def __str__(self):
        return str(self.booking) if self.booking else "No Booking"

#Thông tin nhân viên đặt phòng
class StaffOnDuty(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE)
    staff_id = models.CharField(null=True, blank=True, max_length=100)
    date = models.DateTimeField(auto_now_add=True, null=True, blank=True)

    def __str__(self):
        return str(self.staff_id) if self.staff_id else "No Staff ID"
    
class Coupon(models.Model):
    code = models.CharField(max_length=1000)
    type = models.CharField(max_length=100, choices=DISCOUNT_TYPE, default="Percentage")
    discount = models.IntegerField(default=1, validators=[MinValueValidator(0), MaxValueValidator(100)])
    redemption = models.IntegerField(default=0)
    date = models.DateTimeField(auto_now_add=True)
    active = models.BooleanField(default=True)
    make_public = models.BooleanField(default=False)
    valid_from = models.DateField()
    valid_to = models.DateField()
    cid = ShortUUIDField(length=10, max_length=25, alphabet="abcdefghijklmnopqrstuvxyz")

    def __str__(self):
        return self.code or "No Code"
    
    class Meta:
        ordering =['-id']

class Notification(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, blank=True, null=True, related_name="user")
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE, null=True, blank=True)
    type = models.CharField(max_length=100, default="new_order", choices=NOTIFICATION_TYPE)
    seen = models.BooleanField(default=False)
    nid = ShortUUIDField(unique=True, length=10, max_length=20, alphabet="abcdefghijklmnopqrstuvxyz")
    date= models.DateField(auto_now_add=True)
    
    def __str__(self):
        return str(self.user.username if self.user else "No User")
    
    class Meta:
        ordering = ['-date']

class Review(models.Model):
    hotel = models.ForeignKey(Hotel, on_delete=models.CASCADE, related_name="reviews", null=True, blank=True)
    room_type = models.ForeignKey(RoomType, on_delete=models.CASCADE, related_name="reviews", null=True, blank=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    rating = models.PositiveIntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)], default=5)  # Đánh giá từ 1 đến 5
    review_text = models.TextField(null=True, blank=True)
    date = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        user_str = self.user.username if self.user else "No User"
        hotel_str = self.hotel.name if self.hotel else (self.room_type.type if self.room_type else "No Hotel/Room")
        return f"Review by {user_str} for {hotel_str}"
    
    class Meta:
        verbose_name_plural = "Reviews"

class Cart(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE) 
    is_active = models.BooleanField(default=True) 
    created_at = models.DateTimeField(auto_now_add=True)  
    updated_at = models.DateTimeField(auto_now=True) 

    def total_price(self):
        return sum(item.total_price() for item in self.cart_items.all())

    def total_cart_item(self):
        return sum(item.total_cart_item() for item in self.cart_items.all())

    def __str__(self):
        return f"Cart of {self.user.username if self.user else 'No User'}"

class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name="cart_items") 
    room = models.ForeignKey(Room, on_delete=models.CASCADE) 

    check_in_date = models.DateField(null=True, blank=True)
    check_out_date = models.DateField(null=True, blank=True)
    num_adults = models.PositiveIntegerField(default=1)
    num_children = models.PositiveIntegerField(default=0)

    def total_price(self):
        return self.room.price * self.quantity

    def total_cart_item(self):
        return self.quantity

    def __str__(self):
        room_type_str = self.room.room_type.type if self.room and self.room.room_type else "No Room Type"
        return f"{self.quantity} x {room_type_str} in cart"