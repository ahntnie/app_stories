class Api {
  static const String hostApi =
      'https://balanced-secure-titmouse.ngrok-free.app/api';
  static const String hostImage =
      'https://balanced-secure-titmouse.ngrok-free.app';

  //Story
  static const String postStory = '/stories';
  static const String getMyStories = '/stories';
  static const String approveStory = '/stories/approve';
  static const String getTotalStories = '/total/storise';

  //View Story
  static const String addViewStory = '/story/view';

  //Favourite
  static const String postLike = '/favourite-story';
  static const String unLike = '/delete-favourite-story';

  //Category
  static const String getCategories = '/categories';

  //Chapter
  static const String getChapters = '/chapters';
  static const String postChapters = '/chapters';

  //User
  static const String getUser = '/users';

  //Notification
  static const String getNotificationByUserId = '/notifications/user';
  static const String markAsReadNotification = '/notifications/read';

  //Comment
  static const String comment = '/comment';
  static const String commentStory = '/comments/bystory';

  //authen-firebase
  static const apiKeyAuth = 'AIzaSyCjkNznq8DoDKDk6q1l5Ebn6oX3xx43rJ4';
  static const String apiAuth =
      'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$apiKeyAuth';
}
