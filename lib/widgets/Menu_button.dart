import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class MenuButtonWidget extends StatefulWidget {
  const MenuButtonWidget({Key? key}) : super(key: key);

  @override
  State<MenuButtonWidget> createState() => _MenuButtonWidgetState();
}

class _MenuButtonWidgetState extends State<MenuButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: Container(

            height: 55,
            width: 55,
            child: const Icon(
              Icons.menu,
              size: 30,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: const Color(0xFF0E756E),


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
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              color: Colors.white,
            ),
          ),

          menuItemStyleData: MenuItemStyleData(
            customHeights: [
              ...List<double>.filled(MenuItems.firstItems.length, 48),


            ],
            padding: const EdgeInsets.only(left: 14, right: 0),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [ranking, shop, settings];


  static const ranking = MenuItem(text: '', icon: Icons.spa_outlined);
  static const shop = MenuItem(text: '', icon: Icons.shopping_cart_outlined);
  static const settings = MenuItem(text: '', icon: Icons.settings_outlined);


  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Container(
          color: Colors.transparent,
          child: Icon(item.icon, color: Color(0xFF0E756E), size: 30),
        ),


      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.ranking:
        Navigator.pushNamed(context, '/ranking');
        break;
      case MenuItems.shop:
        Navigator.pushNamed(context, '/shop');
        break;
      case MenuItems.settings:
        Navigator.pushNamed(context, '/settings');
        break;

    }
  }
}
