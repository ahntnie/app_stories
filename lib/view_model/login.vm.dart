import 'dart:convert';

import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/constants/api.dart';
import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/views/authentication/signup.page.dart';
import 'package:app_stories/views/home/home.page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class LoginViewModel extends BaseViewModel {
  late BuildContext viewContext;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
      String uid = user.uid;
      final apiService = ApiService();
      final response =
          await apiService.getRequest('${Api.hostApi}${Api.getUser}/$uid');
      if (response.statusCode == 200) {
        Users? userModel = Users(
            id: user.uid,
            name: user.displayName.toString(),
            email: user.email.toString(),
            birthDate: DateTime.now(),
            role: 'user',
            bio: '',
            penName: '',
            previousWorks: '');
        AppSP.set(AppSPKey.currrentUser, userModel.toJson().toString());
        return user;
      } else if (response.statusCode == 404) {
        // Tài khoản không tồn tại, tạo mới tài khoản trong MySQL
        Users? userModel = Users(
            id: user.uid,
            name: user.displayName.toString(),
            email: user.email.toString(),
            birthDate: DateTime.now(),
            role: 'user',
            bio: '',
            penName: '',
            previousWorks: '');
        AppSP.set(AppSPKey.currrentUser, userModel.toJson().toString());
        await apiService.postRequestUser(
            '${Api.hostApi}${Api.getUser}', userModel.toJson());
        return user;
      } else {
        // Xử lý các lỗi khác (nếu có)
        throw Exception('Failed to check user status');
      }
    }
    notifyListeners();
    return null;
  }

  Future<void> signOut() async {
    await auth.signOut();
    await _googleSignIn.signOut();
    AppSP.set(AppSPKey.currrentUser, '');
    AppSP.set(AppSPKey.userinfo, '');
  }

  Future<User?> loginUsingEmailPassword() async {
    setBusy(true);
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      user = userCredential.user;
      Response infoResponse = await ApiService()
          .getRequest('${Api.hostApi}${Api.getUser}/${user!.uid}');
      AppSP.set(AppSPKey.currrentUser, jsonEncode(infoResponse.data));
      // Users currentUser =
      //     Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
      // if (currentUser.role == 'admin') {
      //   print('Lấy đúng tài khoản admin');
      //   await signInAndCheckDevice(
      //       emailController.text, passwordController.text);
      // }
    } on FirebaseAuthException catch (e) {
      if (e.code == "không tồn tại") {
        print("Không tìm thấy user");
      }
    }
    setBusy(false);
    notifyListeners();
    return user;
  }

  Future<void> sendConfirmationEmail(String email) async {
    final Email confirmationEmail = Email(
      body:
          'Có thiết bị mới vừa đăng nhập vào tài khoản của bạn. Nếu không phải bạn, hãy kiểm tra lại bảo mật tài khoản của mình.',
      subject: 'Xác nhận đăng nhập mới',
      recipients: [email],
      isHTML: false,
    );
    print('Chuẩn bị gửi mail');
    await FlutterEmailSender.send(confirmationEmail);
  }

  Future<void> storeDeviceInfo() async {
    User? user = auth.currentUser;
    if (user != null) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      String deviceId = androidInfo.id;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('devices')
          .doc(deviceId)
          .set({
        'deviceId': deviceId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    await storeDeviceInfo();
  }

  Future<void> checkForNewDeviceAndSendEmail() async {
    User? user = auth.currentUser;
    if (user != null) {
      QuerySnapshot deviceDocs = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('devices')
          .get();

      if (deviceDocs.docs.length > 1) {
        await sendConfirmationEmail(user.email!);
      }
    }
  }

  Future<void> signInAndCheckDevice(String email, String password) async {
    await signIn(email, password);
    await checkForNewDeviceAndSendEmail();
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
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (router) => false,
            ); // Chuyển sang trang HomePage
          });
        },
      ),
    );
  }

  void showFailedIsActiveSnackBar(BuildContext context) {
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
              'Tài khoản chưa được duyệt',
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
