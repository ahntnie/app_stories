import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/view_model/signup.vm.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'widget/textfield_authentication.dart';

class SignupAuthorPage extends StatefulWidget {
  const SignupAuthorPage({super.key});

  @override
  State<SignupAuthorPage> createState() => _SignupAuthorPageState();
}

class _SignupAuthorPageState extends State<SignupAuthorPage> {
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/img_login.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: SizedBox(
                            height: 110,
                            width: 110,
                            child: Image.asset('assets/ic_logo.png')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Đăng ký tác giả",
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
                            CustomTextField(
                              labelText: "Tên bút danh",
                              hintText: "",
                              controller: viewModel.penNameController,
                              errorText: '',
                              onChanged: (value) {
                                viewModel.validateAccountName();
                                viewModel.setName(value);
                              },
                            ),
                            CustomTextField(
                              labelText: "Mô tả ngắn gọn về bản thân",
                              hintText: "",
                              controller: viewModel.bioController,
                              errorText: '',
                              onChanged: (value) {
                                viewModel.validateAccountName();
                                viewModel.setName(value);
                              },
                            ),
                            CustomTextField(
                              labelText:
                                  "Liên kết tới các tác phẩm trước đây (nếu có)",
                              hintText: "",
                              controller: viewModel.previousWorksController,
                              errorText: '',
                              onChanged: (value) {
                                viewModel.validateAccountName();
                                viewModel.setName(value);
                              },
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                viewModel.validateAccountName();
                                viewModel.validatePassword();
                                viewModel.validateRepassword();
                                viewModel.validateEmail();
                                if (viewModel.accountNameError.isEmpty &&
                                    viewModel.accountPasswordError.isEmpty &&
                                    viewModel.repasswordError.isEmpty &&
                                    viewModel.emailError.isEmpty) {
                                  viewModel.signupAuthor();
                                  viewModel.showSuccessSnackBar(context);
                                } else {
                                  viewModel.showFailedSnackBar(context);
                                }
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                  Size.fromHeight(
                                    MediaQuery.of(context).size.height * 0.07,
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
        );
      },
    );
  }
}
