import 'dart:math';

import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/view_model/signup.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:app_stories/views/authentication/widget/textfield_authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'signup_author.page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    // Giá trị linh hoạt dựa trên kích thước màn hình
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.06;
    final double buttonHeight = screenHeight * 0.07;
    final double spacing = screenHeight * 0.02;

    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      onViewModelReady: (viewModel) => viewModel.viewContext = context,
      builder: (context, viewModel, child) {
        return SafeArea(
          child: BasePage(
            showAppBar: false,
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
                // Signup Form
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
                                labelText: "Tên người dùng",
                                hintText: "abc",
                                controller: viewModel.accountNameController,
                                errorText: viewModel.accountNameError,
                                onChanged: (value) {
                                  viewModel.validateAccountName(value);
                                  viewModel.setName(value);
                                },
                              ),
                              // SizedBox(height: spacing / 2),
                              CustomTextField(
                                labelText: "Email",
                                hintText: "abc@gmail.com",
                                controller: viewModel.emailController,
                                errorText: viewModel.emailError,
                                onChanged: (value) {
                                  viewModel.validateEmail(value);
                                  viewModel.setEmail(value);
                                },
                              ),
                              // SizedBox(height: spacing),
                              CustomTextField(
                                labelText: "Mật khẩu",
                                hintText: "Nhập mật khẩu",
                                controller: viewModel.passwordController,
                                obscureText: viewModel.obscureText,
                                errorText: viewModel.accountPasswordError,
                                onChanged: (value) {
                                  viewModel.validatePassword(value);
                                  viewModel.setPassword(value);
                                },
                                onSuffixIconTap: viewModel.showhidePassword,
                                hasSuffixIcon: true,
                              ),
                              // SizedBox(height: spacing),
                              CustomTextField(
                                labelText: "Nhập lại mật khẩu",
                                hintText: "Nhập lại mật khẩu",
                                controller: viewModel.repasswordController,
                                obscureText: viewModel.obscureText2,
                                errorText: viewModel.repasswordError,
                                onChanged: (value) =>
                                    viewModel.validateRepassword(value),
                                onSuffixIconTap: viewModel.showhideRePassword,
                                hasSuffixIcon: true,
                              ),
                              // SizedBox(height: spacing),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupAuthorPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Đăng ký tài khoản tác giả',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.rambutan100,
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: spacing * 1.5),
                              ElevatedButton(
                                onPressed: () => _handleSignup(viewModel),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.watermelon100,
                                  foregroundColor: AppColors.mono0,
                                  minimumSize:
                                      Size(double.infinity, buttonHeight),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(padding / 2),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  "Đăng ký",
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w600,
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

  Future<void> _handleSignup(SignUpViewModel viewModel) async {
    viewModel.validateAccountName(viewModel.accountNameController.text);
    viewModel.validateEmail(viewModel.emailController.text);
    viewModel.validatePassword(viewModel.passwordController.text);
    viewModel.validateRepassword(viewModel.repasswordController.text);
    if (viewModel.accountNameError == null &&
        viewModel.emailError == null &&
        viewModel.accountPasswordError == null &&
        viewModel.repasswordError == null) {
      await viewModel.signup();
    } else {
      viewModel.showFailedSnackBar(context);
    }
  }
}
