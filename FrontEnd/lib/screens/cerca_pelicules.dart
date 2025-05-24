import 'package:flutter/material.dart';
import '../requests.dart'; // Asegúrate de que aquí esté la función getGenres
import 'resultats_pelicules.dart';

class CercaPelicules extends StatefulWidget {
  const CercaPelicules({super.key});

  @override
  State<CercaPelicules> createState() => _CercaPeliculesState();
}

class _CercaPeliculesState extends State<CercaPelicules> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _actorController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _duracioController = TextEditingController();

  bool _mostrarFiltres = false;
  String _busqueda = "";
  String? _genereSeleccionat;

  late Future<List<Map<String, dynamic>>> _genresFuture;

  @override
  void initState() {
    super.initState();
    _genresFuture = getGenres();
  }

  void _realitzarBusqueda() {
    setState(() {
      _busqueda = _controller.text.trim();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultatsPelicules(
          search: _busqueda,
          genre: _genereSeleccionat ?? "",
          actor: _actorController.text,
          director: _directorController.text,
          duration: int.tryParse(_duracioController.text) ?? 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Search"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _realitzarBusqueda(),
                    decoration: const InputDecoration(
                      hintText: "Intro the title from the film or series",
                      prefixIcon: Icon(Icons.search),
                      fillColor: Color(0xFFEAE6f3),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _realitzarBusqueda,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(14),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                const Icon(Icons.filter_alt_outlined, size: 20),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _mostrarFiltres = !_mostrarFiltres;
                    });
                  },
                  child: const Text(
                    "Filters",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (_mostrarFiltres)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAE6F3),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Genre:"),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _genresFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text("Error loading genres");
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text("No genres available");
                            }

                            final genres = snapshot.data!;

                            return DropdownButton<String>(
                              value: _genereSeleccionat,
                              hint: const Text("Select a genre"),
                              items: genres.map((genre) {
                                return DropdownMenuItem<String>(
                                  value: genre['moviedb'].toString(),
                                  child: Text(genre['name']),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _genereSeleccionat = value;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _actorController,
                      decoration: const InputDecoration(
                        labelText: "Actor or actress",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _directorController,
                      decoration: const InputDecoration(
                        labelText: "Director",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _duracioController,
                      decoration: const InputDecoration(
                        labelText: "Maximum duration (in minutes)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}