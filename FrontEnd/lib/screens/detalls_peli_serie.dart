import 'package:cine_mate/screens/editar_pelicula.dart';
import 'package:flutter/material.dart';
import '../user_role_provider.dart';
import 'package:provider/provider.dart';

class DetallsPeliSerieScreen extends StatelessWidget {
  final Map<String, dynamic>? film;

  const DetallsPeliSerieScreen({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    final String title = film?['title'] ?? 'Título desconocido';
    final String urlFoto = film?['imagePath'] ?? 'https://th.bing.com/th/id/OIP.TDVZL0VokIrAyO-t9RFLJQAAAA?rs=1&pid=ImgDetMain';
    final String release_date = film?['releaseDate']?.toString() ?? 'Desconocido';
    final String duration = film?['duration']?.toString() ?? 'Desconocida';
    final String director = film?['director'] ?? 'Desconocido';
    final String cast = (film?['cast'] is List)
        ? (film?['cast'] as List).join(', ')
        : (film?['cast'] ?? 'Desconocido');
    final String description = film?['description'] ?? 'Sin descripción.';

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Detalles"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    urlFoto,
                    width: 130,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 130,
                        height: 200,
                        color: Colors.grey,
                        child: const Center(child: Icon(Icons.broken_image)),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📅 Año de estreno: $release_date", style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text("⏱ Duración: $duration minutos", style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text("📺 Director: $director", style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text("🎭 Reparto: $cast", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            //TODO: Agafar valoració a partir de la BD
            const Text(
              "⭐ Valoración",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return const Icon(Icons.star_border, size: 30, color: Colors.black);
              }),
            ),
            const SizedBox(height: 30),
            const Text(
              "Sinópsis",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),

            if (userRole == "Usuario Registrado")
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Afegir a la biblioteca de l'usuari
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Película añadida a la biblioteca.')),
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
                  icon: const Icon(Icons.add),
                  label: const Text("AÑADIR A BIBLIOTECA", style: TextStyle(fontSize: 16)),
                ),
              )
            else if (userRole == "Administrador")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarPeliCartelleraScreen(
                            mode: "Modify",
                            peliData: film!,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("EDITAR INFORMACIÓN"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Eliminar película de la cartellera i de la BD
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Obra eliminada de la cartelera.')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text("ELIMINAR"),
                  ),
                ],
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
