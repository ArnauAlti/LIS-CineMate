import 'package:cine_mate/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../user_role_provider.dart';

class DetallsBibliotecaScreen extends StatefulWidget {
  final Map<String, dynamic> film;

  const DetallsBibliotecaScreen({super.key, required this.film});

  @override
  State<DetallsBibliotecaScreen> createState() => _DetallsBibliotecaScreenState();
}

class _DetallsBibliotecaScreenState extends State<DetallsBibliotecaScreen> {
  double selectedRating = 0;
  final TextEditingController capitolController = TextEditingController();
  final TextEditingController comentariController = TextEditingController();
  final TextEditingController minutController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final film = widget.film;
    selectedRating = (film['personalRating'] ?? 0.0).toDouble();
    capitolController.text = film['episodi']?.toString() ?? '';
    comentariController.text = film['comment'] ?? '';
    minutController.text = widget.film['timeLastSeen']?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final film = widget.film;
    final userEmail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;
    final user = Provider.of<UserRoleProvider>(context, listen: false).getUser;


    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Detalles"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: Text(
                film["title"] ?? "Sin título",
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
                  film["imagePath"] ??
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
                "Minuto en el que me quedé la última vez",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: minutController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: "Ej. 45",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            if (film['type'] == 0) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Capítulo en el que me quedé",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                cursorColor: Colors.black,
                controller: capitolController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Capítulo...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 24),
            ],
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
                            selectedRating = starValue - 0.5;
                          } else {
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
                final String title = film["title"];
                final String comment = comentariController.text;
                final int capitol = int.tryParse(capitolController.text) ?? 0;
                final int minut = int.tryParse(minutController.text) ?? 0;
                final double rating = selectedRating;

                //modifyFromLibrary(user?['user_id'], comment, capitol, minut, rating, userEmail!);

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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            deleteFromLibrary(film["title"], userEmail!);
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
      ),
    );
  }
}
