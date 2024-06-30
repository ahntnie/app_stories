// import 'package:stacked/stacked.dart';
// import '../services/firestore_service.dart';
// import '../models/user_model.dart';

// class InputViewModel extends BaseViewModel {
//   final FirestoreService _firestoreService = FirestoreService();
//   String name = '';
//   String email = '';

//   void setName(String value) {
//     name = value;
//     notifyListeners();
//   }

//   void setEmail(String value) {
//     email = value;
//     notifyListeners();
//   }

//   Future<void> addUser() async {
//     if (name.isNotEmpty && email.isNotEmpty) {
//       await _firestoreService.addUser(User(id: '', name: name, email: email));
//       name = '';
//       email = '';
//       notifyListeners();
//     }
//   }
// }
