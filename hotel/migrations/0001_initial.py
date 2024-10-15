# Generated by Django 5.1 on 2024-10-15 02:15

import django.core.validators
import django_ckeditor_5.fields
import shortuuid.django_fields
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='ActivityLog',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('guest_out', models.DateTimeField()),
                ('guest_in', models.DateTimeField()),
                ('description', models.TextField(blank=True, null=True)),
                ('date', models.DateTimeField(auto_now_add=True, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='Booking',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('payment_status', models.CharField(choices=[('paid', 'Paid'), ('pending', 'Pending'), ('processing', 'Processing'), ('cancelled', 'Cancelled'), ('initiated', 'Initiated'), ('failed', 'failed'), ('refunding', 'refunding'), ('refunded', 'refunded'), ('unpaid', 'unpaid'), ('expired', 'expired')], default='initiated', max_length=100)),
                ('full_name', models.CharField(blank=True, max_length=1000, null=True)),
                ('email', models.EmailField(blank=True, max_length=254, null=True)),
                ('phone', models.CharField(blank=True, max_length=1000, null=True)),
                ('before_discount', models.DecimalField(decimal_places=2, default=0.0, max_digits=12)),
                ('total', models.DecimalField(decimal_places=2, default=0.0, max_digits=12)),
                ('saved', models.DecimalField(decimal_places=2, default=0.0, max_digits=12)),
                ('check_in_date', models.DateField()),
                ('check_out_date', models.DateField()),
                ('total_days', models.PositiveIntegerField(default=0)),
                ('num_adults', models.PositiveIntegerField(default=1)),
                ('num_children', models.PositiveIntegerField(default=0)),
                ('checked_in', models.BooleanField(default=False)),
                ('checked_out', models.BooleanField(default=False)),
                ('is_active', models.BooleanField(default=True)),
                ('checked_in_tracker', models.BooleanField(default=False, help_text='DO NOT CHECK THIS BOX')),
                ('checked_out_tracker', models.BooleanField(default=False, help_text='DO NOT CHECK THIS BOX')),
                ('date', models.DateTimeField(auto_now_add=True, null=True)),
                ('stripe_payment_intent', models.CharField(blank=True, max_length=200, null=True)),
                ('success_id', shortuuid.django_fields.ShortUUIDField(alphabet='abcdefghijklmnopqrstuvxyz1234567890', blank=True, length=300, max_length=505, null=True, prefix='')),
                ('booking_id', shortuuid.django_fields.ShortUUIDField(alphabet='abcdefghijklmnopqrstuvxyz', length=10, max_length=20, prefix='', unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='Coupon',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('code', models.CharField(max_length=1000)),
                ('type', models.CharField(choices=[('Percentage', 'Percentage'), ('Flat Rate', 'Flat Rate')], default='Percentage', max_length=100)),
                ('discount', models.IntegerField(default=1, validators=[django.core.validators.MinValueValidator(0), django.core.validators.MaxValueValidator(100)])),
                ('redemption', models.IntegerField(default=0)),
                ('date', models.DateTimeField(auto_now_add=True)),
                ('active', models.BooleanField(default=True)),
                ('make_public', models.BooleanField(default=False)),
                ('valid_from', models.DateField()),
                ('valid_to', models.DateField()),
                ('cid', shortuuid.django_fields.ShortUUIDField(alphabet='abcdefghijklmnopqrstuvxyz', length=10, max_length=25, prefix='')),
            ],
            options={
                'ordering': ['-id'],
            },
        ),
        migrations.CreateModel(
            name='Hotel',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100)),
                ('description', django_ckeditor_5.fields.CKEditor5Field(blank=True, null=True)),
                ('image', models.FileField(upload_to='hotel_gallery')),
                ('address', models.CharField(max_length=200)),
                ('mobile', models.CharField(max_length=200)),
                ('email', models.EmailField(max_length=100)),
                ('status', models.CharField(choices=[('Draft', 'Draft'), ('Disable', 'Disable'), ('Rejected', 'Rejected'), ('In review', 'In review'), ('Live', 'Live')], default='Live', max_length=20)),
                ('views', models.IntegerField(default=0)),
                ('featured', models.BooleanField(default=False)),
                ('hid', shortuuid.django_fields.ShortUUIDField(alphabet='abcdefghijklmopqrstuvwxyz', length=10, max_length=20, prefix='', unique=True)),
                ('slug', models.SlugField(unique=True)),
                ('date', models.DateField(auto_now_add=True)),
            ],
        ),
        migrations.CreateModel(
            name='HotelFAQs',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('question', models.CharField(max_length=1000)),
                ('answer', models.TextField(blank=True, null=True)),
                ('date', models.DateTimeField(auto_now_add=True)),
                ('hfid', shortuuid.django_fields.ShortUUIDField(alphabet='abcdefghijklmnopqrstuvxyz', length=10, max_length=20, prefix='', unique=True)),
            ],
            options={
                'verbose_name_plural': 'Hotel FAQs',
            },
        ),
        migrations.CreateModel(
            name='HotelFeatures',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('icon_type', models.CharField(blank=True, choices=[('Bootstap Icons', 'Bootstap Icons'), ('Fontawesome Icons', 'Fontawesome Icons'), ('Box Icons', '')], max_length=100, null=True)),
                ('icon', models.CharField(blank=True, max_length=100, null=True)),
                ('name', models.CharField(blank=True, max_length=100, null=True)),
                ('hfid', shortuuid.django_fields.ShortUUIDField(alphabet='abcdefghijklmnopqrstuvxyz', length=10, max_length=20, prefix='', unique=True)),
            ],
            options={
                'verbose_name_plural': 'Hotel Features',
            },
        ),
        migrations.CreateModel(
            name='HotelGallery',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('image', models.FileField(upload_to='hotel_gallery')),
                ('hgid', shortuuid.django_fields.ShortUUIDField(alphabet='abcdefghijklmnopqrstuvxyz', length=10, max_length=20, prefix='', unique=True)),
            ],
            options={
                'verbose_name_plural': 'Hotel Gallery',
            },
        ),
        migrations.CreateModel(
            name='Notification',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('type', models.CharField(choices=[('Booking Confirmed', 'Booking Confirmed'), ('Booking Cancelled', 'Booking Cancelled')], default='new_order', max_length=100)),
                ('seen', models.BooleanField(default=False)),
                ('nid', shortuuid.django_fields.ShortUUIDField(alphabet='abcdefghijklmnopqrstuvxyz', length=10, max_length=20, prefix='', unique=True)),
                ('date', models.DateField(auto_now_add=True)),
            ],
            options={
                'ordering': ['-date'],
            },
        ),
        migrations.CreateModel(
            name='Room',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('room_number', models.CharField(max_length=10)),
                ('is_available', models.BooleanField(default=True)),
                ('rid', shortuuid.django_fields.ShortUUIDField(alphabet='abcdefghijklmnopqrstuvxyz', length=10, max_length=20, prefix='', unique=True)),
                ('date', models.DateTimeField(auto_now_add=True)),
                ('slug', models.SlugField(blank=True, null=True)),
            ],
        ),
        migrations.CreateModel(
            name='RoomType',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('type', models.CharField(max_length=10)),
                ('price', models.DecimalField(decimal_places=2, default=0.0, max_digits=12)),
                ('number_of_beds', models.PositiveIntegerField(default=0)),
                ('room_capacity', models.PositiveIntegerField(default=0)),
                ('rtid', shortuuid.django_fields.ShortUUIDField(alphabet='abcdefghijklmnopqrstuvxyz', length=10, max_length=20, prefix='', unique=True)),
                ('slug', models.SlugField(blank=True, null=True)),
                ('date', models.DateTimeField(auto_now_add=True)),
            ],
        ),
        migrations.CreateModel(
            name='StaffOnDuty',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('staff_id', models.CharField(blank=True, max_length=100, null=True)),
                ('date', models.DateTimeField(auto_now_add=True, null=True)),
            ],
        ),
    ]
