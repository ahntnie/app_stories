import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/views/profile/widget/custom/material_ink_well.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomMenuAccount extends StatelessWidget {
  final String text;
  final String text1;
  final VoidCallback onTap;

  const CustomMenuAccount({
    super.key,
    required this.text,
    required this.text1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialInkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: AppTheme.bodyLarge16,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text1,
                style: AppTheme.bodyLarge16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowRight01,
                color: context.primaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
