import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_project/view/profile/style.dart';

class MenuItem {
  final String postImage;
  final String heading;
  final String description;
  final String price;

  MenuItem({
    required this.postImage,
    required this.heading,
    required this.description,
    required this.price,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      postImage: map['postImage'] ?? '',
      heading: map['heading'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? '',
    );
  }
}

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  late CollectionReference<Map<String, dynamic>> reference;

  late Future<MenuItem> menuData;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    reference = FirebaseFirestore.instance.collection('users');
    menuData = fetchData();
  }

  Future<MenuItem> fetchData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await reference.get();
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs[1].data();
        final dataPost = data['post'] ?? {};
        return MenuItem.fromMap(dataPost);
      } else {
        // Handle the case when no data is available
        return MenuItem(
          postImage: '',
          heading: 'No data available',
          description: '',
          price: '',
        );
      }
    } catch (e) {
      // Handle errors during data fetching
      print("Error fetching data: $e");
      return MenuItem(
        postImage: '',
        heading: 'Error fetching data',
        description: '',
        price: '',
      );
    }
  }

  void placeOrder() {
    // Implement the logic for placing an order
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MenuItem>(
      future: menuData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Column(
              children: [
                // Image(image: NetworkImage(snapshot.data!.postImage)),
                Text(snapshot.data!.heading, style: heading4),
                Text(snapshot.data!.description, style: heading4),
                Text(snapshot.data!.price, style: heading4),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/confirm_order/', (route) => false);
                  },
                  child: const Text("Place Order"),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
