import 'dart:convert';

import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/constants/api.dart';
import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/custom/dialog.custom.dart';
import 'package:app_stories/custom/snackbar.custom.dart';
import 'package:app_stories/models/user_model.dart';
import 'package:app_stories/requests/story.request.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
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
  Users? currentUser =
      Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
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
    showDialog(
      context: viewContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.diaglogColor,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  Img.imgAVT,
                  width: 80,
                  height: 80,
                ),
                Text(
                  'Đặt tên',
                  style: TextStyle(
                      fontSize: AppFontSize.sizeMedium,
                      color: AppColor.extraColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextFieldCustom(
                    controller: changeNameController, hintText: 'Nhập tên'),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                        nameButton: 'Xác nhận',
                        onPressed: () async {
                          if (changeNameController.text.isEmpty) {
                            showFailedChangeNameSnackBar(viewContext);
                          } else if (changeNameController.text.length < 8) {
                            showFailedLenghtNameSnackBar(viewContext);
                          } else {
                            Users currentUser = Users.fromJson(
                                jsonDecode(AppSP.get(AppSPKey.currrentUser)));
                            await apiService.patchRequestUser(
                                '${Api.hostApi}${Api.getUser}/${currentUser.id}',
                                jsonEncode(
                                    {'username': changeNameController.text}));
                            currentUser!.name = changeNameController.text;
                            notifyListeners();
                            // Navigator.of(context).pushReplacement(
                            //   MaterialPageRoute(
                            //       builder: (context) => const ProfilePage()),
                            // );
                            Navigator.of(viewContext).pop();
                            changeNameController.clear();
                          }
                        },
                        color: AppColor.selectColor)),
                SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      color: AppColor.buttonColor,
                      nameButton: 'Hủy',
                      onPressed: () {
                        notifyListeners();
                        Navigator.of(context).pop();
                        changeNameController.clear();
                      },
                    )),
              ],
            ),
          ],
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
    showDialog(
      context: viewContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.diaglogColor,
          content: SizedBox(
            width: MediaQuery.of(viewContext).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  Img.imgAVT,
                  width: 80,
                  height: 80,
                ),
                Text(
                  'Đặt mật khẩu',
                  style: TextStyle(
                      fontSize: AppFontSize.sizeMedium,
                      color: AppColor.extraColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextFieldCustom(
                    controller: newPasswordController,
                    hintText: 'Mật khẩu Mới'),
                const SizedBox(height: 10),
                TextFieldCustom(
                    controller: newRePasswordController,
                    hintText: 'Nhập lại mật khẩu'),
                // const SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      color: AppColor.selectColor,
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
                    )),
                SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                        color: AppColor.buttonColor,
                        nameButton: 'Hủy',
                        onPressed: () {
                          Navigator.of(viewContext).pop();
                          currentPasswordController.clear();
                          newPasswordController.clear();
                          newRePasswordController.clear();
                        })),
              ],
            ),
          ],
        );
      },
    );
  }

  void showFailedEmptyPasswordSnackBar(BuildContext context) {
    ScaffoldMessenger.of(viewContext).showSnackBar(CustomSnackBar(
        icon: Icons.warning_rounded, message: 'Không được bỏ trống'));
  }

  void showFailedChangePasswordSnackBar(BuildContext context) {
    ScaffoldMessenger.of(viewContext).showSnackBar(CustomSnackBar(
        icon: Icons.warning_rounded, message: 'Mật khẩu không trùng nhau'));
  }

  void showFailedChangeNameSnackBar(BuildContext context) {
    ScaffoldMessenger.of(viewContext).showSnackBar(CustomSnackBar(
        icon: Icons.warning_rounded, message: 'Tên không được bỏ trống'));
  }

  void showFailedLenghtNameSnackBar(BuildContext context) {
    ScaffoldMessenger.of(viewContext).showSnackBar(CustomSnackBar(
        icon: Icons.warning_rounded, message: 'Tên phải chứa 8 ký tự'));
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

  Future<void> showBirthDateDialog() async {
    DateTime now = DateTime.now();
    DateFormat('dd/MM/yyyy').format(now);

    final DateTime? picked = await showDatePicker(
      context: viewContext,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      confirmText: 'Xác nhận',
      cancelText: 'Hủy',
      fieldLabelText: 'Tháng Ngày Năm',
      errorInvalidText: 'Vui lòng nhập chính xác',
      errorFormatText: 'Yêu cầu đúng định dạng',
      helpText: 'Nhập ngày tháng năm sinh',
    );

    String formattedDate = formatDate(picked.toString());
    if (picked != null) {
      CustomDialog.showCustomDialogAge(
          context: viewContext,
          title: 'Bạn có muốn chọn ngày sinh $formattedDate không?',
          message: 'TruyenHay sẽ hiển thị nội dung theo độ tuổi của bạn',
          onPressed: () async {
            User? firebaseUser = _auth.currentUser;
            if (firebaseUser != null) {
              String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
              String uid = firebaseUser.uid;
              currentUser!.birthDate = DateTime.parse(formattedDate);
              // currentUserData!['birth_date'] =
              //     picked.toIso8601String().split('T').first;
              await apiService.patchRequestUser(
                  '${Api.hostApi}${Api.getUser}/$uid',
                  jsonEncode({
                    'birth_date': picked.toIso8601String().split('T').first
                  }));

              notifyListeners();
              Navigator.of(viewContext).pop();
            }
          },
          onPressed2: () async {
            notifyListeners();
            Navigator.of(viewContext).pop();
          },
          confirmText: 'Xác nhận',
          unConfirmText: 'Hủy',
          unConfirmColor: AppColor.unConfirmColor,
          confirmColor: AppColor.selectColor);
    }
  }
}
