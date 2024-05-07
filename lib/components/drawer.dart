import 'package:flutter/material.dart';

import '../pages/setting_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(children: [
        DrawerHeader(
          child: Center(
            child: Icon(
              Icons.music_note,
              size: 40,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 25),
          child: ListTile(
            title: const Text(
              "H O M E",
            ),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.pop(context),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, top: 0),
          child: ListTile(
            title: const Text(
              "S E T T I N G S",
            ),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 25, top: screenHeight * 0.45),
          child: ListTile(
            title: const Text(
              "E M A R A",
            ),
            leading: const Icon(Icons.account_circle),
            onTap: () => Navigator.pop(context),
          ),
        ),
      ]),
    );
  }
}
