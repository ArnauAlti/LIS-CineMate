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

class _EditarPeliCartelleraScreenState
    extends State<EditarPeliCartelleraScreen> {
  late final TextEditingController titolController;
  late final TextEditingController repartController;
  late final TextEditingController descripcioController;
  late final TextEditingController anyEstrenoController;
  late final TextEditingController duracioController;
  late final TextEditingController plataformesController;
  late final TextEditingController urlFotoController;
  late final TextEditingController edatMinimaController;
  late final TextEditingController temporadaController;
  late final TextEditingController numCapitolsController;

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

    titolController = TextEditingController(text: data?["titol"] ?? "");
    repartController = TextEditingController(text: data?["repart"] ?? "");
    descripcioController =
        TextEditingController(text: data?["descripcio"] ?? "");
    anyEstrenoController =
        TextEditingController(text: data?["anyEstreno"] ?? "");
    duracioController = TextEditingController(text: data?["duracio"] ?? "");
    plataformesController =
        TextEditingController(text: data?["plataformes"] ?? "");
    urlFotoController = TextEditingController(text: data?["urlFoto"] ?? "");
    edatMinimaController =
        TextEditingController(text: data?["edatMinima"] ?? "");
    temporadaController = TextEditingController(text: data?["temporada"] ?? "");
    numCapitolsController =
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
              _buildTextField("Títol", titolController),
              _buildTextField("Repartiment", repartController),
              _buildTextField("Any d’estrena", anyEstrenoController),
              _buildTextField("Duració (minuts)", duracioController),
              _buildTextField("Plataformes", plataformesController),
              _buildTextField("Descripció", descripcioController),
              _buildTextField("URL de la foto", urlFotoController),
              _buildTextField("Edat mínima", edatMinimaController),
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
                _buildTextField("Temporada", temporadaController),
                _buildTextField("Número de capítols", numCapitolsController),
              ],
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print("Títol: ${titolController.text}");
                    print("Tipus: $tipusSeleccionat");
                    print("Gènere: $genereSeleccionat");
                    print("Repartiment: ${repartController.text}");
                    print("Descripció: ${descripcioController.text}");
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