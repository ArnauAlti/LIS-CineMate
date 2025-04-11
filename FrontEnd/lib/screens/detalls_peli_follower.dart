import 'package:flutter/material.dart';

class DetallsPeliFollowerScreen extends StatefulWidget {
  final String title;

  const DetallsPeliFollowerScreen({super.key, required this.title});

  @override
  State<DetallsPeliFollowerScreen> createState() => _DetallsPeliFollowerScreen();
}

class _DetallsPeliFollowerScreen extends State<DetallsPeliFollowerScreen> {
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
        title: const Text("Opinión"),
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
                    Icon(
                      icon,
                      color: Colors.black,
                    )
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
              readOnly: true,
              decoration: InputDecoration(
                hintText: "BLA BLA BLA",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
