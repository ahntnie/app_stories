import 'package:app_stories/styles/font.dart';
import 'package:app_stories/styles/img.dart';
import 'package:app_stories/view_model/login.vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

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
                            "Đăng nhập",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize.sizeTitle,
                                fontWeight: fontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Số điện thoại",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: fontSize.sizeMedium,
                                      fontWeight: fontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.025),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'SĐT của bạn',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.025),
                              ElevatedButton(
                                onPressed: () {
                                  viewModel.login();
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
                                  "Đăng nhập",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: fontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.025),
                              const Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 1.0,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      'Hoặc',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: fontWeight.bold),
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
                                  height: MediaQuery.of(context).size.height *
                                      0.025),
                              ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    minimumSize: WidgetStateProperty.all<Size>(
                                      Size.fromHeight(
                                          MediaQuery.of(context).size.height *
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                20,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                20,
                                      ),
                                    ),
                                    const Text(
                                      "Đăng nhập với Google",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 28,
                                          fontWeight: fontWeight.bold),
                                    ),
                                  ],
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
