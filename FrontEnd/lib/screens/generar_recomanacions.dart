import 'package:cine_mate/screens/detalls_peli_serie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../requests.dart';
import '../user_role_provider.dart';

class RecomanacionsGeneradesScreen extends StatefulWidget {
  final List<String>? selectedGenres;
  final bool type;

  const RecomanacionsGeneradesScreen({super.key, this.selectedGenres, required this.type});

  @override
  State<RecomanacionsGeneradesScreen> createState() => _RecomanacionsGenerades();
}

class _RecomanacionsGenerades extends State<RecomanacionsGeneradesScreen> {
  late Future<Map<String, dynamic>> _filmsFuture;

  @override
  void initState() {
    print(widget.selectedGenres);
    final userEmail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;
    super.initState();
    _filmsFuture = getRecomendationFilms(userEmail!, widget.selectedGenres, widget.type);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Results"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
        body: FutureBuilder<Map<String, dynamic>>(
          future: _filmsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final data = snapshot.data as Map<String, dynamic>;
            final films = data['recommendations'] as List<Map<String, dynamic>>;
            final topGenres = data['top_genres'] as List<String>;


            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    Text("Taking into account your likes on ${topGenres[0]} and ${topGenres[1]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.selectedGenres != null && widget.selectedGenres!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            const Text(
                              "Genres selected:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              alignment: WrapAlignment.center,
                              children: widget.selectedGenres!
                                  .map((genre) => Chip(
                                label: Text(genre),
                                backgroundColor: Colors.black,
                                labelStyle: const TextStyle(color: Colors.white),
                              ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 50),
                    for (int i = 0; i < films.length; i += 2)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildMovieBox(context, films[i]),
                              if (i + 1 < films.length)
                                _buildMovieBox(context, films[i + 1]),
                            ],
                          ),
                       const SizedBox(height: 50),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Funció per construir una caixa de pel·lícula o sèrie
  Widget _buildMovieBox(BuildContext context, Map<String, dynamic> film) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetallsPeliSerieScreen(mediaId: film['id'])),
        );
      },
      child: Container(
        width: 135,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          image: film['png'] != null
              ? DecorationImage(
            image: NetworkImage(film['png']),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          )
              : null,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              film['name'] ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
