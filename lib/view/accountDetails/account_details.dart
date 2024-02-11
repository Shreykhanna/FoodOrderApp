import 'package:flutter/material.dart';
import 'package:test_project/view/login/components/background_component.dart';
import 'package:test_project/view/tasker_view/profile_view.dart';

import '../login/components/circular_component.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Account Details'),
        ),
        body: Stack(
          children: [
            const BackgroundComponent(),
            const CircularComponent(),
            Padding(
              padding: const EdgeInsets.only(top: 300, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/fetch_profile_view_user/', (route) => false);
                    },
                    child: const Text('Your Profile'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Food Orders page
                      // You can implement navigation logic here
                    },
                    child: const Text('Food Orders'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Add Credit Card page
                      // You can implement navigation logic here
                    },
                    child: const Text('Add Credit Card'),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
