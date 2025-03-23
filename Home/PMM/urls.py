from django.urls import path, include
from .views import RestaurantCreate, RestaurantRetrieveUpdateDestroy, UserViewSet, MenuViewSet, SearchHistoryViewSet, RegisterAPIView, LoginAPIView
from rest_framework.routers import DefaultRouter

# Khai báo một router duy nhất
router = DefaultRouter()
router.register(r'users', UserViewSet, basename='user')
router.register(r'menus', MenuViewSet, basename='menu')
router.register(r'search-history', SearchHistoryViewSet, basename='search-history')

urlpatterns = [
    path('restaurant/', RestaurantCreate.as_view(), name="restaurant-create"),
    path('restaurant/<int:pk>/', RestaurantRetrieveUpdateDestroy.as_view(), name="restaurant-update"),
    path('', include(router.urls)),
    path("register/", RegisterAPIView.as_view(), name="register"),
    path("login/", LoginAPIView.as_view(), name="login"),
]
