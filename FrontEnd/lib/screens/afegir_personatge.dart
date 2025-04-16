import 'package:flutter/material.dart';

class AfegirPersonatgeScreen extends StatelessWidget {
  const AfegirPersonatgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Añadir personaje"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:  24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Nombre personaje"),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                filled:  true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Center(
              child: Container(
                width:100,
                height: 100,
                decoration: BoxDecoration(
                  border:  Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.image, size: 48, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 32),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Descripción"),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  //TODO: Passar informació a backend per actualitzar la BD
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: const Text("Añadir"),
              ),
            ),
            const SizedBox(height: 16),
          ],
        )
      ),
    );
  }
}