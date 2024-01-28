import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_project/view/drawer/drawer_widget.dart';

class ProfileViewUser extends StatefulWidget {
  const ProfileViewUser({super.key});

  @override
  State<ProfileViewUser> createState() => _ProfileViewUserState();
}

class _ProfileViewUserState extends State<ProfileViewUser> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  bool editState = false;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  File? _profileImage;
  String? selectedOption = '';
  @override
  Widget build(BuildContext context) {
    Future<void> _getImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, requestFullMetadata: true);
      setState(() {
        if (pickedFile != null) {
          _profileImage = File(pickedFile.path);
          print(_profileImage);
        }
      });
    }

    void saveProfile() async {
      final firstName = _firstName.text;
      final lastName = _lastName.text;
      final address = _address.text;
      final phoneNumber = _phoneNumber.text;
      final uid = firstName + lastName;
      if (_profileImage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile saved successfully!'),
          ),
        );
      }

      await users.doc(firstName + lastName).set({
        "firstName": firstName,
        "lastName": lastName,
        "gender": selectedOption,
        "address": address,
        "phoneNumber": phoneNumber
      });

      String imagePath = 'profile_images/$uid.jpg';
      Reference storageReference =
          FirebaseStorage.instance.ref().child(imagePath);
      UploadTask uploadTask = storageReference.putFile(_profileImage!);

      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();
        // Update user document with profile image URL
        await users.doc(uid).update({'profileImageUrl': imageUrl});
      });
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/fetch_profile_view_user/', (route) => false);
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Profile page")),
        drawer: const Drawer(child: DrawerWidget()),
        body: SingleChildScrollView(
          child: Column(children: [
            GestureDetector(
              onTap: _getImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 40,
                      )
                    : null,
              ),
            ),
            TextField(
              controller: _firstName,
              decoration: const InputDecoration(hintText: "First Name"),
            ),
            TextField(
              controller: _lastName,
              decoration: const InputDecoration(hintText: "Last Name"),
            ),
            Row(
              children: [
                Expanded(
                    child: RadioListTile(
                  title: const Text('Male'),
                  value: 'Male',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                )),
                const SizedBox(width: 5.0),
                Expanded(
                    child: RadioListTile(
                  title: const Text('Female'),
                  value: 'Female',
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                )),
              ],
            ),
            TextField(
              controller: _address,
              decoration: const InputDecoration(hintText: "Address"),
            ),
            TextField(
              controller: _phoneNumber,
              decoration: const InputDecoration(hintText: "Phone Number"),
            ),
            ElevatedButton(onPressed: saveProfile, child: const Text('Save'))
          ]),
        ));
  }
}
