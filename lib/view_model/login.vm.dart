import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/view_model/profile.vm.dart';
import 'package:app_stories/views/authentication/login.page.dart';
import 'package:app_stories/views/authentication/signup.page.dart';
import 'package:app_stories/views/home/home.page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  late BuildContext viewContext;
  FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;
  bool _obscureText = true;
  String emailError = '';
  String accountPasswordError = '';
  signup() {
    Navigator.push(viewContext,
        MaterialPageRoute(builder: (context) => const SignupPage()));
  }

  bool get obscureText => _obscureText;
  void showhidePassword() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      userDoc.set({
        'name': user.displayName,
        'email': user.email,
        'age': 0,
        'photoURL': user.photoURL,
        'lastSignIn': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return user;
    }
    notifyListeners();
    return null;
  }

  Future<void> signOut() async {
    await auth.signOut();
    await _googleSignIn.signOut();
  }

  // getUser() {
  //   ProfileViewModel profileViewModel = ProfileViewModel();
  //   profileViewModel.currentUser.email;
  //   profileViewModel.currentUser.name;
  //   notifyListeners();
  // }

  Future<User?> loginUsingEmailPassword() async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      user = userCredential.user;
      // ProfileViewModel profileViewModel = ProfileViewModel();
      // profileViewModel.fetchCurrentUser();
      // name = profileViewModel.currentUser.email;
      // email = profileViewModel.currentUser.name;
      print(user);
      String? idToken = await user!.getIdToken();
      print(idToken);
    } on FirebaseAuthException catch (e) {
      if (e.code == "không tồn tại") {
        print("Không tìm thấy user");
      }
    }
    notifyListeners();
    return user;
  }

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
              'Đăng nhập thành công.',
              style: TextStyle(fontSize: AppFontSize.sizeMedium),
            ),
          ],
        ),
        duration: const Duration(seconds: 1), // Thời gian hiển thị SnackBar
        onVisible: () {
          // Sau khi SnackBar hiển thị
          Future.delayed(const Duration(seconds: 1), () {
            // Sau 3 giây
            ScaffoldMessenger.of(context).hideCurrentSnackBar(); //
            // Navigator.of(context).pop();
            // Navigator.pop(context);
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomePage()),
            ); // Chuyển sang trang HomePage
          });
        },
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
              'Đăng nhập thất bại.',
              style: TextStyle(fontSize: AppFontSize.sizeMedium),
            ),
          ],
        ),
        duration: const Duration(seconds: 2), // Thời gian hiển thị SnackBar
      ),
    );
  }

  void showFailedSnackBarName(BuildContext context) {
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
              'Tên đăng nhập không chính xác!',
              style: TextStyle(fontSize: AppFontSize.sizeMedium),
            ),
          ],
        ),
        duration: const Duration(seconds: 2), // Thời gian hiển thị SnackBar
      ),
    );
  }

  void showFailedSnackBarEmpty(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.warning_rounded,
              color: AppColor.selectColor,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                'Tên đăng nhập hoặc mật khẩu không được bỏ trống!',
                style: TextStyle(fontSize: AppFontSize.sizeMedium),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: true,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2), // Thời gian hiển thị SnackBar
      ),
    );
  }

  void showFailedSnackBarPassword(BuildContext context) {
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
              'Mật khẩu không chính xác!',
              style: TextStyle(fontSize: AppFontSize.sizeMedium),
            ),
          ],
        ),
        duration: const Duration(seconds: 2), // Thời gian hiển thị SnackBar
      ),
    );
  }
}
