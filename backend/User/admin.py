from django.contrib import admin
from .models import UserModel, OTP


@admin.register(UserModel)
class UserModelAdmin(admin.ModelAdmin):
   list_display = (
      "id",
      "first_name",
      "last_name",
      "email",
    )
   ordering = ("id",)


admin.site.register(OTP)
