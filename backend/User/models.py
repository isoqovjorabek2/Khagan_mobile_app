from django.db import models
from django.contrib.auth.hashers import (
    make_password,
    check_password as dj_check_password,
)
from django.utils import timezone
import datetime


from .validators import validate_strong_password


class UserModel(models.Model):
    first_name = models.CharField(max_length=255, default="", blank=True)
    last_name = models.CharField(max_length=255, default="", blank=True)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=65, validators=[validate_strong_password])
    profile_image = models.ImageField(upload_to="user/", null=True, blank=True)
    date_joined = models.DateTimeField(auto_now_add=True)

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["email", "password"]

    def set_password(self, raw_password: str) -> None:
        self.password = make_password(raw_password)

    def check_password(self, raw_password: str) -> bool:
        return dj_check_password(raw_password, self.password)

    def save(self, *args, **kwargs):
        if self.password and "$" not in self.password:
            self.password = make_password(self.password)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.first_name + " " + self.last_name

class OTP(models.Model):
    email = models.EmailField(unique=True)
    otp_code = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)
    is_verified = models.BooleanField(default=False)

    def is_expired(self):
        return timezone.now() > self.created_at + datetime.timedelta(minutes=5)
