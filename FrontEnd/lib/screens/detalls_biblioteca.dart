import 'package:flutter/material.dart';

class DetallsBibliotecaScreen extends StatefulWidget {
  final String title;

  const DetallsBibliotecaScreen({super.key, required this.title});

  @override
  State<DetallsBibliotecaScreen> createState() => _DetallsBibliotecaScreenState();
}

class _DetallsBibliotecaScreenState extends State<DetallsBibliotecaScreen> {
  double selectedRating = 0;
  final TextEditingController momentController = TextEditingController();
  final TextEditingController comentariController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Detalles"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {}, // podrías abrir detalles más largos si quieres
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  //TODO: Establecer repositorio o sitio donde guardar imágenes de películas/series
                  'https://th.bing.com/th/id/OIP.TDVZL0VokIrAyO-t9RFLJQAAAA?rs=1&pid=ImgDetMain',
                  width: 180,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Momento en el que me quedé",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              cursorColor: Colors.black,
              controller: momentController,
              decoration: InputDecoration(
                hintText: "Capítulo, hora, escena...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starValue = index + 1;

                IconData icon;
                if (selectedRating >= starValue) {
                  icon = Icons.star;
                } else if (selectedRating >= starValue - 0.5) {
                  icon = Icons.star_half;
                } else {
                  icon = Icons.star_border;
                }

                return Column(
                  children: [
                    IconButton(
                      icon: Icon(icon, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          if (selectedRating == starValue.toDouble()) {
                            // Si ya tiene estrella completa → pasar a media
                            selectedRating = starValue - 0.5;
                          } else {
                            // Si no, poner estrella completa
                            selectedRating = starValue.toDouble();
                          }
                        });
                      },
                    ),
                    Text("$starValue"),
                  ],
                );
              }),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Comentario",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: comentariController,
              cursorColor: Colors.black,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "BLA BLA BLA",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // TODO: Guardar canvis a la BD
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Se han guardado los cambios.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Guardar cambios"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Eliminar de biblioteca de la BD
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Se ha eliminado de la biblioteca.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text("Eliminar de biblioteca"),
            ),
          ],
        ),
      ),
    );
  }
}
