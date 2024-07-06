import 'package:app_stories/models/notification_model.dart';
import 'package:app_stories/services/api_service.dart';

class NotificationRequest extends ApiService {
  Future<List<Notification>> getNotification() async {
    List<Notification> notifications = [];
    return notifications;
  }
}
