from django.contrib import admin
from .models import ProductCategoryModel, ProductsModel


@admin.register(ProductsModel)
class ProductModelAdmin(admin.ModelAdmin):
    list_display = ['title','id','category','price']

admin.site.register(ProductCategoryModel)