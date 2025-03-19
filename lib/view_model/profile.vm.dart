import 'dart:convert';

import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/constants/api.dart';
import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/custom/dialog.custom.dart';
import 'package:app_stories/custom/snackbar.custom.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/views/profile/profile.page.dart';
import 'package:app_stories/views/profile/widget/custom/button.widget.dart';
import 'package:app_stories/views/profile/widget/custom/textfield.widget.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class ProfileViewModel extends BaseViewModel {
  late BuildContext viewContext;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ApiService apiService = ApiService();
  TextEditingController changeNameController = TextEditingController();
  TextEditingController newRePasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  Users? currentUser;
  int totalStories = 0;

  Future<void> fetchCurrentUser() async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        setBusy(true);
        String uid = firebaseUser.uid;
        Response infoResponse =
            await apiService.getRequest('${Api.hostApi}${Api.getUser}/$uid');
        notifyListeners();
        // });
      }
      setBusy(false);
    } catch (e) {
      print('Error fetching current user: $e');
      notifyListeners();
    }
  }

  Future<List<Users>> getAuthorNotActive() async {
    Response response = await apiService.getRequest(
        '${Api.hostApi}${Api.getUser}',
        queryParams: {"is_active": 0});
    final responseData = jsonDecode(jsonEncode(response.data));
    List<dynamic> listUser = responseData;
    List<Users> authorNotActive =
        listUser.map((json) => Users.fromJson(json)).toList();
    return authorNotActive;
  }

  Future<String?> approveAuthor(String userId) async {
    String? errorString;
    try {
      final response = await ApiService()
          .patchRequest('${Api.hostApi}${Api.approveAuthor}$userId', null);
      if (response.statusCode == 200) {
        errorString = null;
      } else {
        errorString = response.data['message'].toString();
      }
    } catch (e) {
      errorString = e.toString();
    }
    return errorString;
  }

  Future<void> changeNameAccount() async {
    showGeneralDialog(
      context: viewContext,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
              .animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: context.primaryTextColor)),
          backgroundColor: Colors.transparent.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: MediaQuery.of(context).size.height * 0.03,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.blueberry80, AppColors.watermelon80],
                    ),
                  ),
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.12,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.11,
                      backgroundImage: AssetImage(Img.imgAVT),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'Đổi tên tài khoản',
                  style: AppTheme.titleMedium18,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                TextFieldCustom(
                  controller: changeNameController,
                  hintText: 'Nhập tên mới',
                ),

                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        color: AppColors.watermelon80,
                        nameButton: 'Xác nhận',
                        onPressed: () async {
                          if (changeNameController.text.isEmpty) {
                            showFailedChangeNameSnackBar(viewContext);
                          } else if (changeNameController.text.length < 8) {
                            showFailedLenghtNameSnackBar(viewContext);
                          } else {
                            currentUser = Users.fromJson(
                                jsonDecode(AppSP.get(AppSPKey.currrentUser)));
                            await apiService.patchRequestUser(
                                '${Api.hostApi}${Api.getUser}/${currentUser!.id}',
                                jsonEncode(
                                    {'username': changeNameController.text}));
                            currentUser!.name = changeNameController.text;
                            notifyListeners();
                            Navigator.of(viewContext).pop();
                            changeNameController.clear();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        color: context.primaryTextColor,
                        nameButton: 'Hủy',
                        onPressed: () {
                          notifyListeners();
                          Navigator.of(context).pop();
                          changeNameController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> changePasswordFirebase() async {
    User? user = _auth.currentUser;
    String? idToken = await user!.getIdToken();
    final response = await http.post(
      Uri.parse(Api.apiAuth),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'idToken': idToken,
        'password': newPasswordController.text,
        'returnSecureToken': true,
      }),
    );
    if (response.statusCode == 200) {
      print('Password changed successfully.');
    } else {
      print('Error: ${json.decode(response.body)}');
    }
  }

  Future<void> changPassword() async {
    showGeneralDialog(
      context: viewContext,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
              .animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: context.primaryTextColor)),
          backgroundColor: Colors.transparent.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: MediaQuery.of(context).size.height * 0.03,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.blueberry80, AppColors.watermelon80],
                    ),
                  ),
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.12,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.11,
                      backgroundImage: AssetImage(Img.imgAVT),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Tiêu đề
                Text(
                  'Đặt mật khẩu mới',
                  style: AppTheme.titleMedium18,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                // Input fields
                TextFieldCustom(
                  controller: newPasswordController,
                  hintText: 'Mật khẩu Mới',
                ),
                const SizedBox(height: 10),
                TextFieldCustom(
                  controller: newRePasswordController,
                  hintText: 'Nhập lại mật khẩu',
                ),

                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        color: AppColors.watermelon80,
                        nameButton: 'Xác nhận',
                        onPressed: () async {
                          if (newPasswordController.text !=
                              newRePasswordController.text) {
                            showFailedChangePasswordSnackBar(viewContext);
                          } else if (newPasswordController.text.isEmpty ||
                              newRePasswordController.text.isEmpty) {
                            showFailedEmptyPasswordSnackBar(viewContext);
                          } else {
                            changePasswordFirebase();
                            User? firebaseUser = _auth.currentUser;
                            String uid = firebaseUser!.uid;
                            await apiService.patchRequestUser(
                                '${Api.hostApi}${Api.getUser}/$uid',
                                jsonEncode(
                                    {'password': newPasswordController.text}));
                            notifyListeners();
                            Navigator.of(viewContext).pop();
                            newPasswordController.clear();
                            newRePasswordController.clear();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        color: context.primaryTextColor,
                        nameButton: 'Hủy',
                        onPressed: () {
                          Navigator.of(viewContext).pop();
                          newPasswordController.clear();
                          newRePasswordController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showFailedEmptyPasswordSnackBar(BuildContext context) {
    context.showErrorSnackBar('Không được bỏ trống');
  }

  void showFailedChangePasswordSnackBar(BuildContext context) {
    context.showErrorSnackBar('Mật khẩu không trùng nhau');
  }

  void showFailedChangeNameSnackBar(BuildContext context) {
    context.showErrorSnackBar('Tên không được bỏ trống');
  }

  void showFailedLenghtNameSnackBar(BuildContext context) {
    context.showErrorSnackBar('Tên phải chứa 8 ký tự');
  }

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  bool isOver18(String birthDateString) {
    DateTime birthDate = DateTime.parse(birthDateString);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age >= 18;
  }

  Future<void> showBirthDateDialog(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
      confirmText: 'Xác nhận',
      cancelText: 'Hủy',
      fieldLabelText: 'Tháng Ngày Năm',
      errorInvalidText: 'Vui lòng nhập chính xác',
      errorFormatText: 'Yêu cầu đúng định dạng',
      helpText: 'Nhập ngày tháng năm sinh',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.watermelon100,
            colorScheme: ColorScheme.light(primary: AppColors.watermelon100),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(picked);

      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 300),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
                    .animate(animation),
            child: child,
          );
        },
        pageBuilder: (context, anim1, anim2) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: Colors.transparent.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cake, size: 50, color: AppColor.selectColor),
                  const SizedBox(height: 12),
                  Text(
                    'Xác nhận ngày sinh',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.extraColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bạn có muốn chọn ngày sinh **$formattedDate** không?',
                    style: TextStyle(fontSize: 16, color: AppColor.extraColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'TruyenHay sẽ hiển thị nội dung phù hợp với độ tuổi của bạn.',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColor.extraColor.withOpacity(0.8)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Nút xác nhận và hủy
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryTextColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            // Xử lý lưu ngày sinh vào API
                            User? firebaseUser = _auth.currentUser;
                            if (firebaseUser != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(picked);
                              String uid = firebaseUser.uid;
                              currentUser!.birthDate =
                                  DateTime.parse(formattedDate);

                              await apiService.patchRequestUser(
                                '${Api.hostApi}${Api.getUser}/$uid',
                                jsonEncode({'birth_date': formattedDate}),
                              );

                              notifyListeners();
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Xác nhận', style: AppTheme.titleSmall16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.unConfirmColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            notifyListeners();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Hủy',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
