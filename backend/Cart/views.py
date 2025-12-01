from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi
from Products.models import ProductsModel
from .models import CartModel, AddCardModel
from .serializers import CartSerializer, AddCardSerializer
from User.authentication import CustomUserJWTAuthentication


class GetCartView(generics.ListAPIView):
    serializer_class = CartSerializer
    authentication_classes = [CustomUserJWTAuthentication]

    @swagger_auto_schema(
        tags=["Cart"],
        operation_summary="Get active cart items",
        operation_description="Returns all active cart items for the authenticated user.",
        responses={200: CartSerializer(many=True), 401: "Authentication required"},
    )
    def get_queryset(self):
        return CartModel.objects.filter(user=self.request.user, status="Active")


class AddProductView(APIView):
    authentication_classes = [CustomUserJWTAuthentication]

    @swagger_auto_schema(
        tags=["Cart"],
        operation_summary="Add product to cart",
        operation_description="Creates a cart item with status Active for the authenticated user.",
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            required=["product_id", "quantity"],
            properties={
                "product_id": openapi.Schema(type=openapi.TYPE_INTEGER, description="ID of the product to add"),
                "quantity": openapi.Schema(type=openapi.TYPE_INTEGER, description="Quantity to add (>=1)"),
            },
        ),
        responses={
            201: CartSerializer,
            400: "Validation error",
            404: "Product not found",
            401: "Authentication required",
        },
    )
    def post(self, request, *args, **kwargs):
        product_id = request.data.get("product_id")
        quantity = request.data.get("quantity", 1)

        if not product_id:
            return Response({"error": "product_id is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            quantity = int(quantity)
        except (TypeError, ValueError):
            return Response({"error": "quantity must be an integer"}, status=status.HTTP_400_BAD_REQUEST)

        if quantity < 1:
            return Response({"error": "quantity must be at least 1"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            product = ProductsModel.objects.get(id=product_id)
        except ProductsModel.DoesNotExist:
            return Response({"error": "Product not found"}, status=status.HTTP_404_NOT_FOUND)

        cart_item = CartModel.objects.create(
            user=request.user,
            product=product,
            quantity=quantity,
            status="Active",
        )
        serializer = CartSerializer(cart_item)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class DeleteProductView(APIView):
    authentication_classes = [CustomUserJWTAuthentication]

    @swagger_auto_schema(
        tags=["Cart"],
        operation_summary="Delete product from cart",
        operation_description="Deletes the authenticated user's active cart item by product ID.",
        manual_parameters=[
            openapi.Parameter(
                "product_id",
                openapi.IN_PATH,
                description="Product ID to remove from cart",
                type=openapi.TYPE_INTEGER,
                required=True,
            )
        ],
        responses={
            200: "Product removed from cart",
            404: "Cart item not found",
            401: "Authentication required",
        },
    )
    def delete(self, request, product_id, *args, **kwargs):
        cart_item = CartModel.objects.filter(
            user=request.user,
            product_id=product_id,
            status="Active",
        ).first()

        if not cart_item:
            return Response({"error": "Cart item not found"}, status=status.HTTP_404_NOT_FOUND)

        cart_item.delete()
        return Response({"message": "Product removed from cart"}, status=status.HTTP_200_OK)


class OrderCartView(APIView):
    authentication_classes = [CustomUserJWTAuthentication]

    @swagger_auto_schema(
        tags=["Cart"],
        operation_summary="Order cart items",
        operation_description="Marks all active cart items for the authenticated user as Sold.",
        responses={
            200: openapi.Response(
                description="Order placed",
                examples={"application/json": {"message": "Order placed", "updated": 3}},
            ),
            400: "No active items to order",
            401: "Authentication required",
        },
    )
    def post(self, request, *args, **kwargs):
        active_items = CartModel.objects.filter(user=request.user, status="Active")
        if not active_items.exists():
            return Response({"error": "No active items to order"}, status=status.HTTP_400_BAD_REQUEST)

        updated = active_items.update(status="Sold")
        return Response({"message": "Order placed", "updated": updated}, status=status.HTTP_200_OK)


class UserCardsView(generics.ListCreateAPIView):
    serializer_class = AddCardSerializer
    authentication_classes = [CustomUserJWTAuthentication]

    def get_queryset(self):
        return AddCardModel.objects.filter(user=self.request.user)

    @swagger_auto_schema(
        tags=["Cards"],
        operation_summary="List user cards",
        operation_description="Returns all saved cards for the authenticated user.",
        responses={200: AddCardSerializer(many=True), 401: "Authentication required"},
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)

    @swagger_auto_schema(
        tags=["Cards"],
        operation_summary="Add a card",
        operation_description="Saves a new card for the authenticated user.",
        request_body=AddCardSerializer,
        responses={
            201: AddCardSerializer,
            400: "Validation error",
            401: "Authentication required",
        },
    )
    def post(self, request, *args, **kwargs):
        return super().post(request, *args, **kwargs)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
