import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/welcome_screen.dart';
import 'screens/cartellera.dart';
import 'user_role_provider.dart';
import 'screens/pregunta_questionari.dart';

void main() {
  runApp(
    //Utilitzat per poder gestionar el rol de l'usuari de forma global per a totes les pantalles
    ChangeNotifierProvider(
      create: (_) => UserRoleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/cartellera': (context) => const CartelleraScreen(),
      },
    );
  }
}
