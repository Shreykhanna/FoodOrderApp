import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_project/view/common/card_component.dart';
import 'package:test_project/view/common/search_bar_component.dart';
import 'package:test_project/view/drawer/drawer_widget.dart';
import 'package:test_project/view/login/components/background_component.dart';
import 'package:test_project/view/login/components/circular_component.dart';

class MenuItem {
  final String itemImage;
  final String itemName;
  final String itemDescription;
  final int itemPrice;

  MenuItem({
    required this.itemImage,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      itemImage: map['itemImage'] ?? '',
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
          itemImage: '',
          itemName: 'No data available',
          itemDescription: '',
          itemPrice: 0,
        );
      }
    } catch (e) {
      // Handle errors during data fetching
      print("Error fetching data: $e");
      return MenuItem(
        itemImage: '',
        itemName: 'Error fetching data',
        itemDescription: '',
        itemPrice: 0,
      );
    }
  }

  void placeOrder(customerOrder) {
    // Implement the logic for placing an order
    print("Customer order confirm $customerOrder");
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
            "itemImage": snapshot.data!.itemImage,
            "itemName": snapshot.data!.itemName,
            "itemDescription": snapshot.data!.itemDescription,
            "itemPrice": snapshot.data!.itemPrice
          };
          return MaterialApp(
              home: SafeArea(
                  child: Scaffold(
                      appBar: AppBar(
                        title: const Text('Menu'),
                      ),
                      drawer: const Drawer(
                        child: DrawerWidget(),
                      ),
                      body: Stack(children: [
                        const BackgroundComponent(),
                        const CircularComponent(),
                        // const SearchBarComponent(),
                        CardComponent(
                            customerOrder: customerOrder,
                            placeOrderCallback: placeOrder)
                      ]))));
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
