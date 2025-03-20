import 'package:app_stories/constants/api.dart';
import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/utils/build_context_extension.dart';
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

  void validateAccountName(String value) {
    if (value.isEmpty) {
      accountNameError = 'Tên tài khoản không được để trống';
    } else if (value.length < 8) {
      accountNameError =
          'Tên tài khoản phải có ít nhất 8 ký tự'; // Sửa thông báo
    } else {
      accountNameError = ''; // Dùng null thay vì ''
    }
    notifyListeners();
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      accountPasswordError = 'Mật khẩu không được để trống';
    } else if (value.length < 8) {
      accountPasswordError =
          'Mật khẩu phải có ít nhất 8 ký tự'; // Sửa thông báo
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      accountPasswordError = 'Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt';
    } else {
      accountPasswordError = ''; // Dùng null thay vì ''
    }
    notifyListeners();
  }

  void validateRepassword(String value) {
    final password = passwordController.text.trim();
    if (value.isEmpty) {
      repasswordError = 'Mật khẩu không được để trống';
    } else if (value != password) {
      repasswordError = 'Mật khẩu không khớp';
    } else {
      repasswordError = ''; // Dùng null thay vì ''
    }
    notifyListeners();
  }

  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError = 'Email không được để trống';
    } else if (!_isValidEmail(value)) {
      emailError = 'Email không hợp lệ';
    } else {
      emailError = ''; // Dùng null thay vì ''
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
    context.showErrorSnackBar('Đăng ký thất bại');
  }
}
