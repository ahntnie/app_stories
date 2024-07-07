import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/view_model/notification.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

import 'widget/notification_card.dart';

class NotificationPage extends StatefulWidget {
  final NotificationViewModel notificationViewModel;
  const NotificationPage({super.key, required this.notificationViewModel});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => widget.notificationViewModel,
      onViewModelReady: (viewModel) async {
        viewModel.viewContext = context;
      },
      builder: (context, viewModel, child) {
        return BasePage(
            isLoading: viewModel.isBusy,
            title: 'Thông báo',
            showAppBar: true,
            body: viewModel.notifications.isNotEmpty
                ? ListView.builder(
                    itemCount: viewModel.notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationCard(
                        notificationViewModel: viewModel,
                        notification: viewModel.notifications[index],
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/ic_empty.png'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Dữ liệu trống',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Text(
                          'Chưa có dữ liệu ở thời điểm hiện tại',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                        )
                      ],
                    ),
                  ));
      },
    );
  }
}
