import 'package:flutter/material.dart';
import '../profile/style.dart';

class CardComponent extends StatelessWidget {
  final Map<String, dynamic> customerOrder;
  final void Function(Map<String, dynamic> customerOrder) placeOrderCallback;

  const CardComponent({
    super.key,
    required this.customerOrder,
    required this.placeOrderCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.only(top: 200, left: 18, right: 18),
      child: SizedBox(
        width: double.maxFinite,
        height: 350,
        child: Column(
          children: [
            Image(
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              image: NetworkImage(customerOrder['itemImage']),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Text(customerOrder['itemName']!, style: itemTitle)),
                Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(customerOrder['itemDescription']!,
                        style: heading4)),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.grey,
                  height: 1,
                  thickness: 0.5,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const Text(
                          "Price: \$",
                          style: heading4,
                        ),
                        Text(
                          customerOrder['itemPrice']!.toString(),
                          style: heading4,
                        )
                      ]),
                      ElevatedButton(
                        onPressed: () {
                          placeOrderCallback(customerOrder);
                        },
                        child: const Text("Place Order"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
