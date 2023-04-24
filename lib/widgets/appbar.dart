import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({super.key}) : preferredSize = Size.fromHeight(54.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff0F8F7F5),
      //centrer verticalement l'image du bouton retour

      automaticallyImplyLeading: true,
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
