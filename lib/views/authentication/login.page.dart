import 'dart:convert';

import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/view_model/login.vm.dart';
import 'package:app_stories/views/authentication/widget/textfield_authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../models/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => LoginViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
        },
        builder: (context, viewModel, child) {
          return SafeArea(
            child: Stack(
              children: [
                Scaffold(
                  body: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Img.imgLogin),
                            fit: BoxFit.cover)),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.15),
                              child: Text(
                                "Đăng nhập",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppFontSize.sizeTitle,
                                    fontWeight: AppFontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    labelText: "Email",
                                    hintText: "abc@gmail.com",
                                    controller: viewModel.emailController,
                                    errorText: viewModel.emailError,
                                    onChanged: (value) {
                                      viewModel.validateEmail();
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
                                    },
                                    onSuffixIconTap: () =>
                                        viewModel.showhidePassword(),
                                    hasSuffixIcon: true,
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                  ElevatedButton(
                                    onPressed: () async {
                                      var user = await viewModel
                                          .loginUsingEmailPassword();
                                      if (user != null) {
                                        AppSP.set(AppSPKey.userinfo,
                                            viewModel.user!.uid);
                                        Users currentUser = Users.fromJson(
                                            jsonDecode(AppSP.get(
                                                AppSPKey.currrentUser)));
                                        if (!currentUser.isActive!) {
                                          viewModel.showFailedIsActiveSnackBar(
                                              context);
                                        } else {
                                          viewModel
                                              .showSuccessSnackBar(context);
                                        }
                                      } else {
                                        viewModel.validateEmail();
                                        viewModel.validatePassword();
                                        if (viewModel
                                                .emailController.text.isEmpty ||
                                            viewModel.passwordController.text
                                                .isEmpty) {
                                          viewModel
                                              .showFailedSnackBarEmpty(context);
                                        } else if (FirebaseAuth
                                                .instance.currentUser!.email !=
                                            viewModel.emailController.text) {
                                          viewModel
                                              .showFailedSnackBarName(context);
                                        } else {
                                          viewModel.showFailedSnackBarPassword(
                                              context);
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                        minimumSize:
                                            WidgetStateProperty.all<Size>(
                                          Size.fromHeight(MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07),
                                        ),
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.indigo.shade400)),
                                    child: const Text(
                                      "Đăng nhập",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: AppFontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey,
                                          thickness: 1.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          'Hoặc',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: AppFontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey,
                                          thickness: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                  ElevatedButton(
                                    onPressed: () async {
                                      var user =
                                          await viewModel.signInWithGoogle();
                                      if (user != null) {
                                        // AppSP.set(AppSPKey.userinfo,
                                        //     viewModel.user!.email);
                                        viewModel.showSuccessSnackBar(context);
                                      }
                                    },
                                    style: ButtonStyle(
                                        minimumSize:
                                            WidgetStateProperty.all<Size>(
                                          Size.fromHeight(MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07),
                                        ),
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.white)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  35),
                                          child: Image(
                                            image: AssetImage(Img.imgGG),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                30,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                20,
                                          ),
                                        ),
                                        const Text(
                                          "Đăng nhập với Google",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                              fontWeight: AppFontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.03),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Bạn chưa có tài khoản?",
                                        style: TextStyle(
                                            color: AppColor.extraColor,
                                            fontSize: AppFontSize.sizeMedium,
                                            fontWeight: AppFontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          viewModel.signup();
                                        },
                                        child: Text(
                                          " Đăng ký",
                                          style: TextStyle(
                                              color: Colors.indigo.shade400,
                                              fontSize: AppFontSize.sizeMedium,
                                              fontWeight: AppFontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "Quên mật khẩu",
                                          style: TextStyle(
                                              color: Colors.indigo.shade400,
                                              fontSize: AppFontSize.sizeMedium,
                                              fontWeight: AppFontWeight.bold),
                                        ),
                                      )
                                    ],
                                  )
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
              ],
            ),
          );
        });
  }
}
