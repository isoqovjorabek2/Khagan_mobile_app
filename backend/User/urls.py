from django.urls import path
from .views import RequestOTPView, VerifyEmail, UserCreateAPIView, UserLoginView,GetUserNameView

urlpatterns = [
    path("request-otp/", RequestOTPView.as_view()),
    path("verify-email/", VerifyEmail.as_view()),
    path("create-account/",UserCreateAPIView.as_view()),
    path("auth/login/", UserLoginView.as_view(), name="student-login"),
    path("api/get-profile/", GetUserNameView.as_view(), name="get-username"),
]