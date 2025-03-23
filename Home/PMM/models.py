from django.db import models
from django.contrib.auth.hashers import make_password, check_password

# Create your models here.
class Restaurant(models.Model):
    restaurant_number = models.CharField(max_length=50, unique=True, primary_key=True)  # Mã nhà hàng là PK
    restaurant_name = models.CharField(max_length=255)
    address = models.TextField()
    phone = models.CharField(max_length=20)
    description = models.TextField(blank=True, null=True)
    opening_hours = models.CharField(max_length=100)
    latitude = models.DecimalField(max_digits=10, decimal_places=8)
    longitude = models.DecimalField(max_digits=11, decimal_places=8)

    class Meta:
        db_table = 'restaurants'

    def __str__(self):
        return self.restaurant_name


class User(models.Model):
    user_number = models.CharField(max_length=50, primary_key=True)
    full_name = models.CharField(max_length=255)
    email = models.EmailField()
    password_hash = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'users'  # Trùng với tên bảng trong MySQL

    def save(self, *args, **kwargs):
        # Nếu mật khẩu chưa mã hóa thì mã hóa trước khi lưu
        if not self.password_hash.startswith("pbkdf2_sha256$"):
            self.password_hash = make_password(self.password_hash)
        super(User, self).save(*args, **kwargs)

    def check_password(self, password):
        return check_password(password, self.password_hash)  # Kiểm tra mật khẩu

    def __str__(self):
        return self.full_name

class Menu(models.Model):
    menu_number = models.CharField(max_length=50, primary_key=True)
    restaurant_number = models.ForeignKey(
        Restaurant,
        on_delete=models.CASCADE,
        db_column='restaurant_number', # Thêm dòng này để giữ đúng tên cột
    )
    menu_name = models.CharField(max_length=100)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image_url = models.CharField(max_length=500)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'menus'

    def __str__(self):
        return self.menu_name
    
class SearchHistory(models.Model):
    search_number = models.CharField(max_length=50, primary_key=True)
    user_number = models.ForeignKey(User, on_delete=models.CASCADE, db_column='user_number')
    search_query = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'search_history'

    def __str__(self):
        return f"{self.user_number} - {self.search_query}"

