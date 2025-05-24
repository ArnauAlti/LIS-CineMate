import 'package:flutter/material.dart';

class EditarPersonatgeScreen extends StatelessWidget {
  const EditarPersonatgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nomController = TextEditingController(text: "Eleven");
    final descripcioController = TextEditingController(
      text: "• Té habilitats psíquiques\n• Desconfia de la gent\n• Parla molt bé dels seus amics",
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Editar personaje"),
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Nombre personaje"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nomController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("URL de la foto del personaje"),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: descripcioController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Descripción"),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: descripcioController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Película o serie del personaje"),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: descripcioController,
              maxLines: 5,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                //TODO: Enviar request per modificar dades
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text("Editar"),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}