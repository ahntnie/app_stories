import 'dart:convert';

import 'package:app_stories/constants/api.dart';
import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/custom/dialog.custom.dart';
import 'package:app_stories/custom/snackbar.custom.dart';
import 'package:app_stories/services/api_service.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/views/profile/widget/custom/button.widget.dart';
import 'package:app_stories/views/profile/widget/custom/textfield.widget.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  late BuildContext viewContext;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final ApiService apiService = ApiService();
  TextEditingController changeNameController = TextEditingController();
  TextEditingController newRePasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  Map<String, dynamic>? _currentUserData;
  Map<String, dynamic>? get currentUserData => _currentUserData;
  Future<void> fetchCurrentUser() async {
    try {
      User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        setBusy(true);
        String uid = firebaseUser.uid;
        Response infoResponse = await apiService.getRequest('${API.user}/$uid');

        _currentUserData = infoResponse.data;

        notifyListeners();
        // });
      }
      setBusy(false);
    } catch (e) {
      print('Error fetching current user: $e');
      notifyListeners();
    }
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
                            showFailedChangeNameSnackBar(context);
                          } else if (changeNameController.text.length < 8) {
                            showFailedLenghtNameSnackBar(context);
                          } else {
                            User? firebaseUser = _auth.currentUser;

                            Navigator.of(context).pop();
                            String uid = firebaseUser!.uid;
                            await apiService.patchRequest(
                                '${API.user}/$uid',
                                jsonEncode(
                                    {'username': changeNameController.text}));
                            _currentUserData!['username'] =
                                changeNameController.text;
                            notifyListeners();
                            Navigator.of(context).pop();
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

  Future<void> changPassword() async {
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
                  'Đặt mật khẩu',
                  style: TextStyle(
                      fontSize: AppFontSize.sizeMedium,
                      color: AppColor.extraColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                TextFieldCustom(
                    controller: currentPasswordController,
                    hintText: 'Mật khẩu hiện tại'),
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
                        // User? user = _auth.currentUser;
                        notifyListeners();
                        Navigator.of(context).pop();
                        currentPasswordController.clear();
                        newPasswordController.clear();
                        newRePasswordController.clear();
                      },
                    )),
                SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                        color: AppColor.buttonColor,
                        nameButton: 'Hủy',
                        onPressed: () {
                          Navigator.of(context).pop();
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

  void showFailedChangeNameSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
        icon: Icons.warning_rounded, message: 'Tên không được bỏ trống'));
  }

  void showFailedLenghtNameSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
        icon: Icons.warning_rounded, message: 'Tên phải chứa 8 ký tự'));
  }

  Future<void> checkAgeAndShowDialog() async {
    CustomDialog.showCustomDialogAge(
        context: viewContext,
        title: 'Độ tuổi của bạn',
        message: 'TruyenHay sẽ hiển thị nội dung theo độ tuổi của bạn',
        onPressed: () async {
          User? firebaseUser = _auth.currentUser;
          if (firebaseUser != null) {
            String uid = firebaseUser.uid;
            await apiService.patchRequest(
                '${API.user}/$uid', jsonEncode({'age': 18}));
            _currentUserData!['age'] = 18;
            notifyListeners();
            Navigator.of(viewContext).pop();
          }
        },
        onPressed2: () async {
          User? firebaseUser = _auth.currentUser;
          if (firebaseUser != null) {
            String uid = firebaseUser.uid;

            await apiService.patchRequest(
                '${API.user}/$uid', jsonEncode({'age': 1}));
            _currentUserData!['age'] = 1;
            notifyListeners();
            Navigator.of(viewContext).pop();
          }
        },
        confirmText: 'Tôi đã đủ 18 tuổi trở lên',
        unConfirmText: 'Tôi chưa đủ 18 tuổi',
        unConfirmColor: AppColor.unConfirmColor,
        confirmColor: AppColor.selectColor);
  }
}
