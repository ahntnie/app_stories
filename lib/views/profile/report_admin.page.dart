import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/view_model/report.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/profile.vm.dart';

class ReportAdminPage extends StatelessWidget {
  final ProfileViewModel profileViewModel;
  ReportAdminPage({required this.profileViewModel});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => ReportViewModel(),
      onViewModelReady: (viewModel) {
        viewModel.init();
      },
      builder: (context, viewModel, child) {
        return BasePage(
          showAppBar: true,
          title: 'Thống kê',
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: AppColor.bottomSheetColor,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 100,
                            decoration: BoxDecoration(
                                color: AppColor.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Truyện mới',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${viewModel.totalNewStories}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 100,
                            decoration: BoxDecoration(
                                color: AppColor.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Người dùng mới',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${viewModel.totalNewUsers}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            width: MediaQuery.of(context).size.width / 2.3,
                            height: 100,
                            decoration: BoxDecoration(
                                color: AppColor.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Tổng truyện',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${viewModel.totalStories}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.symmetric(
                          //       vertical: 5, horizontal: 5),
                          //   width: MediaQuery.of(context).size.width / 2.3,
                          //   height: 100,
                          //   decoration: BoxDecoration(
                          //       color: AppColor.primary,
                          //       borderRadius: BorderRadius.circular(10)),
                          //   child: Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Text(
                          //         'Tăng trưởng',
                          //         style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 20,
                          //             fontWeight: FontWeight.w500),
                          //       ),
                          //       Text(
                          //         '${viewModel.totalStories}%',
                          //         style: TextStyle(
                          //             color: Colors.white, fontSize: 25),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    onPressed: () {
                      if (viewModel.type == 'week')
                        viewModel.changeType('month');
                      else
                        viewModel.changeType('week');
                    },
                    title: Text(
                      viewModel.type == 'week'
                          ? 'Lọc theo tháng'
                          : 'Lọc theo tuần',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
