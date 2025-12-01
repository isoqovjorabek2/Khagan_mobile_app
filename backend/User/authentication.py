from rest_framework.authentication import BaseAuthentication
from rest_framework import exceptions
from rest_framework_simplejwt.tokens import UntypedToken, TokenError
from rest_framework_simplejwt.exceptions import InvalidToken

from .models import UserModel


class CustomUserJWTAuthentication(BaseAuthentication):
    def authenticate(self, request):
        auth_header = request.headers.get("Authorization")
        if not auth_header:
            raise exceptions.AuthenticationFailed(
                "Authorization header must contain two space-delimited values"
            )
        try:
            prefix, token = auth_header.split()
            assert prefix.lower() == "bearer"
        except ValueError:
            raise exceptions.AuthenticationFailed(
                "Authorization header must contain two space-delimited values"
            )
        try:
            UntypedToken(token)
        except (InvalidToken, TokenError) as e:
            raise exceptions.AuthenticationFailed(f"Token invalid: {e}")
        admin_id = UntypedToken(token)["id"]
        
        try:
            admin = UserModel.objects.get(id=admin_id)
        except UserModel.DoesNotExist:
            raise exceptions.AuthenticationFailed("User not found")

        return (admin, None)
