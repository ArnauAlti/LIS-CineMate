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
    //TODO: Enviar dades a Backend per agafar pelis i sèries de la BD
    setState(() {
      _busqueda = _controller.text.trim();
    });

    // Navegar a la pantalla de resultados
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultatsPelicules(
          search: _busqueda,
          genre: _genereSeleccionat ?? "No especificat",
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
        title: const Text("Búsqueda", textAlign: TextAlign.center),
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
                      hintText: "Introduce el título de la película o serie.",
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
                    "Filtrar",
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
                        //TODO: Aplicar tots els gèneres disponibles de la biblioteca
                        const Text("Gènere:"),
                        DropdownButton<String>(
                          value: _genereSeleccionat,
                          hint: const Text("Selecciona un gènere"),
                          items: const [
                            DropdownMenuItem(value: "Terror", child: Text("Terror")),
                            DropdownMenuItem(value: "Acció", child: Text("Acció")),
                            DropdownMenuItem(value: "Drama", child: Text("Drama")),
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
                        labelText: "Actor o Actriu",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _directorController,
                      decoration: const InputDecoration(
                        labelText: "Director/a",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _duracioController,
                      decoration: const InputDecoration(
                        labelText: "Duració (en minuts)",
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
