from django.urls import path
from .views import (
    GetCartView,
    AddProductView,
    DeleteProductView,
    OrderCartView,
    UserCardsView,
)

urlpatterns = [
    path("getCart/", GetCartView.as_view(), name="cart-get"),
    path("addProduct/", AddProductView.as_view(), name="cart-add-product"),
    path("deleteProduct/<int:product_id>/", DeleteProductView.as_view(), name="cart-delete-product"),
    path("orderCart/", OrderCartView.as_view(), name="cart-order"),
    path("cards/", UserCardsView.as_view(), name="user-cards"),
]
