import 'package:app_stories/constants/api.dart';
import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/views/authentication/login.page.dart';
import 'package:app_stories/widget/loading_shimmer.dart';

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
  final TextEditingController penNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController previousWorksController = TextEditingController();
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
    setBusy(true);
    if (emailError.isNotEmpty) {
      showCheckEmailSnackBar(viewContext);
      return;
    }
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
            role: 'user',
            bio: '',
            penName: '',
            previousWorks: '');
        final apiService = ApiService();
        await apiService.postRequestUser(
            '${Api.hostApi}${Api.getUser}', userModel.toJson());
        showSuccessSnackBar(viewContext);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emailError = 'Email đã được đăng ký';
        showCheckEmailSnackBar(viewContext);
      } else {
        print('Error: ${e.message}');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> signupAuthor() async {
    if (emailError.isNotEmpty) {
      showCheckEmailSnackBar(viewContext);
      return;
    }
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
          role: 'author',
          bio: bioController.text,
          penName: penNameController.text,
          previousWorks: previousWorksController.text,
        );
        final apiService = ApiService();
        await apiService.postRequestUser(
            '${Api.hostApi}${Api.getUser}', userModel.toJson());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emailError = 'Email đã được đăng ký';
        showCheckEmailSnackBar(viewContext);
      } else {
        print('Error: ${e.message}');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    notifyListeners();
  }

  // Future<void> checkEmail(TextEditingController email) async {
  //   try {
  //     final List<String> signInMethods =
  //         await _auth(email.text);
  //     if (signInMethods.isNotEmpty) {
  //       showCheckEmailSnackBar(viewContext);
  //     } else {
  //       showSuccessSnackBar(viewContext);
  //     }
  //   } catch (e) {}
  // }

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
  void checkEmail() {}
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
    // Biểu thức chính quy để kiểm tra định dạng email hợp lệ
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);

    // Kiểm tra định dạng email
    if (!regex.hasMatch(email)) {
      return false;
    }

    // Kiểm tra để tránh tên miền sai như @gemail.com
    final domain = email.split('@').last;
    if (domain == 'gemail.com') {
      return false;
    }

    return true;
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
              'Email đã được sử dụng',
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
              'Đăng ký thất bại',
              style: TextStyle(fontSize: AppFontSize.sizeMedium),
            ),
          ],
        ),
        duration: const Duration(seconds: 2), // Thời gian hiển thị SnackBar
      ),
    );
  }
}
