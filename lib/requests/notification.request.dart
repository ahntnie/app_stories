import 'dart:convert';

import 'package:app_stories/models/notification_model.dart';
import 'package:app_stories/services/api_service.dart';

import '../app/app_sp.dart';
import '../app/app_sp_key.dart';
import '../constants/api.dart';
import '../models/user_model.dart';

class NotificationRequest extends ApiService {
  Future<List<Notification>> getNotification() async {
    List<Notification> notifications = [];
    Users currentUser =
        Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
    final response = await ApiService().getRequest(
        '${Api.hostApi}${Api.getNotificationByUserId}/${currentUser.id}');
    List<dynamic> lstNotification =
        jsonDecode(jsonEncode(response.data["data"]));
    notifications =
        lstNotification.map((notify) => Notification.fromJson(notify)).toList();
    return notifications;
  }

  Future<String?> markAsReadNotification(int notifyId) async {
    String? errorString;
    try {
      final response = await ApiService().patchRequest(
          '${Api.hostApi}${Api.markAsReadNotification}/$notifyId', null);
      if (response.statusCode == 200) {
        errorString = null;
      } else {
        errorString = response.data['message'].toString();
      }
    } catch (e) {
      errorString = e.toString();
    }
    return errorString;
  }
}
