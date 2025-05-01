import 'package:cine_mate/screens/cartellera.dart';
import 'package:flutter/material.dart';

import '../requests.dart';

class EditarPeliCartelleraScreen extends StatefulWidget {
  final String mode;
  final Map<String, dynamic>? peliData;

  const EditarPeliCartelleraScreen({
    super.key,
    required this.mode,
    this.peliData,
  });

  @override
  State<EditarPeliCartelleraScreen> createState() =>
      _EditarPeliCartelleraScreenState();
}

class _EditarPeliCartelleraScreenState extends State<EditarPeliCartelleraScreen> {
  late final TextEditingController titleController;
  late final TextEditingController castController;
  late final TextEditingController descriptionController;
  late final TextEditingController releaseDateController;
  late final TextEditingController durationController;
  late final TextEditingController directorController;
  late final TextEditingController imagePathController;
  late final TextEditingController pegiController;
  late final TextEditingController seasonController;
  late final TextEditingController numChaptersController;

  String? tipusSeleccionat;
  String? genereSeleccionat;

  final List<String> tipusOpcions = ["Pel·lícula", "Sèrie"];
  final List<String> generesOpcions = [
    'Acción', 'Aventura', 'Animación', 'Infantil', 'Comedia', 'Crimen', 'Documental', 'Drama',
    'Fantasía', 'Terror', 'IMAX', 'Musical', 'Misterio','Cine negro', 'Romance', 'Ciencia ficción',
    'Suspense', 'Bélico', 'Western',
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.peliData;

    titleController = TextEditingController(text: data?["title"] ?? "");
    castController = TextEditingController(text: data?["cast"] ?? "");
    descriptionController =
        TextEditingController(text: data?["description"] ?? "");
    releaseDateController =
        TextEditingController(text: data?["releaseDate"] ?? "");
    durationController = TextEditingController(text: data?["duration"] ?? "");
    directorController =
        TextEditingController(text: data?["director"] ?? "");
    imagePathController = TextEditingController(text: data?["imagePath"] ?? "");
    pegiController =
        TextEditingController(text: data?["pegi"] ?? "");
    seasonController = TextEditingController(text: data?["season"] ?? "");
    numChaptersController =
        TextEditingController(text: data?["numChapters"] ?? "");

    // Corregim els valors per assegurar que coincideixen amb les opcions disponibles
    final tipus = data?["tipus"];
    final genere = data?["genere"];

    tipusSeleccionat = tipusOpcions.contains(tipus) ? tipus : tipusOpcions.first;
    genereSeleccionat = generesOpcions.contains(genere) ? genere : generesOpcions.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.mode == "New" ? "Añadir Película" : "Editar Película"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Título", titleController),
              _buildTextField("Reparto (Separados por comas)", castController),
              _buildTextField("Año de estreno", releaseDateController),
              _buildTextField("Duración (minutos)", durationController),
              _buildTextField("Director", directorController),
              _buildTextField("Descripción", descriptionController),
              _buildTextField("URL de la foto", imagePathController),
              _buildTextField("Edad mínima de visualización", pegiController),
              _buildDropdown("Tipus", tipusSeleccionat, tipusOpcions, (val) {
                setState(() {
                  tipusSeleccionat = val;
                });
              }),
              _buildDropdown("Gènere", genereSeleccionat, generesOpcions, (val) {
                setState(() {
                  genereSeleccionat = val;
                });
              }),
              if (tipusSeleccionat == "Sèrie") ...[
                _buildTextField("Temporada", seasonController),
                _buildTextField("Número de capítols", numChaptersController),
              ],
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final castList = castController.text.split(',').map((e) => e.trim())
                          .where((e) => e.isNotEmpty).toList();
                      final releaseDate = int.tryParse(releaseDateController.text) ?? 0;
                      final duration = int.tryParse(durationController.text) ?? 0;
                      final pegi = int.tryParse(pegiController.text) ?? 0;
                      final season = int.tryParse(seasonController.text) ?? 0;
                      final numChapters = int.tryParse(numChaptersController.text) ?? 0;


                      final success = widget.mode == "New"
                          ? await addFilm(
                        titleController.text,
                        castList,
                        releaseDate,
                        duration,
                        directorController.text,
                        imagePathController.text,
                        pegi,
                        season,
                        numChapters,
                      )
                          : await ModifyFilm(
                        titleController.text,
                        castList,
                        releaseDate,
                        duration,
                        directorController.text,
                        imagePathController.text,
                        pegi,
                        season,
                        numChapters,
                      );

                      if (!success) {
                        print('❌ La operación no tuvo éxito');
                      }
                    } catch (e) {
                      // Aquí podrías mostrar un error si algo falla al convertir datos
                      print('Error al modificar la peli: $e');
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartelleraScreen(),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${titleController.text} ha sido añadida/modificada en la base de datos.')),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: Text(widget.mode == "New" ? "Añadir" : "Guardar"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDropdown(
      String label,
      String? value,
      List<String> options,
      void Function(String?) onChanged,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: options
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}