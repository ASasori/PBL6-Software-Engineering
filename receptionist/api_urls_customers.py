from django.urls import path
from .views_api import list_customers, customers_registered_today


urlpatterns = [
    path('list/', list_customers, name='list_customers'),
    path('today/', customers_registered_today, name='customers_registered_today'),
]
