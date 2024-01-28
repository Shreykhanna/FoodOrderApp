import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_project/view/profile/style.dart';

class ProfileSubHeader extends StatefulWidget {
  const ProfileSubHeader({super.key});

  @override
  State<ProfileSubHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileSubHeader> {
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
      print("USERS : $users");
      // Fetch data from Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot =
          await users.get() as QuerySnapshot<Map<String, dynamic>>;

      // Assuming there is only one document in the collection, you might need to adjust this logic based on your data structure
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data();
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
    return Container(
      height: 300,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 200),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80.0))),
      child: Column(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(profileImage, scale: 1.0),
        ),
        const SizedBox(height: 10),
        Text(
          "$firstName $lastName",
          style: heading4,
        )

        //   Text(firstName),
        //   Text(lastName),
        //   Text(gender),
        //   Text(address),
        //   TextButton(onPressed: () {}, child: const Text("Edit"))
      ]),
    );
  }
}
