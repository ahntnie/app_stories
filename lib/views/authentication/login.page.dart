import 'dart:convert';

import 'package:app_stories/app/app_sp.dart';
import 'package:app_stories/app/app_sp_key.dart';
import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/view_model/login.vm.dart';
import 'package:app_stories/views/authentication/widget/textfield_authentication.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    // Các giá trị linh hoạt dựa trên kích thước màn hình
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.06; // 6% chiều rộng màn hình
    final double buttonHeight = screenHeight * 0.07; // 7% chiều cao màn hình
    final double spacing = screenHeight * 0.02; // 2% chiều cao màn hình

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onViewModelReady: (viewModel) => viewModel.viewContext = context,
      builder: (context, viewModel, child) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                // Background Image
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Img.imgLogin),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        AppColors.mono100.withOpacity(0.3),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
                // Login Form
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.2, // 15% chiều cao
                          width: screenWidth * 0.25, // 25% chiều rộng
                          child: Image.asset('assets/ic_logo.png'),
                        ),
                        SizedBox(height: spacing * 1.5),
                        Container(
                          padding: EdgeInsets.all(padding),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.mono40,
                              width: 1,
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(padding / 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.mono100.withOpacity(0.1),
                                blurRadius: padding / 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                labelText: "Email",
                                hintText: "abc@gmail.com",
                                controller: viewModel.emailController,
                                errorText: viewModel.emailError,
                                onChanged: (value) =>
                                    viewModel.validateEmail(value),
                              ),
                              SizedBox(height: spacing),
                              CustomTextField(
                                labelText: "Mật khẩu",
                                hintText: "Nhập mật khẩu",
                                controller: viewModel.passwordController,
                                obscureText: viewModel.obscureText,
                                errorText: viewModel.accountPasswordError,
                                onChanged: (value) =>
                                    viewModel.validatePassword(value),
                                onSuffixIconTap: viewModel.showhidePassword,
                                hasSuffixIcon: true,
                              ),
                              SizedBox(height: spacing * 1.5),
                              ElevatedButton(
                                onPressed: () => _handleEmailLogin(viewModel),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.watermelon100,
                                  foregroundColor: Colors.white,
                                  minimumSize:
                                      Size(double.infinity, buttonHeight),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(padding / 2),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  "Đăng nhập",
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        screenWidth * 0.045, // 4.5% chiều rộng
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(height: spacing),
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                        color: AppColors.mono60, thickness: 1),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: padding / 2),
                                    child: Text(
                                      'Hoặc',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.mono20,
                                        fontSize: screenWidth *
                                            0.035, // 3.5% chiều rộng
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                        color: AppColors.mono60, thickness: 1),
                                  ),
                                ],
                              ),
                              SizedBox(height: spacing),
                              OutlinedButton(
                                onPressed: () => _handleGoogleLogin(viewModel),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.mono100,
                                  minimumSize:
                                      Size(double.infinity, buttonHeight),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(padding / 2),
                                  ),
                                  side: BorderSide(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Img.imgGG,
                                      width: screenWidth * 0.06,
                                      height: screenHeight * 0.03,
                                    ),
                                    SizedBox(width: padding / 2),
                                    Text(
                                      "Đăng nhập với Google",
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.mono100,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: spacing * 1.5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      "Quên mật khẩu?",
                                      style: GoogleFonts.poppins(
                                        color: AppColors.rambutan100,
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: viewModel.signup,
                                    child: Text(
                                      "Đăng ký",
                                      style: GoogleFonts.poppins(
                                        color: AppColors.rambutan100,
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Loading Overlay
                if (viewModel.isBusy)
                  Container(
                    color: AppColors.mono100.withOpacity(0.5),
                    child: const Center(
                      child: GradientLoadingWidget(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleEmailLogin(LoginViewModel viewModel) async {
    var user = await viewModel.loginUsingEmailPassword();
    if (user != null) {
      AppSP.set(AppSPKey.userinfo, viewModel.user!.uid);
      Users currentUser =
          Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
      if (!currentUser.isActive!) {
        viewModel.showFailedIsActiveSnackBar(context);
      } else {
        viewModel.showSuccessSnackBar(context);
      }
    } else {
      viewModel.validateEmail(viewModel.emailController.text);
      viewModel.validatePassword(viewModel.passwordController.text);
      if (viewModel.emailController.text.isEmpty ||
          viewModel.passwordController.text.isEmpty) {
        viewModel.showFailedSnackBarEmpty(context);
      } else if (FirebaseAuth.instance.currentUser?.email !=
          viewModel.emailController.text) {
        viewModel.showFailedSnackBarName(context);
      } else {
        viewModel.showFailedSnackBarPassword(context);
      }
    }
  }

  Future<void> _handleGoogleLogin(LoginViewModel viewModel) async {
    var user = await viewModel.signInWithGoogle();
    if (user != null) {
      viewModel.showSuccessSnackBar(context);
    }
  }
}
