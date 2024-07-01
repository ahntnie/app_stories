import 'package:app_stories/view_model/profile.vm.dart';
import 'package:app_stories/views/profile/widget/custom/accountitem.widget.dart';
import 'package:app_stories/views/profile/widget/custom/menuitem.widget.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
          viewModel.fetchCurrentUser();
        },
        builder: (context, viewModel, child) {
          return BasePage(
              title: 'Tài khoản và bảo mật',
              body: Container(
                child: viewModel.isBusy
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          CustomMenuAccount(
                            text: 'Tài khoản',
                            text1: viewModel.currentUserData!['username'] ?? '',
                            onTap: () {
                              viewModel.changeNameAccount();
                            },
                          ),
                          CustomMenuAccount(
                            text: 'Độ tuổi',
                            text1: viewModel.currentUserData!['age'] >= 18
                                ? 'Tôi đã đủ 18 tuổi trở lên'
                                : 'Tôi chưa đủ 18 tuổi',
                            onTap: () {
                              viewModel.checkAgeAndShowDialog();
                            },
                          ),
                          CustomMenuAccount(
                            text: 'Email',
                            text1: viewModel.currentUserData!['email'] ?? '',
                            onTap: () {},
                          ),
                          CustomMenuAccount(
                            text: 'Thay đổi mật khẩu',
                            text1: '',
                            onTap: () {
                              viewModel.changPassword();
                            },
                          ),
                        ],
                      ),
              ));
        });
  }
}
