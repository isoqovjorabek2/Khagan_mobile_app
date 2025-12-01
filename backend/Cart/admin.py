from django.contrib import admin
from .models import CartModel, AddCardModel

@admin.register(CartModel)
class CartAdmin(admin.ModelAdmin):
    list_display = ['user', 'product', 'quantity', 'status', 'total_price']
    list_filter = ['status', 'user']
    search_fields = ['user__username', 'product__title']

@admin.register(AddCardModel)
class CardAdmin(admin.ModelAdmin):
    list_display = ['user', 'card_name', 'card_number', 'expiry_date', 'added_at']
    search_fields = ['user__username', 'card_name', 'card_number']
