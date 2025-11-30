from django.db import models

class ProductCategoryModel(models.Model):
    name = models.CharField(max_length=255,default="")

    def __str__(self):
        return self.name
    

class ProductsModel(models.Model):
    title = models.CharField(max_length=255, default="")
    description = models.TextField(default="")
    category = models.ForeignKey(ProductCategoryModel, on_delete=models.SET_NULL, null=True)
    price = models.DecimalField(default=0, max_digits=10, decimal_places=2)
    image = models.ImageField(upload_to='products/')

    def __str__(self):
        return self.title