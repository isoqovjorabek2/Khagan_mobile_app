from rest_framework import serializers
from .models import CartModel, AddCardModel
from Products.models import ProductsModel
from Products.serializers import ProductSerializer

class CartSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)
    product_id = serializers.PrimaryKeyRelatedField(
        queryset=ProductsModel.objects.all(),
        source="product",
        write_only=True
    )
    total_price = serializers.SerializerMethodField()

    class Meta:
        model = CartModel
        fields = ["id", "product", "product_id", "quantity", "total_price"]

    def get_total_price(self, obj):
        return obj.product.price * obj.quantity


class AddCardSerializer(serializers.ModelSerializer):
    class Meta:
        model = AddCardModel
        fields = ["id", "card_name", "card_number", "expiry_date", "cvv", "added_at"]
        read_only_fields = ["added_at"]
