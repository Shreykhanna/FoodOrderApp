import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostTaskView extends StatefulWidget {
  const PostTaskView({Key? key}) : super(key: key);

  @override
  _PostTaskViewState createState() => _PostTaskViewState();
}

class _PostTaskViewState extends State<PostTaskView> {
  late final TextEditingController heading = TextEditingController();
  late final TextEditingController description = TextEditingController();
  late final TextEditingController price = TextEditingController();

  final user = FirebaseFirestore.instance.collection('users').doc('ShreyKh');
  List<File>? _profileImages = [];

  Future<void> _getMultiImage() async {
    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage(
      requestFullMetadata: true,
    );
    setState(() {
      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        _profileImages =
            pickedFiles.map((XFile file) => File(file.path)).toList();
        print(_profileImages);
      }
    });
    uploadData();
  }

  void uploadData() async {
    if (_profileImages == null || _profileImages!.isEmpty) {
      print("No image selected");
      return;
    }

    final dataObject = {
      "heading": heading.text,
      "description": description.text,
      "price": price.text
    };

    user.update({"post": dataObject}).then(
      (value) => print("Document successfully posted!"),
    );

    String imagePath = 'profile_images/${user.id}.jpg';
    Reference storageReference =
        FirebaseStorage.instance.ref().child(imagePath);
    UploadTask uploadTask = storageReference.putFile(_profileImages!.first);

    await uploadTask.whenComplete(() async {
      String imageUrl = await storageReference.getDownloadURL();
      // Update user document with profile image URL
      await user.update({'dish': imageUrl});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: heading,
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: description,
                decoration: const InputDecoration(
                  hintText: "Brief Description",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Price",
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                  onTap: _getMultiImage,
                  child: Column(
                    children: [
                      Icon(
                        Icons.attach_file,
                        size: 50,
                        color:
                            _profileImages != null && _profileImages!.isNotEmpty
                                ? Colors.blue
                                : null,
                      ),
                      const SizedBox(height: 8),
                      const Text('Attach your dish photos'),
                    ],
                  )),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: uploadData,
                child: const Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
