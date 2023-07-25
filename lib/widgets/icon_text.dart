import 'package:flutter/cupertino.dart';

class IconText extends StatelessWidget {
  const IconText(
      {required this.icon, required this.text, this.style, super.key});

  final IconData icon;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: style,
        )
      ],
    );
  }
}
