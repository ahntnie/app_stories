import 'package:app_stories/components/layoutOTPScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Layoutotpscreen(),
    );
  }
}
