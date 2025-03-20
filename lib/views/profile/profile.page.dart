import 'dart:convert';

import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/constants/themes/theme.serivce.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/view_model/profile.vm.dart';
import 'package:app_stories/views/managerstories/managerstories.dart';
import 'package:app_stories/views/profile/widget/acount.view.dart';
import 'package:app_stories/views/profile/widget/custom/menuitem.widget.dart';
import 'package:app_stories/views/profile/widget/story.favourite.widget.dart';
import 'package:app_stories/views/profile/widget/story.view.dart';
import 'package:app_stories/views/report/report.page.dart';
import 'package:app_stories/views/stories/my_stories.page.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:app_stories/widget/next_login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';

import '../../app/app_sp.dart';
import '../../app/app_sp_key.dart';
import '../../models/user_model.dart';
import '../../view_model/home.vm.dart';
import '../browse_author/browse_author.page.dart';
import '../categories/categories.page.dart';
import 'report_admin.page.dart';

class ProfilePage extends StatefulWidget {
  final HomeViewModel homeViewModel;
  final ProfileViewModel viewModel;
  const ProfilePage(
      {super.key, required this.homeViewModel, required this.viewModel});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ComicViewModel comicViewModel;
  final themeService = GetIt.instance<ThemeService>(); // Lấy ThemeService
  bool isDarkMode = false;
  @override
  void initState() {
    super.initState();
    isDarkMode = themeService.isDarkMode;
  }

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
    themeService.toggleTheme(); // Gọi hàm đổi theme
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => widget.viewModel,
      disposeViewModel: false,
      onViewModelReady: (viewModel) async {
        viewModel.viewContext = context;
        if ((AppSP.get(AppSPKey.currrentUser) != null &&
            AppSP.get(AppSPKey.currrentUser) != '')) {
          viewModel.currentUser =
              Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
          viewModel.notifyListeners();
          comicViewModel = ComicViewModel();
          await comicViewModel.getStoryFavourite();
        }
      },
      builder: (context, viewModel, child) {
        return BasePage(
          showLeading: false,
          title: 'CÁ NHÂN',
          showLogout: (AppSP.get(AppSPKey.currrentUser) != null &&
                  AppSP.get(AppSPKey.currrentUser) != '')
              ? true
              : false,
          body: (AppSP.get(AppSPKey.currrentUser) != null &&
                  AppSP.get(AppSPKey.currrentUser) != '')
              ? Container(
                  child: viewModel.isBusy
                      ? const Center(child: GradientLoadingWidget())
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.008),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppColors.blueberry80,
                                                AppColors.watermelon80
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.12,
                                            backgroundColor:
                                                context.primaryBackgroundColor,
                                            child: CircleAvatar(
                                              backgroundColor: context
                                                  .primaryBackgroundColor,
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.115,
                                              backgroundImage:
                                                  AssetImage(Img.imgAVT),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                viewModel.currentUser!.name
                                                    .toString(),
                                                style: AppTheme.titleMedium18),
                                            SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.005),
                                            Text(
                                                viewModel.currentUser!.email
                                                    .toString(),
                                                style: AppTheme.titleMedium18),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              CustomMenuButton(
                                icon: CupertinoIcons.lock_fill,
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
                                showLead: false,
                                icon: CupertinoIcons.sun_max_fill,
                                text: 'Chế độ sáng tối',
                                switchValue: isDarkMode,
                                onSwitchChanged: toggleTheme,
                                onTap: () {},
                              ),
                              CustomMenuButton(
                                icon: CupertinoIcons.heart_fill,
                                text: 'Truyện đã theo dõi',
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => FavouriteStory(
                                            comicViewModel: comicViewModel,
                                          )));
                                },
                              ),
                              CustomMenuButton(
                                icon: CupertinoIcons.timer,
                                text: 'Lịch sử đọc truyện',
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ViewStory(
                                            comicViewModel: comicViewModel,
                                          )));
                                },
                              ),
                              if (viewModel.currentUser!.role != 'admin') ...[
                                CustomMenuButton(
                                  icon: CupertinoIcons.info,
                                  text: 'Giới thiệu về chúng tôi',
                                  onTap: () {},
                                ),
                                CustomMenuButton(
                                  icon: CupertinoIcons.lock,
                                  text: 'Chính sách bảo mật',
                                  onTap: () {},
                                ),
                                CustomMenuButton(
                                  icon: CupertinoIcons.bookmark_fill,
                                  text: 'Điều khoản dịch vụ',
                                  onTap: () {},
                                ),
                              ],
                              if (viewModel.currentUser!.role != 'admin' &&
                                  viewModel.currentUser!.role == 'author') ...[
                                if (viewModel.currentUser!.role == 'author')
                                  CustomMenuButton(
                                    icon: CupertinoIcons.arrow_down_doc_fill,
                                    text: 'Quản lý truyện đăng',
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyStoriesPage()));
                                    },
                                  ),
                                if (viewModel.currentUser!.role == 'author')
                                  CustomMenuButton(
                                    icon: CupertinoIcons.doc_chart_fill,
                                    text: 'Thống kê',
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ReportPage(
                                                  //profileViewModel: viewModel,
                                                  )));
                                    },
                                  ),
                              ],
                              if (viewModel.currentUser!.role == 'admin') ...[
                                CustomMenuButton(
                                  icon: Icons.menu_book_sharp,
                                  text: 'Thống kê',
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ReportAdminPage(
                                                  profileViewModel: viewModel,
                                                )));
                                  },
                                ),
                                CustomMenuButton(
                                  icon: Icons.manage_accounts_sharp,
                                  text: 'Phê duyệt tác giả',
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BrowseAuthorPage()));
                                  },
                                ),
                                CustomMenuButton(
                                  icon: Icons.description,
                                  text: 'Quản lí thể loại',
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CategoriesPage()));
                                  },
                                ),
                                CustomMenuButton(
                                  icon: Icons.menu_book,
                                  text: 'Quản lí truyện đăng',
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ManagerStories()));
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                )
              : NextLoginPage(
                  title: 'Bạn cần đăng nhập',
                ),
        );
      },
    );
  }
}
