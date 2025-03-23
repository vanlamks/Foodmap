from django import forms

class LoginForm(forms.Form):
    username = forms.CharField(
        max_length=150,
        widget=forms.TextInput(attrs={
            'class': 'border p-2 w-full', 
            'placeholder': 'Nhập tên đăng nhập'
        })
    )
    password = forms.CharField(
        widget=forms.PasswordInput(attrs={
            'class': 'border p-2 w-full', 
            'placeholder': 'Nhập mật khẩu'
        })
    )
