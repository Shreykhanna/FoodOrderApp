import 'package:flutter/material.dart';
import 'package:test_project/view/common/menu_view.dart';
import 'package:test_project/view/common/post_task_view.dart';
import 'package:test_project/view/tasker_view/profile_view.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Text("Foodie - Categories"),
        ),
        ListTile(
          title: const Text("Home cook"),
          onTap: () {
            try {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PostTaskView()));
            } catch (e) {
              print(e);
            }
          },
        ),
        ListTile(
          title: const Text("Menu"),
          onTap: () {
            try {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MenuView()));
            } catch (e) {
              print(e);
            }
          },
        )
      ],
    ));
  }
}
