import 'package:flutter/material.dart';
import 'personatges_disponibles_admin.dart';

class CercaPersonatgesScreen extends StatelessWidget {
  const CercaPersonatgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Busqueda de personajes", textAlign: TextAlign.center),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volver a la pantalla anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Introdueix el títol de la pel·lícula o sèrie...",
            prefixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                //TODO: Fer cerca a partir de les paraules posades per trobar els personatges a la BD
                //TODO: Modificar per a passar el paràmetre de cerca en la ruta desitjada
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PersonatgesDisponiblesAdminScreen()),
                );
              },
            ),
            fillColor: Color(0xFFEAE6f3),
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 14.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide.none,
            )
          ),
        ),
      ),
    );
  }
}
