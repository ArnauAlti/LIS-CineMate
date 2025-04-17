import 'package:flutter/material.dart';
import '../requests.dart';
import 'detalls_peli_serie.dart';

class ResultatsPelicules extends StatefulWidget {
  final String busqueda;
  final String? genereSeleccionat;
  final String paraula;
  final String actor;
  final String director;
  final String duracio;

  const ResultatsPelicules({
    super.key,
    required this.busqueda,
    required this.genereSeleccionat,
    required this.paraula,
    required this.actor,
    required this.director,
    required this.duracio,
  });

  @override
  State<ResultatsPelicules> createState() => _ResultatsPeliculesState();
}

class _ResultatsPeliculesState extends State<ResultatsPelicules> {
  late Future<List<Map<String, dynamic>>> _filmsFuture;

  @override
  void initState() {
    super.initState();
    _filmsFuture = getFilms(); // Aquí podrías reemplazar con una función filtrada si la tienes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Resultats de la cerca"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
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
            child: Column(
              children: [
                _buildSearchInfo(),
                const SizedBox(height: 20),
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
          );
        },
      ),
    );
  }

  Widget _buildSearchInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Búsqueda realizada para: "${widget.busqueda}"',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        if (widget.genereSeleccionat != null &&
            widget.genereSeleccionat != "No especificat") ...[
          Text('Gènere seleccionat: ${widget.genereSeleccionat}'),
          const SizedBox(height: 8),
        ],
        if (widget.paraula.isNotEmpty) ...[
          Text('Paraula clau: ${widget.paraula}'),
          const SizedBox(height: 8),
        ],
        if (widget.actor.isNotEmpty) ...[
          Text('Actor/Actriu: ${widget.actor}'),
          const SizedBox(height: 8),
        ],
        if (widget.director.isNotEmpty) ...[
          Text('Director/a: ${widget.director}'),
          const SizedBox(height: 8),
        ],
        if (widget.duracio.isNotEmpty) ...[
          Text('Duració: ${widget.duracio}'),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _buildMovieBox(BuildContext context, Map<String, dynamic> film) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetallsPeliSerieScreen(film: film)),
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
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported),
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
