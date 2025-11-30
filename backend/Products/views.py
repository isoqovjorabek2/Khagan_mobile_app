from rest_framework.generics import ListAPIView, RetrieveAPIView
from rest_framework import filters, permissions
from rest_framework.pagination import PageNumberPagination
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from .models import ProductCategoryModel, ProductsModel
from .serializers import ProductCategorySerializer, ProductSerializer
from rest_framework_simplejwt.authentication import JWTAuthentication
from User.authentication import CustomUserJWTAuthentication


class ProductPagination(PageNumberPagination):
    page_size = 10
    page_query_param = "page"


class AllCategoryView(ListAPIView):
    queryset = ProductCategoryModel.objects.all()
    serializer_class = ProductCategorySerializer
    authentication_classes = [CustomUserJWTAuthentication]

    @swagger_auto_schema(
        tags=["Category"],
        operation_summary="Barcha kategoriyalarni olish",
        operation_description="""Bu endpoint orqali barcha kategoriyalarni olish mumkin.""",
        responses={200: ProductCategorySerializer(many=True)},
    )
    def get(self, *args, **kwargs):
        return super().get(*args, **kwargs)


class ProductListView(ListAPIView):
    serializer_class = ProductSerializer
    pagination_class = ProductPagination
    filter_backends = [filters.SearchFilter]
    search_fields = ['title', 'description']
    authentication_classes = [CustomUserJWTAuthentication]

    def get_queryset(self):
        category_id = self.request.GET.get("categoryId")
        if category_id:
            return ProductsModel.objects.filter(category_id=category_id)
        return ProductsModel.objects.all()

    @swagger_auto_schema(
        tags=["Products"],
        operation_summary="Mahsulotlar ro'yxati (filter, search, pagination)",
        operation_description="Category bo'yicha filter http://127.0.0.1:8000/api/v1/category/products/?categoryId=1 shunday qilinadi",
        manual_parameters=[
            openapi.Parameter(
                'categoryId',
                openapi.IN_QUERY,
                type=openapi.TYPE_INTEGER,
                description="Category bo‘yicha filter"
            ),
            openapi.Parameter(
                'search',
                openapi.IN_QUERY,
                type=openapi.TYPE_STRING,
                description="Search (title, description)"
            ),
            openapi.Parameter(
                'page',
                openapi.IN_QUERY,
                type=openapi.TYPE_INTEGER,
                description="Pagination uchun page raqami"
            ),
        ],
        responses={200: ProductSerializer(many=True)},
    )
    def get(self, *args, **kwargs):
        return super().get(*args, **kwargs)


class ProductDetailView(RetrieveAPIView):
    queryset = ProductsModel.objects.all()
    serializer_class = ProductSerializer
    lookup_field = "pk"
    authentication_classes = [CustomUserJWTAuthentication]

    @swagger_auto_schema(
        tags=["Products"],
        operation_summary="Mahsulotni ID bo‘yicha olish",
        responses={
            200: ProductSerializer(),
            404: openapi.Response(description="Product not found")
        },
    )
    def get(self, *args, **kwargs):
        return super().get(*args, **kwargs)
