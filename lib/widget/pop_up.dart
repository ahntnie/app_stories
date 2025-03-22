import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_color.dart';

class PopUpWidget extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? leftText;
  final String? rightText;
  final bool twoButton;
  final Function()? onLeftTap;
  final Function()? onRightTap;

  const PopUpWidget({
    super.key,
    required this.icon,
    required this.title,
    this.leftText,
    this.rightText,
    this.twoButton = false,
    required this.onLeftTap,
    this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.rambutan70,
              AppColors.watermelon80,
            ],
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 80,
              child: icon,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: AppColors.mono0,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 1,
              color: AppColors.mono0.withOpacity(0.5),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildButton(
                    text: leftText ?? 'XÁC NHẬN',
                    onTap: onLeftTap,
                    borderRadius: twoButton
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(20))
                        : const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                  ),
                ),
                if (twoButton)
                  const SizedBox(width: 10), // Khoảng cách giữa 2 nút
                if (twoButton)
                  Expanded(
                    child: _buildButton(
                      text: rightText ?? 'HỦY',
                      onTap: onRightTap,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20)),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Function()? onTap,
    required BorderRadius borderRadius,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: AppColors.mono0.withOpacity(0.3),
        highlightColor: AppColors.mono0.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: AppColors.mono0.withOpacity(0.1),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: AppColors.mono0,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
