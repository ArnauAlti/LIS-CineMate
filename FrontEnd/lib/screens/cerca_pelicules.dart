import 'package:flutter/material.dart';
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

  void _realitzarBusqueda() {
    setState(() {
      _busqueda = _controller.text.trim();
    });

    // Navegar a la pantalla de resultados
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
        title: const Text("Search", textAlign: TextAlign.center),
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                //Lògica per fer sortir els filtres
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Menú desplegable per mostrar tots els gèneres
                        const Text("Genre:"),
                        DropdownButton<String>(
                          value: _genereSeleccionat,
                          hint: const Text("Select a genre"),
                          items: const [
                            DropdownMenuItem(value: "28", child: Text("Action")),
                            DropdownMenuItem(value: "12", child: Text("Adventure")),
                            DropdownMenuItem(value: "16", child: Text("Animation")),
                            DropdownMenuItem(value: "10762", child: Text("Kids")),
                            DropdownMenuItem(value: "35", child: Text("Comedy")),
                            DropdownMenuItem(value: "80", child: Text("Crime")),
                            DropdownMenuItem(value: "99", child: Text("Documentary")),
                            DropdownMenuItem(value: "18", child: Text("Drama")),
                            DropdownMenuItem(value: "14", child: Text("Fantasy")),
                            DropdownMenuItem(value: "10751", child: Text("Family")),
                            DropdownMenuItem(value: "36", child: Text("History")),
                            DropdownMenuItem(value: "27", child: Text("Horror")),
                            DropdownMenuItem(value: "10402", child: Text("Musical")),
                            DropdownMenuItem(value: "9648", child: Text("Mistery")),
                            DropdownMenuItem(value: "10749", child: Text("Romance")),
                            DropdownMenuItem(value: "878", child: Text("Science Fiction")),
                            DropdownMenuItem(value: "53", child: Text("Thriller")),
                            DropdownMenuItem(value: "10752", child: Text("War")),
                            DropdownMenuItem(value: "37", child: Text("Western")),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              _genereSeleccionat = value;
                            });
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
              )
          ],
        ),
      ),
    );
  }
}
