import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_project/view/profile/style.dart';

class MenuItem {
  final String postImage;
  final String itemName;
  final String itemDescription;
  final int itemPrice;

  MenuItem({
    required this.postImage,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      postImage: map['postImage'] ?? '',
      itemName: map['heading'] ?? '',
      itemDescription: map['description'] ?? '',
      itemPrice: map['price'] ?? 0,
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
          itemName: 'No data available',
          itemDescription: '',
          itemPrice: 0,
        );
      }
    } catch (e) {
      // Handle errors during data fetching
      print("Error fetching data: $e");
      return MenuItem(
        postImage: '',
        itemName: 'Error fetching data',
        itemDescription: '',
        itemPrice: 0,
      );
    }
  }

  void placeOrder(customerOrder) {
    // Implement the logic for placing an order
    Navigator.of(context)
        .pushReplacementNamed('/confirm_order/', arguments: customerOrder);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MenuItem>(
      future: menuData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          dynamic customerOrder = {
            "itemName": snapshot.data!.itemName,
            "itemDescription": snapshot.data!.itemDescription,
            "itemPrice": snapshot.data!.itemPrice
          };
          return Scaffold(
            body: Column(
              children: [
                // Image(image: NetworkImage(snapshot.data!.postImage)),
                Text(customerOrder['itemName']!, style: heading4),
                Text(customerOrder['itemDescription']!, style: heading4),
                Text(customerOrder['itemPrice']!.toString(), style: heading4),
                ElevatedButton(
                  onPressed: () {
                    placeOrder(customerOrder);
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
