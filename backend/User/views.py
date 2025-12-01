from rest_framework.views import APIView
from rest_framework import generics, status
from rest_framework_simplejwt.tokens import RefreshToken
from django.core.mail import send_mail
from rest_framework.parsers import MultiPartParser, FormParser
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .serializers import OTPVerifySerializer, UserCreateSerializer, LoginSerializer
from .models import OTP, UserModel
from .utils import get_otp
from django.conf import settings
from .authentication import CustomUserJWTAuthentication


class RequestOTPView(APIView):
    """
    Send OTP to the user's email for verification during registration.
    """
    @swagger_auto_schema(
        tags=["Authentication"],
        operation_summary="Request OTP",
        operation_description="Sends a One-Time Password (OTP) to the given email for verification. Email must not be already registered.",
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'email': openapi.Schema(type=openapi.TYPE_STRING, description='User email address')
            },
            required=['email']
        ),
        responses={
            200: openapi.Response(description="OTP sent successfully"),
            400: openapi.Response(description="Email already exists")
        }
    )
    def post(self, request, *args, **kwargs):
        email = request.data.get("email")
        otp_code = get_otp()
        
        try:
            user = UserModel.objects.get(email=email)
            return Response(
                data={"error": "User with this email already exists"},
                status=status.HTTP_400_BAD_REQUEST
            )
        except UserModel.DoesNotExist:
            # Send OTP
            send_mail(
                subject="Verification Code",
                message=f"Your verification code is: {otp_code}",
                from_email=settings.EMAIL_HOST_USER,
                recipient_list=[email],
                fail_silently=False,
            )
            OTP.objects.create(email=email, otp_code=otp_code)
            return Response(
                data={"message": "OTP sent successfully", "email": email},
                status=status.HTTP_200_OK
            )


class VerifyEmail(APIView):
    """
    Verify user's email using the OTP code.
    """
    @swagger_auto_schema(
        tags=["Authentication"],
        operation_summary="Verify email with OTP",
        operation_description="Verifies the user's email address by matching the provided OTP code.",
        request_body=OTPVerifySerializer,
        responses={
            200: openapi.Response(description="Email verified successfully"),
            400: openapi.Response(description="Invalid OTP or email not found")
        }
    )
    def post(self, request, *args, **kwargs):
        email = request.data.get("email")
        otp_code = request.data.get("otp_code")

        try:
            otp_instance = OTP.objects.get(email=email)
        except OTP.DoesNotExist:
            return Response(
                data={"error": "Email not found"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if otp_instance.otp_code == otp_code:
            otp_instance.is_verified = True
            otp_instance.save()
            return Response(
                data={"message": "Verified successfully", "email": email},
                status=status.HTTP_200_OK
            )
        else:
            return Response(
                data={"error": "OTP code is incorrect"},
                status=status.HTTP_400_BAD_REQUEST
            )


class UserCreateAPIView(APIView):
    """
    Register a new user with optional profile image upload.
    """
    parser_classes = (MultiPartParser, FormParser)

    @swagger_auto_schema(
        tags=["Authentication"],
        operation_summary="Create user account",
        operation_description="""
Registers a new user. Password is hashed automatically. Profile image is optional.
""",
        request_body=UserCreateSerializer,
        responses={
            201: openapi.Response(
                description="User created successfully",
                examples={
                    "application/json": {
                        "message": "User created successfully",
                        "user": {
                            "id": 1,
                            "first_name": "Dilshod",
                            "last_name": "Muxtorov",
                            "email": "dilshod@example.com",
                            "profile_image": "http://localhost:8000/media/user/avatar.png",
                            "date_joined": "2025-10-30T12:34:56Z"
                        }
                    }
                }
            ),
            400: openapi.Response(
                description="Validation error",
                examples={"application/json": {"email": ["This field must be unique."]}}
            ),
        }
    )
    def post(self, request, *args, **kwargs):
        serializer = UserCreateSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response({
                "message": "User created successfully",
                "user": {
                    "id": user.id,
                    "first_name": user.first_name,
                    "last_name": user.last_name,
                    "email": user.email,
                    "profile_image": (
                        request.build_absolute_uri(user.profile_image.url)
                        if user.profile_image else None
                    ),
                    "date_joined": user.date_joined,
                }
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserLoginView(generics.GenericAPIView):
    """
    Login user and return JWT tokens.
    """
    serializer_class = LoginSerializer

    @swagger_auto_schema(
        tags=["Authentication"],
        operation_summary="User login",
        operation_description="Logs in user using email and password and returns JWT access and refresh tokens.",
        request_body=LoginSerializer,
        responses={
            200: openapi.Response(description="Login successful"),
            400: openapi.Response(description="Validation error"),
            401: openapi.Response(description="Incorrect password"),
            404: openapi.Response(description="User not found"),
        }
    )
    def post(self, request, *args, **kwargs):
        ser = self.serializer_class(data=request.data)
        if not ser.is_valid():
            return Response({"errors": ser.errors}, status=status.HTTP_400_BAD_REQUEST)

        email = ser.validated_data["email"]
        password = ser.validated_data["password"]

        try:
            user = UserModel.objects.get(email=email)
        except UserModel.DoesNotExist:
            return Response({"error": "User not found"}, status=status.HTTP_404_NOT_FOUND)

        if not user.check_password(password):
            return Response({"error": "Incorrect password"}, status=status.HTTP_401_UNAUTHORIZED)

        refresh = RefreshToken.for_user(user)
        refresh["id"] = user.id

        return Response(
            {"refresh_token": str(refresh), "access_token": str(refresh.access_token)},
            status=status.HTTP_200_OK,
        )


class GetUserNameView(APIView):
    """
    Retrieve authenticated user's profile information.
    """
    authentication_classes = [CustomUserJWTAuthentication]

    @swagger_auto_schema(
        tags=["Userprofile"],
        operation_summary="Get authenticated user info",
        operation_description="Returns the currently logged-in user's details. Requires valid JWT access token.",
        responses={
            200: openapi.Response(
                description="User info retrieved successfully",
                examples={
                    "application/json": {
                        "id": 1,
                        "first_name": "Elshod",
                        "last_name": "Turgunjonov",
                        "email": "nobody@example.com",
                        "profile_image": "http://localhost:8000/media/users/avatar.png",
                        "date_joined": "2025-11-11T14:30:00Z"
                    }
                },
            ),
            401: openapi.Response(description="Authentication credentials were not provided."),
        },
    )
    def get(self, request, *args, **kwargs):
        user = request.user  
        return Response(
            {
                "id": user.id,
                "first_name": user.first_name,
                "last_name": user.last_name,
                "email": user.email,
                "profile_image": (
                    request.build_absolute_uri(user.profile_image.url)
                    if user.profile_image else None
                ),
                "date_joined": user.date_joined,
            },
            status=status.HTTP_200_OK
        )
