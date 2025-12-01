from django.urls import path
from .views import AllCategoryView, ProductListView, ProductDetailView

urlpatterns = [
    path('categories/', AllCategoryView.as_view(), name='categories'),
    path('products/', ProductListView.as_view(), name='products'),
    path('products/<int:pk>/', ProductDetailView.as_view(), name='product-detail'),
]
