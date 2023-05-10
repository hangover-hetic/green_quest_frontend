import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({required Key key}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(54);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff0f8f7f5),
      elevation: 0,
      leading: IconButton(
        icon: Image.asset('assets/images/icons/backIcon.png'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
