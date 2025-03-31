import 'package:flutter/material.dart';

class CartelleraScreen extends StatelessWidget {
  const CartelleraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(title: const Text("Biblioteca"), backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: const Center(
        child: Text(
          "Bienvenido a la Cartelera",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
