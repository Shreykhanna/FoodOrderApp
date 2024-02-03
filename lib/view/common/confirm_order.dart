import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class ConfirmOrder extends StatefulWidget {
  const ConfirmOrder({super.key});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  CardFieldInputDetails? _card;
  // CardFieldInputDetails _card = {
  //   "complete": false,
  //   "last4": '',
  //   'expiryMonth': '',
  //   'expiryYear': '',
  //   'brand': '',
  //   'cvc': '',
  //   'postalCode': ''
  // };

  void handlePaymentCompletion(_card) async {
    print("Card: ${_card}");
    var url = Uri.https(
        "klbf4lnshejgmlevbzjelmdngq0thfsz.lambda-url.ap-southeast-2.on.aws");
    var response = await http.post(url, body: {
      "card": {
        "complete": true,
        "last4": 4242,
        "expiryMonth": 2,
        " expiryYear": 42,
      },
      "currency": "aud",
      "useStripeSdk":
          "pk_test_51OevnaD4D7JQbRdXIJ4yMcJZxpzeBIr1kGjkBzdRvurd3gq4SkZuT33jTD0gk1N1BkhZWp6VqkLTCQfjoD8oN2QI005OI4BPMD",
      "orderAmount": "100",
      "type": "pay"
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    // await Stripe.instance.confirmPayment( clientSecret['clientSecret'],
    //   PaymentMethodParams.card(
    //     paymentMethodData: PaymentMethodData(
    //       billingDetails: billingDetails,
    //     ),
    //     options: PaymentMethodOptions(
    //       setupFutureUsage:
    //           _saveCard == true ? PaymentIntentsFutureUsage.OffSession : null,
    //     ),
    // )
    //);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pay with a credit card"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Card Form',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              CardField(
                onCardChanged: (card) {
                  setState(() {
                    _card = card!;
                  });
                },
              ),
              const SizedBox(height: 10),
              if (_card?.complete == true)
                ElevatedButton(
                    onPressed: () {
                      handlePaymentCompletion(_card);
                    },
                    child: const Text('Pay'))
            ],
          ),
        ));
  }
}
