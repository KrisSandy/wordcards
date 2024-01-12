import 'package:flutter/material.dart';

class MyDictAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyDictAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'WordCraft',
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
