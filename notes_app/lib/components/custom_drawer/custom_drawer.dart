import 'package:flutter/material.dart';
import 'package:notes_app/components/custom_drawer/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double drawerWidth = screenWidth * 0.5;

    return Drawer(
        width: drawerWidth,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            const DrawerHeader(child: Icon(Icons.note)),
            DrawerTile(
              title: 'Home', 
              leading: const Icon(Icons.home), 
              onTap: () {Navigator.pop(context);},
            ),
            DrawerTile(
              title: 'Settings', 
              leading: const Icon(Icons.settings), 
              onTap: () {},
            ),
          ],
        ));
  }
}