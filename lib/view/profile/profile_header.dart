import 'package:flutter/material.dart';
import 'package:test_project/view/profile/style.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(
          color: Color(0xffeaeaea),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80.0))),
      child: const Row(children: [
        Text(
          "Profile",
          style: titleText,
        )
      ]),
    );
  }
}
