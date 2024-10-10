# Generated by Django 5.1 on 2024-10-02 02:26

import django.core.validators
import shortuuid.django_fields
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('hotel', '0004_alter_hotel_status'),
    ]

    operations = [
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
    ]
