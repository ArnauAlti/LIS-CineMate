import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/cartellera.dart';
import 'screens/detalls_peli_serie.dart';

void main() {
  runApp(const MyApp());
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
      onGenerateRoute: (settings) {
        if (settings.name == '/detalls_peli_serie') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DetallsPeliSerieScreen(
              title: args['title'], // Passa el títol de la película per buscar-lo a la BD
            ),
          );
        }
        return null;
      },
    );
  }
}
