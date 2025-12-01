from django.db import models
from Products.models import ProductsModel
from django.utils import timezone


class CartModel(models.Model):
    CHOICES = (
        ("Active", "active"),
        ("Sold", "sold"),
    )

    user = models.ForeignKey(
        "User.UserModel",
        on_delete=models.CASCADE,
        related_name="cart_items"
    )
    product = models.ForeignKey(
        ProductsModel, 
        on_delete=models.CASCADE
    )
    quantity = models.PositiveIntegerField(default=1)

    status = models.CharField(
        max_length=15,
        choices=CHOICES,
        default="Active"
    )

    def __str__(self):
        return f"{self.user.email} - {self.product.title} ({self.quantity})"

    @property
    def total_price(self):
        return self.product.price * self.quantity


class AddCardModel(models.Model):
    user = models.ForeignKey(
        "User.UserModel",
        on_delete=models.CASCADE,
        related_name="cards"
    )
    card_name = models.CharField(max_length=100)
    card_number = models.CharField(max_length=19)  
    expiry_date = models.CharField(max_length=5)    
    cvv = models.CharField(max_length=3)           
    added_at = models.DateTimeField(default=timezone.now)

    class Meta:
        verbose_name = "Card"
        verbose_name_plural = "User Cards"
        ordering = ["-added_at"]

    def __str__(self):
        return f"{self.card_name} ({self.card_number[-4:]})"
