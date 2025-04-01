import 'package:flutter/material.dart';

class RegistreScreen extends StatelessWidget {
  const RegistreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Registro", textAlign: TextAlign.center),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volver a la pantalla anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Nombre",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Nombre de usuario",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Año de nacimiento",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Acción para registrarse
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: const Text("Registrarse"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
