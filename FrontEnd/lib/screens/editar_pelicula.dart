import 'package:flutter/material.dart';

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
  late final TextEditingController plataformsController;
  late final TextEditingController imagePathController;
  late final TextEditingController PegiController;
  late final TextEditingController seasonController;
  late final TextEditingController numChaptersController;

  String? tipusSeleccionat;
  String? genereSeleccionat;

  final List<String> tipusOpcions = ["Pel·lícula", "Sèrie"];
  final List<String> generesOpcions = [
    "Terror",
    "Comèdia",
    "Romàntica",
    "Acció",
    "Drama",
    "Fantasia",
    "Ciència-ficció"
  ];

  @override
  void initState() {
    super.initState();
    final data = widget.peliData;

    titleController = TextEditingController(text: data?["titol"] ?? "");
    castController = TextEditingController(text: data?["repart"] ?? "");
    descriptionController =
        TextEditingController(text: data?["descripcio"] ?? "");
    releaseDateController =
        TextEditingController(text: data?["anyEstreno"] ?? "");
    durationController = TextEditingController(text: data?["duracio"] ?? "");
    plataformsController =
        TextEditingController(text: data?["plataformes"] ?? "");
    imagePathController = TextEditingController(text: data?["urlFoto"] ?? "");
    PegiController =
        TextEditingController(text: data?["edatMinima"] ?? "");
    seasonController = TextEditingController(text: data?["temporada"] ?? "");
    numChaptersController =
        TextEditingController(text: data?["numCapitols"] ?? "");

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
        title: Text(widget.mode == "New" ? "Afegir Pel·lícula" : "Editar Pel·lícula"),
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
              _buildTextField("Reparto", castController),
              _buildTextField("Año de estreno", releaseDateController),
              _buildTextField("Duración (minutos)", durationController),
              _buildTextField("Plataformas", plataformsController),
              _buildTextField("Descripción", descriptionController),
              _buildTextField("URL de la foto", imagePathController),
              _buildTextField("Edad mínima de visualización", PegiController),
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
                  onPressed: () {
                    //TODO: Passar noves variables a backend per actualitzar BD
                    print("Títol: ${titleController.text}");
                    print("Tipus: $tipusSeleccionat");
                    print("Gènere: $genereSeleccionat");
                    print("Repartiment: ${castController.text}");
                    print("Descripció: ${descriptionController.text}");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  ),
                  child: Text(widget.mode == "New" ? "Afegir" : "Guardar"),
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