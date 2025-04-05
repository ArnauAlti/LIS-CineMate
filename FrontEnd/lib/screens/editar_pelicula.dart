import 'package:flutter/material.dart';

class EditarPeliCartelleraScreen extends StatefulWidget {
  const EditarPeliCartelleraScreen({super.key});

  @override
  State<EditarPeliCartelleraScreen> createState() =>
      _EditarPeliCartelleraScreenState();
}

class _EditarPeliCartelleraScreenState extends State<EditarPeliCartelleraScreen> {
  final titolController =
  TextEditingController(text: "Captain America: Brave New World");
  final repartController =
  TextEditingController(text: "Anthony Mackie, Harrison Ford, ...");
  final descripcioController = TextEditingController(
      text: "Tras reunirse con el recién elegido presidente de...");

  String? tipusSeleccionat = "Pel·lícula";
  String? genereSeleccionat = "Acció";

  final List<String> tipusOpcions = ["Pel·lícula", "Sèrie"];
  final List<String> generesOpcions = [
    "Terror",
    "Comèdia",
    "Romàntica",
    "Acció",
    "Drama",
    "Fantasia",
    "Ciència-ficció"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Editar pelicula"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Título"),
              const SizedBox(height: 8),
              TextField(
                controller: titolController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text("Tipos"),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: tipusSeleccionat,
                items: tipusOpcions
                    .map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(t),
                ))
                    .toList(),
                onChanged: (nouValor) {
                  setState(() {
                    tipusSeleccionat = nouValor;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text("Genero"),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: genereSeleccionat,
                items: generesOpcions
                    .map((g) => DropdownMenuItem(
                  value: g,
                  child: Text(g),
                ))
                    .toList(),
                onChanged: (nouValor) {
                  setState(() {
                    genereSeleccionat = nouValor;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Imagen de la película
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "https://www.lavanguardia.com/files/content_image_mobile_filter/uploads/2023/07/27/64c29ce7e0a52.jpeg",
                    width: 180,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text("Reparto"),
              const SizedBox(height: 8),
              TextField(
                controller: repartController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text("Descripción"),
              const SizedBox(height: 8),
              TextField(
                controller: descripcioController,
                maxLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Acción de editar
                    print("Título: ${titolController.text}");
                    print("Tipos: $tipusSeleccionat");
                    print("Genero: $genereSeleccionat");
                    print("Reparto: ${repartController.text}");
                    print("Descripción: ${descripcioController.text}");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                  ),
                  child: const Text("Editar"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}