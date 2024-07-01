import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPasswordController = TextEditingController();
  final String _apiKey =
      'AIzaSyCjkNznq8DoDKDk6q1l5Ebn6oX3xx43rJ4'; // Thay thế bằng API key của bạn
  final String _idToken =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6ImYwOGU2ZTNmNzg4ZDYwMTk0MDA1ZGJiYzE5NDc0YmY5Mjg5ZDM5ZWEiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoiYmFjaGFuaHRpZW4iLCJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vYXBwLXN0b3JpZXMtN2U2NjMiLCJhdWQiOiJhcHAtc3Rvcmllcy03ZTY2MyIsImF1dGhfdGltZSI6MTcxOTU4MTY5NywidXNlcl9pZCI6IjhDVWRpYUptaklmZFhZS1lZOXg1bVFQR3BqTTIiLCJzdWIiOiI4Q1VkaWFKbWpJZmRYWUtZWTl4NW1RUEdwak0yIiwiaWF0IjoxNzE5NTgxNjk3LCJleHAiOjE3MTk1ODUyOTcsImVtYWlsIjoiYmFjaGFuaHRpZW5kcDMwMDRAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImJhY2hhbmh0aWVuZHAzMDA0QGdtYWlsLmNvbSJdfSwic2lnbl9pbl9wcm92aWRlciI6InBhc3N3b3JkIn19.fdfW2ENQ-_jp7NWI__g_wu2ExfXYY7L5jsqxTuL_mNz6as-JEn5t2KdXQjslqCbEDAl6bfubeUyULm1XwSGY_NO7qUQI5Ie1GCwmhxSK_VXVKMvySSNlc-FogPOC-UOALGYQNA8wwCz-niHjzuM8YzDIXaURX78aUFuVTTQADoDDlTGXxG50hLHce3ax0Uy5Ei_EXMkFpIT_lvPG8-DUZXx86k1iKxw3wZTtsAOY__bVJH-eAtHqD9Og9xH1v5ckH_OBY9fnodVNJF5shwvDtIjPhWxk54QeH0Li5XR6ZyCDTidnU9hRBXd50t4FS9sWTeGVwJZS890CW4VH37-uig'; // Thay thế bằng ID token của người dùng

  Future<void> _changePassword() async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$_apiKey';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'idToken': _idToken,
        'password': _newPasswordController.text,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode == 200) {
      print('Password changed successfully.');
    } else {
      print('Error: ${json.decode(response.body)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChangePasswordScreen(),
  ));
}
