import 'dart:math';

import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';

import 'package:app_stories/view_model/signup.vm.dart';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

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
            child: Scaffold(
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Img.imgLogin), fit: BoxFit.cover)),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1),
                          child: Text(
                            "Đăng ký",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSize.sizeTitle,
                                fontWeight: AppFontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Tên người dùng",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontSize.sizeMedium,
                                      fontWeight: AppFontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: TextField(
                                  controller: viewModel.accountNameController,
                                  onChanged: (_) {
                                    viewModel.validateAccountName();
                                    viewModel.setName(
                                        viewModel.accountNameController.text);
                                  },
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    hintText: 'abc',
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    errorText:
                                        viewModel.accountNameError.isNotEmpty
                                            ? viewModel.accountNameError
                                            : null,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontSize.sizeMedium,
                                      fontWeight: AppFontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: TextField(
                                  onChanged: (_) {
                                    viewModel.validateEmail();
                                    viewModel.setEmail(
                                        viewModel.emailController.text);
                                  },
                                  controller: viewModel.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'abc@gmail.com',
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    errorText: viewModel.emailError.isNotEmpty
                                        ? viewModel.emailError
                                        : null,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Mật khẩu",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontSize.sizeMedium,
                                      fontWeight: AppFontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: TextField(
                                  onChanged: (_) {
                                    viewModel.validatePassword();
                                    viewModel.setPassword(
                                        viewModel.passwordController.text);
                                  },
                                  controller: viewModel.passwordController,
                                  obscureText: viewModel.obscureText,
                                  decoration: InputDecoration(
                                    hintText: '***',
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () => viewModel.showhidePassword(),
                                      child: Icon(
                                        viewModel.obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.black,
                                      ),
                                    ),
                                    errorText: viewModel
                                            .accountPasswordError.isNotEmpty
                                        ? viewModel.accountPasswordError
                                        : null,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Nhập lại mật khẩu",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: AppFontSize.sizeMedium,
                                      fontWeight: AppFontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.01),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: TextField(
                                  onChanged: (_) =>
                                      viewModel.validateRepassword(),
                                  controller: viewModel.repasswordController,
                                  obscureText: viewModel.obscureText2,
                                  decoration: InputDecoration(
                                    hintText: '***',
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () =>
                                          viewModel.showhideRePassword(),
                                      child: Icon(
                                        viewModel.obscureText2
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.black,
                                      ),
                                    ),
                                    errorText:
                                        viewModel.repasswordError.isNotEmpty
                                            ? viewModel.repasswordError
                                            : null,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1),
                              ElevatedButton(
                                onPressed: () async {
                                  viewModel.validateAccountName();
                                  viewModel.validatePassword();
                                  viewModel.validateRepassword();
                                  viewModel.validateEmail();
                                  // viewModel.checkCurrentUserEmail();
                                  if (viewModel.accountNameError.isEmpty &&
                                      viewModel.accountPasswordError.isEmpty &&
                                      viewModel.repasswordError.isEmpty &&
                                      viewModel.emailError.isEmpty) {
                                    viewModel.signup();
                                    //viewModel.addUser();
                                    viewModel.showSuccessSnackBar(context);
                                  } else {
                                    viewModel.showFailedSnackBar(context);
                                  }
                                },
                                style: ButtonStyle(
                                    minimumSize: WidgetStateProperty.all<Size>(
                                      Size.fromHeight(
                                          MediaQuery.of(context).size.height *
                                              0.07),
                                    ),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.indigo.shade400)),
                                child: const Text(
                                  "Đăng ký",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: AppFontWeight.bold),
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
          );
        });
  }
}
