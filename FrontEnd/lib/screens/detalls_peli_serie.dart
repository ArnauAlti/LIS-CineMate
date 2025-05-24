import 'package:cine_mate/screens/cartellera.dart';
import 'package:flutter/material.dart';
import '../user_role_provider.dart';
import 'package:provider/provider.dart';
import '../requests.dart';
import 'comentaris_valoracions.dart';
import 'package:intl/intl.dart';

class DetallsPeliSerieScreen extends StatefulWidget {
  final String mediaId;

  const DetallsPeliSerieScreen({super.key, required this.mediaId});

  @override
  State<DetallsPeliSerieScreen> createState() => _DetallsPeliSerieScreen();
}

class _DetallsPeliSerieScreen extends State<DetallsPeliSerieScreen> {
  late Future<List>_filmFuture;

  @override
  void initState() {
    super.initState();
    _filmFuture = getFilmDetails(widget.mediaId);
  }

  @override
  Widget build(BuildContext context) {
    final mail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;
    print(mail);
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Details"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List>(
        future: _filmFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final film = snapshot.data;
          if (film == null) {
            return const Center(child: Text('No details found.'));
          }

          final String title = film[0]['name'] ?? 'Unknown title';
          final String urlFoto = film[0]['png'] ?? '';
          final String duration = film[0]['duration']?.toString() ?? 'Unknown';
          final String director = film[0]['director'] ?? 'Unknown';
          final String cast = (film[0]['cast'] is List)
              ? (film[0]['cast'] as List).join(', ')
              : (film[0]['cast'] ?? 'Unknown');
          final String description = film[0]['description'] ?? 'Without description.';
          final double rating = (film[0]['vote_rating'] ?? 0).toDouble();

          final String mediaId = film[0]['media_id'] ?? 'Not known';
          final String infoId = film[0]['info_id'] ?? 'Not known';

          final String releaseDateRaw = film[0]['release']?.toString() ?? '';
          String releaseDate = 'Unknown';
          if (releaseDateRaw.isNotEmpty) {
            try {
              final parsedDate = DateTime.parse(releaseDateRaw);
              releaseDate = DateFormat('dd/MM/yyyy').format(parsedDate);  // o 'd \'de\' MMMM \'de\' y' para español
            } catch (e) {
              releaseDate = 'Date not valid';
            }
          }

          return SingleChildScrollView(
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
                          Text("📅 Release date: $releaseDate", style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text("⏱ Duration: $duration minutes", style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text("📺 Director: $director", style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 8),
                          Text("🎭 Cast: $cast", style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "⭐ Rating",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        if (index < rating.floor()) {
                          return const Icon(Icons.star, size: 30, color: Colors.amber);
                        } else if (index < rating && rating - index >= 0.5) {
                          return const Icon(Icons.star_half, size: 30, color: Colors.amber);
                        } else {
                          return const Icon(Icons.star_border, size: 30, color: Colors.black);
                        }
                      }),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Future.delayed(Duration.zero, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommentRatingScreen(mediaId: mediaId, infoId: infoId,)),
                        );
                      });                },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    label: const Text("See other comments and ratings", style: TextStyle(fontSize: 16)),
                  ),
                ),
<<<<<<< HEAD
                const SizedBox(height:30),

=======
                const SizedBox(height: 30),
>>>>>>> origin/admin
                if (userRole == "Usuario Registrado")
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Future<bool> validation = addToLibrary(mail!, film[0]['media_id'], film[0]['info_id'], urlFoto, title, film[0]['type']);

                        if(await validation) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${film[0]['name']} added to library.')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to add to library. Already in your library?')),
                          );
                        }
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
                      label: const Text("Add to Library", style: TextStyle(fontSize: 16)),
                    ),
                  )
                else if (userRole == "Administrador")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await deleteFilm(title, film[0]['media_id']);

                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const CartelleraScreen(),
                          ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Deleted from billboard.')),
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
                        child: const Text("Delete"),
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          );
        },
      ),
    );
  }
}
