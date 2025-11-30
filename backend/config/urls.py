from django.contrib import admin
from django.urls import path, include
from drf_yasg import openapi
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from dotenv import load_dotenv 
import os
load_dotenv()

schema_view = get_schema_view(
    openapi.Info(
        title="Hamxona Api",
        default_version="v1",
        description="The code is in development",
        terms_of_service="https://www.google.com/policies/terms/",
        contact=openapi.Contact(email="contact@snippets.local"),
        license=openapi.License(name="BSD License"),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
    url=os.getenv("SWAGGER_URL", "http://localhost:8000"),
)

urlpatterns = [
    path("admin/", admin.site.urls),
    path(
        "swagger<format>/", schema_view.without_ui(cache_timeout=0), name="schema-json"
    ),
    path(
        "swagger/",
        schema_view.with_ui("swagger", cache_timeout=0),
        name="schema-swagger-ui",
    ),
    path("redoc/", schema_view.with_ui("redoc", cache_timeout=0), name="schema-redoc"),
    path(
        "api/v1/",
        include(
            [
                path("authentication/", include("User.urls")),
                path("category/", include("Products.urls")),
                path("cart/", include("Cart.urls")),
                path('api/v1/ads/', include('reklama.urls')),
            ]
        ),
    ),
]
