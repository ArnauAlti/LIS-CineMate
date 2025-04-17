import 'package:cine_mate/screens/detalls_peli_serie.dart';
import 'package:flutter/material.dart';
import '../requests.dart';

class RecomanacionsGeneradesScreen extends StatefulWidget {
  final String? selectedGenre;

  const RecomanacionsGeneradesScreen({super.key, this.selectedGenre});

  @override
  State<RecomanacionsGeneradesScreen> createState() => _RecomanacionsGenerades();
}

class _RecomanacionsGenerades extends State<RecomanacionsGeneradesScreen> {
  late Future<List<Map<String, dynamic>>> _filmsFuture;

  @override
  void initState() {
    super.initState();
    _filmsFuture = getFilms();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Resultados"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _filmsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final films = snapshot.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    const Text("Pensamos que estas películas y/o series te pueden gustar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Mostrar el género seleccionado en una línea
                    if (widget.selectedGenre != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          //TODO: Modificar per incloure diversos pesos
                          "Género con mayor peso: ${widget.selectedGenre}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    const SizedBox(height: 50),
                    for (int i = 0; i < films.length; i += 2)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //TODO: Agafar pel·lícules i sèries a partir de la BD de la IA
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
          MaterialPageRoute(builder: (context) => DetallsPeliSerieScreen(film: film)),
        );
      },
      child: Container(
        width: 135,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              film['urlFoto'] ?? '',
              width: 100,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
            ),
            const SizedBox(height: 10),
            Text(
              film['titol'] ?? "Sense títol",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
