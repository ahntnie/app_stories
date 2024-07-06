import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/view_model/mystories.vm.dart';
import 'package:app_stories/view_model/profile.vm.dart';
import 'package:app_stories/views/profile/widget/acount.view.dart';
import 'package:app_stories/views/profile/widget/custom/menuitem.widget.dart';
import 'package:app_stories/views/stories/my_stories.page.dart';
import 'package:app_stories/views/stories/post_stories.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          showLeading: false,
          title: 'Cá nhân',
          showLogout: true,
          body: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            //left: MediaQuery.of(context).size.width * 0.06),
            child: viewModel.isBusy
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.07,
                          ),
                          CircleAvatar(
                            backgroundImage: AssetImage(Img.imgAVT),
                            minRadius: 45,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Text(
                            viewModel.currentUserData!['username'].toString(),
                            style: TextStyle(
                                color: AppColor.extraColor,
                                fontSize: AppFontSize.sizeMedium),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.1,
                      ),
                      CustomMenuButton(
                        icon: Icons.security,
                        text: 'Tài khoản và Bảo mật',
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => AccountView(
                                      profileViewModel: viewModel,
                                    )),
                          ); //
                        },
                      ),
                      CustomMenuButton(
                        icon: Icons.feedback,
                        text: 'Phản hồi ý kiến',
                        onTap: () {},
                      ),
                      CustomMenuButton(
                        icon: Icons.info,
                        text: 'Giới thiệu về chúng tôi',
                        onTap: () {},
                      ),
                      CustomMenuButton(
                        icon: Icons.lock,
                        text: 'Chính sách bảo mật',
                        onTap: () {},
                      ),
                      CustomMenuButton(
                        icon: Icons.description,
                        text: 'Điều khoản dịch vụ',
                        onTap: () {},
                      ),
                      CustomMenuButton(
                        icon: Icons.add_circle,
                        text: 'Đăng truyện',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyStoriesPage()));
                        },
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
