from django.urls import path
from .views_api import list_customers, customers_registered_today, get_customer


urlpatterns = [
    path('list/', list_customers, name='list_customers'),
    path('<int:customer_id>/', get_customer, name='customer_detail'),
    path('today/', customers_registered_today, name='customers_registered_today'),
]
