import 'package:cine_mate/screens/detalls_peli_serie.dart';
import 'package:flutter/material.dart';

class RecomanacionsGeneradesScreen extends StatefulWidget {
  final String? selectedGenre;

  const RecomanacionsGeneradesScreen({super.key, this.selectedGenre});

  @override
  State<RecomanacionsGeneradesScreen> createState() => _RecomanacionsGenerades();
}

class _RecomanacionsGenerades extends State<RecomanacionsGeneradesScreen> {

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
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
                  "Género con mayor peso: ${widget.selectedGenre}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

            const SizedBox(height: 50),
            Column(
              children: [
                //TODO: Agafar pel·lícules i sèries a partir de la BD de la IA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMovieBox(context, "Película 1"),
                    _buildMovieBox(context, "Película 2"),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMovieBox(context, "Película 3"),
                    _buildMovieBox(context, "Película 4"),
                  ],
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _buildMovieBox(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallsPeliSerieScreen(title: title),
          ),
        );
      },
      child: Container(
        width: 135,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
