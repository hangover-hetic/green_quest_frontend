import 'package:flutter/material.dart';
import 'package:green_quest_frontend/style/colors.dart';

class LoadingViewWidget extends StatelessWidget {
  const LoadingViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          color: green,
        ),
      ),
    );
  }
}
