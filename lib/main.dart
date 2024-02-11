import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test_project/firebase_options.dart';
import 'package:test_project/view/common/confirm_order.dart';
import 'package:test_project/view/common/menu_view.dart';
import 'package:test_project/view/common/post_task_view.dart';
import 'package:test_project/view/drawer/drawer_widget.dart';
import 'package:test_project/view/login/login_view.dart';
import 'package:test_project/view/register/register_view.dart';
import 'package:test_project/view/user_view/create_profile_view.dart';
import 'package:test_project/view/user_view/fetch_profile_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH_TEST_KEY']!;
  await Stripe.instance.applySettings();
  Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      // This is the theme of your application.
      //
      // TRY THIS: Try running your application with "flutter run". You'll see
      // the application has a purple toolbar. Then, without quitting the app,
      // try changing the seedColor in the colorScheme below to Colors.green
      // and then invoke "hot reload" (save your changes or press the "hot
      // reload" button in a Flutter-supported IDE, or press "r" if you used
      // the command line to start the app).
      //
      // Notice that the counter didn't reset back to zero; the application
      // state is not lost during the reload. To reset the state, use hot
      // restart instead.
      //
      // This works for code too, not just values: Most code changes can be
      // tested with just a hot reload.
      primarySwatch: Colors.blue,
      // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      '/login': (context) => const LoginView(),
      '/register/': (context) => const RegisterView(),
      '/create_profile_view_user/': (context) => const ProfileViewUser(),
      '/fetch_profile_view_user/': (context) => const FetchProfileView(),
      "/food_menu/": (context) => const MenuView(),
      '/post_task_view/': (context) => const PostTaskView(),
      '/confirm_order/': (context) => const ConfirmOrder(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            // switch (snapshot.connectionState) {
            //   case ConnectionState.done:
            //     // TODO: Handle this case.
            //     final user = FirebaseAuth.instance.currentUser;
            //     print(FirebaseAuth.instance.currentUser);
            //     if (user != null) {
            //       if (user.emailVerified) {
            //         print("email verified");
            //         // return const Text("Email verified");
            //       } else {
            //         print("Not a verified user");
            //         return const VerifyEmailView();
            //       }
            //     } else {
            //       return const LoginView();
            //     }
            //     return const Text('Done');
            //   default:
            //     return const CircularProgressIndicator();
            return const LoginView();
          }),
    );
  }
}
