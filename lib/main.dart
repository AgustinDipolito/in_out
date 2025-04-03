import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_out/firebase_options.dart';
import 'package:in_out/servicies/login_service.dart';
import 'package:in_out/servicies/pays_service.dart';
import 'package:in_out/servicies/config_service.dart';
import 'package:in_out/servicies/shared_preferences_services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.wait([
    UserPreferences.init(),
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive),
  ]);

  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // final fcmToken = await messaging.getToken();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   if (message.notification != null) {}
  // });
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PaysService()),
        ChangeNotifierProvider(create: (_) => ConfigService()),
        ChangeNotifierProvider(create: (_) => LoginService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material app',
        home: LoginPage(),
      ),
    );
  }
}
