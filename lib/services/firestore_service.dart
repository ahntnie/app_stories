import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> storeDeviceInfo() async {
  User? user = _auth.currentUser;
  if (user != null) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String deviceId = androidInfo.id;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('devices')
        .doc(deviceId)
        .set({
      'deviceId': deviceId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

Future<void> signIn(String email, String password) async {
  await _auth.signInWithEmailAndPassword(email: email, password: password);
  await storeDeviceInfo();
}
