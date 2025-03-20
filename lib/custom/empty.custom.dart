import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:flutter/cupertino.dart';

class EmptyCustom extends StatefulWidget {
  const EmptyCustom({super.key});

  @override
  State<EmptyCustom> createState() => _EmptyCustomState();
}

class _EmptyCustomState extends State<EmptyCustom> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/ic_empty.png'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('Dữ liệu trống', style: AppTheme.titleLarge20),
          ),
          Text('Chưa có dữ liệu ở thời điểm hiện tại',
              style: AppTheme.titleSmall16),
          SizedBox(
            height: MediaQuery.of(context).size.height / 4,
          )
        ],
      ),
    );
  }
}
