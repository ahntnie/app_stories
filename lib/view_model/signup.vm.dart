import 'package:app_stories/constants/api.dart';
import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/views/authentication/login.page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SignUpViewModel extends BaseViewModel {
  late BuildContext viewContext;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;
  String accountNameError = '';
  String accountPasswordError = '';
  String repasswordError = '';
  String emailError = '';
  String name = '';
  String email = '';
  int age = 0;
  String password = '';
  String photoURL = '';
  String emailCheck = '';
  void setName(String value) {
    name = value;

    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPhotoURL(String value) {
    photoURL = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setAge(int value) {
    age = value;
    notifyListeners();
  }

  bool get obscureText => _obscureText;
  bool get obscureText2 => _obscureText2;
  void showhidePassword() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void showhideRePassword() {
    _obscureText2 = !_obscureText2;
    notifyListeners();
  }

  login() {
    Navigator.push(viewContext,
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Future<void> signup() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? user = userCredential.user;
      if (user != null) {
        Users? userModel = Users(
            id: user.uid,
            name: accountNameController.text,
            email: emailController.text,
            birthDate: DateTime.now(),
            password: passwordController.text,
            role: 'user');
        final apiService = ApiService();
        await apiService.postRequestUser(
            '${Api.hostApi}${Api.getUser}', userModel.toJson());
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    notifyListeners();
  }

  void validateAccountName() {
    final accountName = accountNameController.text;
    if (accountName.isEmpty) {
      accountNameError = 'Tên tài khoản không được bỏ trống';
    } else if (accountName.length < 8) {
      accountNameError = 'Tên tài khoản phải tối đa 8 kí tự';
    } else {
      accountNameError = '';
    }
    notifyListeners();
  }

  void validaterePassword() {
    final password = passwordController.text.trim();
    if (password.isEmpty) {
      accountPasswordError = 'Mật khẩu không được bỏ trống';
    } else {
      accountPasswordError = '';
    }
    notifyListeners();
  }

//hàm kiểm tra tên password
  void validatePassword() {
    final accountPassword = passwordController.text.trim();
    if (accountPassword.isEmpty) {
      accountPasswordError = 'Mật khẩu không được bỏ trống';
    } else if (accountPassword.length < 8 ||
        !accountPassword.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      accountPasswordError = 'Mật khẩu tối đa 8 kí tự và chứa kí tự đặc biệt';
    } else {
      accountPasswordError = '';
    }
    notifyListeners();
  }
//hàm kiểm tra password có trùng với password trước hay không

  void validateRepassword() {
    final repassword = repasswordController.text.trim();
    if (repassword.isEmpty) {
      repasswordError = 'Mật khẩu không được bỏ trống';
    } else if (repassword != passwordController.text) {
      repasswordError = 'Mật khẩu không khớp';
    } else {
      repasswordError = '';
    }
    notifyListeners();
  }
//hàm kiểm tra email có hợp lệ hay không

  void validateEmail() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError = 'Email không được bỏ trống';
    } else if (!_isValidEmail(email)) {
      emailError = 'Email không hợp lệ';
    } else {
      emailError = '';
    }
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    // Biểu thức chính quy để kiểm tra định dạng email
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  void showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColor.successColor),
            const SizedBox(width: 5),
            Text(
              'Đăng ký thành công.',
              style: TextStyle(fontSize: AppFontSize.sizeMedium),
            ),
          ],
        ),
        duration: const Duration(seconds: 1), // Thời gian hiển thị SnackBar
        onVisible: () {
          // Sau khi SnackBar hiển thị
          Future.delayed(const Duration(seconds: 1), () {
            // Sau 3 giây
            ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Ẩn SnackBar
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            ); // Chuyển sang trang HomePage
          });
        },
      ),
    );
  }

  void showCheckEmailSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_rounded,
              color: AppColor.selectColor,
            ),
            const SizedBox(width: 5),
            Text(
              emailCheck,
              style: TextStyle(fontSize: AppFontSize.sizeMedium),
            ),
          ],
        ),
        duration: const Duration(seconds: 2), // Thời gian hiển thị SnackBar
      ),
    );
  }

//thông báo thất bại
  void showFailedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_rounded,
              color: AppColor.selectColor,
            ),
            const SizedBox(width: 5),
            Text(
              'Đăng ký thất bại.',
              style: TextStyle(fontSize: AppFontSize.sizeMedium),
            ),
          ],
        ),
        duration: const Duration(seconds: 2), // Thời gian hiển thị SnackBar
      ),
    );
  }
}
