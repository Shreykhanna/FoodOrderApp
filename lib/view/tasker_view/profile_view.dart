import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_project/firebase_options.dart';
import 'package:test_project/view/drawer/drawer_widget.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phoneNumber;
  late final TextEditingController _tradieLicense;

  @override
  void initState() {
    // TODO: implement initState
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _phoneNumber = TextEditingController();
    _tradieLicense = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _phoneNumber.dispose();
    _tradieLicense.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Profile Page")),
        drawer: const Drawer(
          child: DrawerWidget(),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            return Column(children: [
              TextField(
                controller: _firstName,
                decoration: const InputDecoration(
                    hintText: "First Name", contentPadding: EdgeInsets.all(20)),
              ),
              TextField(
                  controller: _lastName,
                  decoration: const InputDecoration(
                      hintText: "Last Name",
                      contentPadding: EdgeInsets.all(20))),
              TextField(
                  controller: _phoneNumber,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                      hintText: "Phone Number",
                      contentPadding: EdgeInsets.all(20))),
              TextField(
                  controller: _tradieLicense,
                  decoration: const InputDecoration(
                      hintText: "Tradie License",
                      contentPadding: EdgeInsets.all(20))),
              TextButton(
                  onPressed: () {},
                  child: const Text("Verify your tradie license")),
              TextButton(
                  onPressed: () {
                    final firstName = _firstName.text;
                    final lastName = _lastName.text;
                    final phoneNumber = _phoneNumber.text;
                    final tradieLicense = _tradieLicense.text;
                  },
                  child: const Text("Create Profile"))
            ]);
          },
        ));
  }
}
