import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intolergy/firebase_options.dart';
import 'package:intolergy/screens/login.dart';
import 'package:intolergy/screens/myhomepage.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

Future<void> main() async {
  OpenFoodAPIConfiguration.userAgent = UserAgent(name: 'juliaherrera19');

  // Configurar idiomas globales
  OpenFoodAPIConfiguration.globalLanguages = <OpenFoodFactsLanguage>[
    OpenFoodFactsLanguage.SPANISH
  ];

  // Configurar el país global
  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.SPAIN;

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
// Ideal time to initialize
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
      },
    );
  }
}
