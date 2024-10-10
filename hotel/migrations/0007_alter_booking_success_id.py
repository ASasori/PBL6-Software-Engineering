# Generated by Django 5.1 on 2024-10-02 03:24

import shortuuid.django_fields
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('hotel', '0006_booking_coupons'),
    ]

    operations = [
        migrations.AlterField(
            model_name='booking',
            name='success_id',
            field=shortuuid.django_fields.ShortUUIDField(alphabet='abcdefghijklmnopqrstuvxyz1234567890', blank=True, length=300, max_length=505, null=True, prefix=''),
        ),
    ]
