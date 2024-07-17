import 'dart:math';

import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';

import 'package:app_stories/view_model/signup.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/loading_shimmer.dart';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'signup_author.page.dart';
import 'widget/textfield_authentication.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.viewContext = context;
      },
      builder: (context, viewModel, child) {
        return SafeArea(
          child: BasePage(
            showAppBar: false,
            body: Stack(children: [
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Img.imgLogin),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1,
                            ),
                            child: Text(
                              "Đăng ký",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSize.sizeTitle,
                                fontWeight: AppFontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              children: [
                                CustomTextField(
                                  labelText: "Tên người dùng",
                                  hintText: "abc",
                                  controller: viewModel.accountNameController,
                                  errorText: viewModel.accountNameError,
                                  onChanged: (value) {
                                    viewModel.validateAccountName();
                                    viewModel.setName(value);
                                  },
                                ),
                                CustomTextField(
                                  labelText: "Email",
                                  hintText: "abc@gmail.com",
                                  controller: viewModel.emailController,
                                  errorText: viewModel.emailError,
                                  onChanged: (value) {
                                    viewModel.validateEmail();
                                    viewModel.setEmail(value);
                                  },
                                ),
                                CustomTextField(
                                  labelText: "Mật khẩu",
                                  hintText: "***",
                                  controller: viewModel.passwordController,
                                  obscureText: viewModel.obscureText,
                                  errorText: viewModel.accountPasswordError,
                                  onChanged: (value) {
                                    viewModel.validatePassword();
                                    viewModel.setPassword(value);
                                  },
                                  onSuffixIconTap: () =>
                                      viewModel.showhidePassword(),
                                  hasSuffixIcon: true,
                                ),
                                CustomTextField(
                                  labelText: "Nhập lại mật khẩu",
                                  hintText: "***",
                                  controller: viewModel.repasswordController,
                                  obscureText: viewModel.obscureText2,
                                  errorText: viewModel.repasswordError,
                                  onChanged: (value) =>
                                      viewModel.validateRepassword(),
                                  onSuffixIconTap: () =>
                                      viewModel.showhideRePassword(),
                                  hasSuffixIcon: true,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignupAuthorPage()));
                                        },
                                        child: Text(
                                          'Đăng kí tài khoản tác giả',
                                          style: TextStyle(
                                              color: Colors.indigo.shade400,
                                              fontSize: AppFontSize.sizeMedium,
                                              fontWeight: AppFontWeight.bold),
                                        )),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    viewModel.validateAccountName();
                                    viewModel.validatePassword();
                                    viewModel.validateRepassword();
                                    viewModel.validateEmail();
                                    if (viewModel.accountNameError.isEmpty &&
                                        viewModel
                                            .accountPasswordError.isEmpty &&
                                        viewModel.repasswordError.isEmpty &&
                                        viewModel.emailError.isEmpty) {
                                      // print(viewModel.emailError);
                                      viewModel.signup();
                                    } else {
                                      viewModel.showFailedSnackBar(context);
                                    }
                                  },
                                  style: ButtonStyle(
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                      Size.fromHeight(
                                        MediaQuery.of(context).size.height *
                                            0.07,
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.indigo.shade400,
                                    ),
                                  ),
                                  child: const Text(
                                    "Đăng ký",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: AppFontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (viewModel.isBusy)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black26,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ]),
          ),
        );
      },
    );
  }
}
