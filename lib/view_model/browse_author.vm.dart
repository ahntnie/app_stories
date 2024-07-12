import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/user_model.dart';
import '../widget/pop_up.dart';
import 'profile.vm.dart';

class BrowseAuthorViewModel extends BaseViewModel {
  final BuildContext context;
  BrowseAuthorViewModel({required this.context});
  List<Users> authorNotActive = [];
  Future<void> getAuthorNotActive() async {
    setBusy(true);
    authorNotActive = await ProfileViewModel().getAuthorNotActive();
    setBusy(false);
    notifyListeners();
  }

  Future<void> approveAuthor(String userId) async {
    setBusy(true);
    String? errorString = await ProfileViewModel().approveAuthor(userId);
    if (errorString != null) {
      setBusy(false);
      showDialog(
          context: context,
          builder: (context) {
            return PopUpWidget(
              icon: Image.asset("assets/ic_error.png"),
              title: 'Lỗi: $errorString',
              leftText: 'Xác nhận',
              onLeftTap: () {
                Navigator.pop(context);
              },
            );
          });
    } else {
      setBusy(false);
      showDialog(
          context: context,
          builder: (context) {
            return PopUpWidget(
              icon: Image.asset("assets/ic_success.png"),
              title: 'Phê duyệt tác giả thành công',
              leftText: 'Xác nhận',
              onLeftTap: () {
                Navigator.pop(context);
              },
            );
          });
    }
    await getAuthorNotActive();
  }
}
