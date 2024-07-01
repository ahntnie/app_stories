// import 'package:stacked/stacked.dart';
// import '../services/firestore_service.dart';
// import '../models/user_model.dart';

// class UsersViewModel extends BaseViewModel {
//   final FirestoreService _firestoreService = FirestoreService();

//   List<User> _users = [];
//   List<User> get users => _users;

//   void listenToUsers() {
//     _firestoreService.getUsers().listen((usersData) {
//       _users = usersData;
//       print('Chiều dài: ${_users.length}');
//       notifyListeners();
//     });
//   }
// }
