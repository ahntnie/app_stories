import 'dart:async';

import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/views/profile/widget/custom/material_ink_well.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomMenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool showLead;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  const CustomMenuButton({
    required this.icon,
    required this.text,
    required this.onTap,
    this.showLead = true,
    this.switchValue,
    this.onSwitchChanged,
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
            HugeIcon(
              icon: icon,
              color: context.primaryTextColor,
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: AppTheme.bodyLarge16,
              ),
            ),
            if (!showLead && switchValue != null && onSwitchChanged != null)
              Switch(
                value: switchValue!,
                onChanged: onSwitchChanged!,
                activeColor: Colors.white,
                activeTrackColor: Colors.blue,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.black26,
              )
            else if (showLead)
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



// if (!showLead && switchValue != null && onSwitchChanged != null)
//               Switch(
//                 value: switchValue!,
//                 onChanged: onSwitchChanged!,
//                 activeColor: Colors.white,
//                 activeTrackColor: Colors.blue,
//                 inactiveThumbColor: Colors.white,
//                 inactiveTrackColor: Colors.black26,
//               )
//             else if (showLead)
//               Icon(Icons.arrow_forward_ios, color: Colors.white),