# Generated by Django 5.1 on 2024-11-10 03:02

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('hotel', '0007_remove_hotel_image'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='room',
            name='slug',
        ),
    ]
