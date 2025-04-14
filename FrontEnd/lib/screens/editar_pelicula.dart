import 'package:flutter/material.dart';

class EditarPeliCartelleraScreen extends StatefulWidget {
  final String mode;
  final Map<String, dynamic>? peliData;

  const EditarPeliCartelleraScreen({super.key, required this.mode, this.peliData});

  @override
  State<EditarPeliCartelleraScreen> createState() => _EditarPeliCartelleraScreenState();
}

class _EditarPeliCartelleraScreenState extends State<EditarPeliCartelleraScreen> {
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

  String? tipusSeleccionat = "Película";
  String? genereSeleccionat = "Acción";

  final List<String> tipusOpcions = ["Película", "Serie"];
  final List<String> generesOpcions = [
    "Terror",
    "Comedia",
    "Romántica",
    "Acción",
    "Drama",
    "Fantasía",
    "Ciencia Ficción"
  ];

  @override
  void initState() {
    super.initState();

    final data = widget.peliData;

    titolController = TextEditingController(text: data?["titol"] ?? "");
    repartController = TextEditingController(text: data?["repart"] ?? "");
    descripcioController = TextEditingController(text: data?["descripcio"] ?? "");
    anyEstrenoController = TextEditingController(text: data?["anyEstreno"] ?? "");
    duracioController = TextEditingController(text: data?["duracio"] ?? "");
    plataformesController = TextEditingController(text: data?["plataformes"] ?? "");
    urlFotoController = TextEditingController(text: data?["urlFoto"] ?? "");
    edatMinimaController = TextEditingController(text: data?["edatMinima"] ?? "");
    temporadaController = TextEditingController(text: data?["temporada"] ?? "");
    numCapitolsController = TextEditingController(text: data?["numCapitols"] ?? "");

    tipusSeleccionat = data?["tipus"] ?? "Película";
    genereSeleccionat = data?["genere"] ?? "Acción";
  }

  @override
  void dispose() {
    titolController.dispose();
    repartController.dispose();
    descripcioController.dispose();
    anyEstrenoController.dispose();
    duracioController.dispose();
    plataformesController.dispose();
    urlFotoController.dispose();
    edatMinimaController.dispose();
    temporadaController.dispose();
    numCapitolsController.dispose();
    super.dispose();
  }

  void _guardar() {
    final peli = {
      "titol": titolController.text.trim(),
      "repart": repartController.text.trim(),
      "descripcio": descripcioController.text.trim(),
      "anyEstreno": anyEstrenoController.text.trim(),
      "duracio": duracioController.text.trim(),
      "plataformes": plataformesController.text.trim(),
      "urlFoto": urlFotoController.text.trim(),
      "edatMinima": edatMinimaController.text.trim(),
      "temporada": temporadaController.text.trim(),
      "numCapitols": numCapitolsController.text.trim(),
      "tipus": tipusSeleccionat,
      "genere": genereSeleccionat,
    };

    if (widget.mode == "New") {
      // Guardar nueva peli
      print("Guardando nueva película:");
    } else {
      // Actualizar película existente
      print("Actualizando película:");
    }
    print(peli);
    Navigator.pop(context, peli); // Devolver datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.mode == "New" ? "Afegir Película" : "Editar Película"),
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
              _buildTextField("Título", titolController),
              _buildTextField("Reparto", repartController),
              _buildTextField("Año de estreno", anyEstrenoController),
              _buildTextField("Duración", duracioController),
              _buildTextField("Plataformas donde se encuentra", plataformesController),
              _buildTextField("Descripción", descripcioController, maxLines: 4),
              _buildTextField("URL de la foto", urlFotoController, maxLines: 2),
              _buildTextField("Edad mínima para su visualización", edatMinimaController),
              _buildDropdown("Tipos", tipusSeleccionat, tipusOpcions, (val) {
                setState(() {
                  tipusSeleccionat = val;
                });
              }),
              _buildDropdown("Género", genereSeleccionat, generesOpcions, (val) {
                setState(() {
                  genereSeleccionat = val;
                });
              }),
              if (tipusSeleccionat == "Serie") ...[
                _buildTextField("Temporada", temporadaController),
                _buildTextField("Número de capítulos", numCapitolsController),
              ],
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _guardar,
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

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
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
