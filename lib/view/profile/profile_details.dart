import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_project/view/profile/style.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  String firstName = '',
      lastName = '',
      gender = '',
      address = '',
      phoneNumber = '',
      profileImage = '';

  @override
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
      padding: const EdgeInsets.only(top: 400),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            gender,
            style: heading4,
          ),
          const SizedBox(height: 10),
          const Divider(
            thickness: 2,
            color: Colors.grey,
            height: 2,
            indent: 1,
          ),
          const SizedBox(height: 10),
          Text(
            address,
            style: heading4,
          ),
          const SizedBox(height: 10),
          const Divider(
            thickness: 2,
            color: Colors.grey,
            height: 2,
            indent: 1,
          ),
          const SizedBox(height: 10),
          Text(
            phoneNumber,
            style: heading4,
          ),
          const SizedBox(height: 10),
          const Divider(
            thickness: 2,
            color: Colors.grey,
            height: 2,
            indent: 1,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Edit'),
          )
        ],
      ),
    );
  }
}
