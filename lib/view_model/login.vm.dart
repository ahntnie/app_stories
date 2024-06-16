import 'package:app_stories/views/otp.page.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  late BuildContext viewContext;

  login() {
    Navigator.push(
        viewContext, MaterialPageRoute(builder: (context) => const OTPPage()));
  }
}
