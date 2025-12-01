from rest_framework import serializers
from .models import ProductCategoryModel, ProductsModel


class ProductCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductCategoryModel
        fields = ['id', 'name']


class ProductSerializer(serializers.ModelSerializer):
    category = ProductCategorySerializer(read_only=True)

    class Meta:
        model = ProductsModel
        fields = ['id', 'title', 'description', 'category', 'price', 'image']
