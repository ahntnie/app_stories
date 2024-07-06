import 'package:app_stories/view_model/notification.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => NotificationViewModel(),
      builder: (context, viewModel, child) {
        return BasePage(
            title: 'Thông báo',
            showAppBar: true,
            body: const Center(
              child: Text('Trang thông báo'),
            ));
      },
    );
  }
}
