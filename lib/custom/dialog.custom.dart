import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/styles/app_img.dart';
import 'package:app_stories/views/profile/widget/custom/button.widget.dart';
import 'package:app_stories/views/profile/widget/custom/textfield.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomDialog {
  static Future<void> showCustomDialogAge(
      {required BuildContext context,
      required String title,
      required String message,
      required VoidCallback onPressed,
      required VoidCallback onPressed2,
      required String confirmText,
      required String unConfirmText,
      required Color confirmColor,
      required Color unConfirmColor,
      String? hintext}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.diaglogColor,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  Img.imgAVT,
                  width: 80,
                  height: 80,
                ),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: AppFontSize.sizeMedium,
                      color: AppColor.extraColor),
                  textAlign: TextAlign.center,
                ),
                Text(
                  message,
                  style: TextStyle(
                      fontSize: AppFontSize.sizeSmall,
                      color: AppColor.extraColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                        nameButton: confirmText,
                        onPressed: onPressed,
                        color: confirmColor)),
                SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                        color: unConfirmColor,
                        nameButton: unConfirmText,
                        onPressed: onPressed2)),
              ],
            ),
          ],
        );
      },
    );
  }
}
