import 'package:flutter/material.dart';

class ListPageSideDrawer extends StatelessWidget {
  final Function() showAllCallback;
  final Function() showOnlyMineCallback;
  const ListPageSideDrawer({
    required this.showAllCallback,
    required this.showOnlyMineCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // Important: Remove any padding from the ListView.
        // padding: EdgeInsets.zero,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              "Photo Bucket",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 28.0,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            title: const Text("Show only my photos"),
            leading: const Icon(Icons.person),
            onTap: () {
              showOnlyMineCallback();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text("Show all photos"),
            leading: const Icon(Icons.people),
            onTap: () {
              showAllCallback();
              Navigator.of(context).pop();
            },
          ),
          const Spacer(),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}