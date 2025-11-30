from django.db import models


class Advertisement(models.Model):
    image = models.ImageField(upload_to="banners/")
    title = models.CharField(max_length=255)
    description = models.TextField()

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title
