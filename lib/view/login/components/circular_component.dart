import 'package:flutter/material.dart';

class CircularComponent extends StatelessWidget {
  const CircularComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: -50,
        left: -50,
        child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(800)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(8, 127, 119, 1),
                    Color.fromRGBO(177, 178, 181, 0),
                  ],
                ))));
  }
}
