import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_project/view/drawer/drawer_widget.dart';
import 'package:test_project/view/profile/profile_details.dart';
import 'package:test_project/view/profile/profile_subheader.dart';
import 'package:test_project/view/profile/profile_header.dart';

class FetchProfileView extends StatefulWidget {
  const FetchProfileView({super.key});

  @override
  State<FetchProfileView> createState() => _FetchProfileViewState();
}

class _FetchProfileViewState extends State<FetchProfileView> {
  String firstName = '',
      lastName = '',
      gender = '',
      address = '',
      phoneNumber = '',
      profileImage = '';

  @override
  void initState() {
    super.initState();
    // Call fetchProfile in initState to fetch data when the widget is first created
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      // Initialize Firebase if not initialized
      await Firebase.initializeApp();

      // Reference to the users collection in Firestore
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      print(users);
      // Fetch data from Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await users.get() as QuerySnapshot<Map<String, dynamic>>;

      // Assuming there is only one document in the collection, you might need to adjust this logic based on your data structure
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs[2].data();
        setState(() {
          // Update your state variables with the fetched data
          profileImage = data['profileImageUrl'] ?? '';
          firstName = data['firstName'] ?? '';
          lastName = data['lastName'] ?? '';
          gender = data['gender'] ?? '';
          address = data['address'] ?? '';
          phoneNumber = data['phoneNumber'] ?? '';
        });
      } else {
        print('No documents found');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          // if (snapshot.hasError) {
          //   return const Text("Error");
          // }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              home: SafeArea(
                child: Scaffold(
                    appBar: AppBar(
                      title: const Text('Profile'),
                    ),
                    drawer: const Drawer(
                      child: DrawerWidget(),
                    ),
                    backgroundColor: const Color.fromARGB(248, 251, 202, 25),
                    body: const Stack(
                      children: [
                        ProfileSubHeader(),
                        ProfileHeader(),
                        ProfileDetails()
                      ],
                    )),
              ),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return const CircularProgressIndicator();
        });
  }
}
