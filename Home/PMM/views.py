from django.shortcuts import render, get_object_or_404, redirect
from rest_framework import generics
from .models import Restaurant, User, Menu, SearchHistory
from .serializers import RestaurantSerializer, UserSerializer, MenuSerializer, SearchHistorySerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework import viewsets
from django.contrib.auth import authenticate, login
from .forms import LoginForm  # Import form đăng nhập
from django import forms
from django.contrib.auth.hashers import make_password, check_password
# API chào mừng
class WelcomeAPI(APIView):
    def get(self, request):
        return Response({"message": "Welcome to the restaurant API!"})

# API tạo mới và xem danh sách nhà hàng
class RestaurantCreate(generics.ListCreateAPIView):
    queryset = Restaurant.objects.all()
    serializer_class = RestaurantSerializer

# API xem, cập nhật, xóa nhà hàng theo ID
class RestaurantRetrieveUpdateDestroy(generics.RetrieveUpdateDestroyAPIView):
    queryset = Restaurant.objects.all()
    serializer_class = RestaurantSerializer
    lookup_field = "pk"



class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    # Xóa phần lọc theo restaurant_number vì nó không có trong model User
    def get_queryset(self):
        return User.objects.all()

    # Hàm tạo user mới, không cần kiểm tra restaurant_number
    def create(self, request, *args, **kwargs):
        data = request.data
        user = User.objects.create(
            user_number=data['user_number'],
            full_name=data['full_name'],
            email=data['email'],
            password_hash=data['password_hash']
        )
        return Response(UserSerializer(user).data, status=status.HTTP_201_CREATED)

class LoginForm(forms.Form):
    identifier = forms.CharField(label="Email hoặc User Number")
    password = forms.CharField(widget=forms.PasswordInput)


class MenuViewSet(viewsets.ModelViewSet):
    queryset = Menu.objects.all()
    serializer_class = MenuSerializer

class SearchHistoryViewSet(viewsets.ModelViewSet):
    queryset = SearchHistory.objects.all()
    serializer_class = SearchHistorySerializer


class RegisterAPIView(APIView):
    def post(self, request):
        data = request.data.copy()
        
        # Kiểm tra user_number đã tồn tại hay chưa
        if User.objects.filter(user_number=data.get('user_number')).exists():
            return Response({'message': 'Tài khoản đã tồn tại'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Hash mật khẩu trước khi lưu
        data['password_hash'] = make_password(data['password_hash'])

        # Dùng UserSerializer để lưu user mới
        serializer = UserSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response({'message': 'Đăng ký thành công'}, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LoginAPIView(APIView):
    def post(self, request):
        email = request.data.get('email')  # Nhận email
        password = request.data.get('password_hash')  # Nhận mật khẩu nhập vào

        user = User.objects.filter(email=email).first()
        if user and check_password(password, user.password_hash):  # Kiểm tra mật khẩu
            return Response({'message': 'Đăng nhập thành công'}, status=status.HTTP_200_OK)
        
        return Response({'message': 'Sai tài khoản hoặc mật khẩu'}, status=status.HTTP_401_UNAUTHORIZED)