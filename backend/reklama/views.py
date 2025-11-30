from rest_framework import generics
from .models import Advertisement
from .serializers import AdvertisementSerializer
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from User.authentication import CustomUserJWTAuthentication

class AdvertisementListView(generics.ListAPIView):
    queryset = Advertisement.objects.all().order_by('-created_at')
    serializer_class = AdvertisementSerializer
    authentication_classes = [CustomUserJWTAuthentication]

    @swagger_auto_schema(
        operation_summary="Reklamalar ro‘yxatini olish",
        operation_description="""
            Ushbu API orqali barcha aktiv reklamalar ro‘yxatini olish mumkin.
            Reklama tarkibida quyidagi maydonlar bor:
            - image (rasm)
            - title (sarlavha)
            - description (izoh)
        """,
        tags=["Advertisements"]
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)
