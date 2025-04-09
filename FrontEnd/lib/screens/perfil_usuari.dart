import 'package:flutter/material.dart';
import 'cartellera.dart';

class PerfilUsuari extends StatefulWidget {
  const PerfilUsuari({super.key});

  @override
  State<PerfilUsuari> createState() => _PerfilUsuari();
}

class _PerfilUsuari extends State<PerfilUsuari> {

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
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //TODO: Agafar dades de l'usuari per posar-les de manera predefinida als camps
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Nombre",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Nombre de usuario",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Año de nacimiento",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    //TODO: Passar variables modificades a BackEnd per fer comprovació amb la BD
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cambios guardados correctamente.')),
                    );                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                  child: const Text("Guardar dades"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
