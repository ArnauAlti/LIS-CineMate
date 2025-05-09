import 'package:flutter/material.dart';

import 'editar_personatge.dart';

class InfoPersonatgeAdmin extends StatelessWidget {
  const InfoPersonatgeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Eleven: Stranger Things"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/en/f/f7/Eleven_%28Stranger_Things%29.png',
                  width: 180,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Eleven',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),

            const Center(
              child: Text(
                '• Té habilitats psíquiques\n• Desconfia de la gent\n• Parla molt bé dels seus amics',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditarPersonatgeScreen()));
                  },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll<Color>(Colors.black),
                    foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  child: const Text("Editar informació"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Acción de eliminar
                  },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll<Color>(Colors.red),
                    foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  child: const Text("Eliminar"),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
