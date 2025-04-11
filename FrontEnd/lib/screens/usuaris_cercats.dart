import 'package:cine_mate/screens/biblioteca_usuaris_seguits.dart';
import 'package:cine_mate/screens/cerca_usuaris.dart';
import 'package:flutter/material.dart';

class UsuarisCercats extends StatelessWidget {
  final String busqueda;

  const UsuarisCercats({super.key, required this.busqueda});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Otros usuarios", textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centrar el texto de la búsqueda
            Text(
              'Búsqueda realizada para: "$busqueda"',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Center(
              //TODO: Comunicació amb BackEnd per agafar usuaris amb el resultat de l'String posat
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildUserBox(context, "User 1"),
                      _buildUserBox(context, "User 2"),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildUserBox(context, "User 3"),
                      _buildUserBox(context, "User 4"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserBox(BuildContext context, String user) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BibliotecaSeguitsScreen(userName: user),
          ),
        );
      },

      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.black87,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(user),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
