import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_quest_frontend/utils/preferences.dart';

class MenuButtonWidget extends StatefulWidget {
  const MenuButtonWidget({super.key});

  @override
  State<MenuButtonWidget> createState() => _MenuButtonWidgetState();
}

class _MenuButtonWidgetState extends State<MenuButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: const Color(0xFF0E756E),
          ),
          child: const Icon(
            Icons.menu,
            size: 30,
            color: Colors.white,
          ),
        ),
        items: [
          ...MenuItems.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value as MenuItem);
        },
        dropdownStyleData: const DropdownStyleData(
          elevation: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            color: Colors.white,
          ),
        ),
        buttonStyleData: const ButtonStyleData(elevation: 8),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(MenuItems.firstItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 14),
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

class MenuItems {
  static const List<MenuItem> firstItems = [ranking, shop, settings, logout];

  static const ranking = MenuItem(text: '', icon: Icons.spa_outlined);
  static const shop = MenuItem(text: '', icon: Icons.shopping_cart_outlined);
  static const settings = MenuItem(text: '', icon: Icons.settings_outlined);
  static const logout = MenuItem(text: '', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        ColoredBox(
          color: Colors.transparent,
          child: Icon(item.icon, color: const Color(0xFF0E756E), size: 30),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.ranking:
        context.go('/ranking');
        break;
      case MenuItems.shop:
        context.go('/shop');
        break;
      case MenuItems.settings:
        context.go('/settings');
        break;
      case MenuItems.logout:
        setToken('');
        context.go('/login');
        break;
    }
  }
}
