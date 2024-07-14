import 'dart:convert';

import 'package:app_stories/models/chapter_model.dart';
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
    print(
        'Đường dẫn: ${Api.hostApi}${Api.getNotificationByUserId}/${currentUser.id}');
    final response = await ApiService().getRequest(
        '${Api.hostApi}${Api.getNotificationByUserId}/${currentUser.id}');
    List<dynamic> lstNotification =
        jsonDecode(jsonEncode(response.data["data"]));
    notifications =
        lstNotification.map((notify) => Notification.fromJson(notify)).toList();
    return notifications;
  }

  Future<void> postNotificationByAdmin(String idUser, String? message,
      String? title, int? is_read, int storyId, Chapter? chapter) async {
    Users currentUser =
        Users.fromJson(jsonDecode(AppSP.get(AppSPKey.currrentUser)));
    idUser = currentUser.id;
    Map<String, dynamic> notificationModel = {
      'user_id': idUser,
      'title': title,
      'message': message,
      'is_read': 0,
      'story_id': storyId,
      'chapter_id': chapter == null ? null : chapter.chapterId,
    };
    print(notificationModel);
    print('${Api.hostApi}${Api.postNotificationByAdmin}');
    await ApiService().postNotifications(
        '${Api.hostApi}${Api.postNotificationByAdmin}', notificationModel);
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
