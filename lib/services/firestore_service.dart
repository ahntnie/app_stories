import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User user) {
    return usersCollection
        .add(user.toMap())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Stream<List<User>> getUsers() {
    print('Vào getUsers trong services');
    return usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        print('Document data: ${doc.data()}');
        return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
