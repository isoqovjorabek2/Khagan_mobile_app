from rest_framework.serializers import ModelSerializer
from rest_framework import serializers

from .models import UserModel, OTP

class OTPVerifySerializer(ModelSerializer):
    class Meta:
        model = OTP
        fields = ['email', 'otp_code']


class UserCreateSerializer(ModelSerializer):
    class Meta:
        model = UserModel
        fields = ['first_name','last_name','email','password','profile_image']
        extra_kwargs = {
            'password': {'write_only': True},
            'profile_image': {'required': False}
        }

class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField()