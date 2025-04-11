import 'package:flutter/material.dart';

class ResultatsPelicules extends StatelessWidget {
  final String busqueda;
  final String? genereSeleccionat;
  final String paraula;
  final String actor;
  final String director;
  final String duracio;

  const ResultatsPelicules({
    required this.busqueda,
    required this.genereSeleccionat,
    required this.paraula,
    required this.actor,
    required this.director,
    required this.duracio,
  });

  //TODO: Connexió amb BackEnd per aconseguir les pel·lícules i sèries cercades
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Resultados de la búsqueda"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Centrar el texto de la búsqueda
              Text(
                'Búsqueda realizada para: "$busqueda"',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Mostrar filtros solo si se han especificado
              if (genereSeleccionat != null && genereSeleccionat != "No especificat") ...[
                Text('Gènere seleccionat: $genereSeleccionat'),
                const SizedBox(height: 8),
              ],
              if (paraula.isNotEmpty) ...[
                Text('Paraula clau: $paraula'),
                const SizedBox(height: 8),
              ],
              if (actor.isNotEmpty) ...[
                Text('Actor/Actriu: $actor'),
                const SizedBox(height: 8),
              ],
              if (director.isNotEmpty) ...[
                Text('Director/a: $director'),
                const SizedBox(height: 8),
              ],
              if (duracio.isNotEmpty) ...[
                Text('Duració: $duracio'),
                const SizedBox(height: 8),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMovieBox(context, "Pelicula 1"),
                  _buildMovieBox(context, "Pelicula 2"),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildMovieBox(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detalls_peli_serie',
          arguments: {'title': title},
        );
      },
      child: Container(
        width: 135,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
