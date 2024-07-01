// import 'package:stacked/stacked.dart';
// import '../services/firestore_service.dart';
// import '../models/user_model.dart';

// class InputViewModel extends BaseViewModel {
//   final FirestoreService _firestoreService = FirestoreService();
//   String name = '';
//   String email = '';
//   int age = 0;
//   String password = '';

//   void setName(String value) {
//     name = value;
//     notifyListeners();
//   }

//   void setEmail(String value) {
//     email = value;
//     notifyListeners();
//   }

//   void setAge(int value) {
//     age = value;
//     notifyListeners();
//   }

//   Future<void> addUser() async {
//     if (name.isNotEmpty && email.isNotEmpty) {
//       await _firestoreService
//           .addUser(Users(id: '', name: name, email: email, age: 0,password:  password));
//       name = '';
//       email = '';
//       age = 0;
//       notifyListeners();
//     }
//   }
// }
