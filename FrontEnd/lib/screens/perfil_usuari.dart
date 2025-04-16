import 'package:flutter/material.dart';
import '../requests.dart';

class PerfilUsuari extends StatefulWidget {
  const PerfilUsuari({super.key});

  @override
  State<PerfilUsuari> createState() => _PerfilUsuari();
}

class _PerfilUsuari extends State<PerfilUsuari> {
  //TODO: Agafar dades de la BD del perfil de l'usuari
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController mailController = TextEditingController();
  late final TextEditingController nickController = TextEditingController();
  late final TextEditingController birthController = TextEditingController();
  late final TextEditingController passController = TextEditingController();

  //TODO: Mantener foto de perfil una vez seleccionada
  final List<String> _profileImages = List.generate(9, (index) => 'assets/perfil${index + 1}.jpg');
  String _selectedImage = 'assets/perfil1.jpg';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Tu perfil", textAlign: TextAlign.center),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
                child: Column(
                  children: [
                    // Imagen de perfil seleccionada
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(_selectedImage),
                    ),
                    const SizedBox(height: 12),
                    const Text("Selecciona tu imagen de perfil:"),
                    const SizedBox(height: 12),

                    // Selector de imágenes
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _profileImages.length,
                        itemBuilder: (context, index) {
                          final image = _profileImages[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImage = image;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _selectedImage == image
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 3,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(image),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildTextFormField("Nombre", nameController),
                    _buildTextFormField("Email", mailController),
                    _buildTextFormField("Nombre de usuario", nickController),
                    _buildTextFormField("Año de nacimiento", birthController),
                    _buildTextFormField("Contraseña", passController, isPassword: true),
                    ElevatedButton(
                      onPressed: () {
                        //TODO: Passar variables modificades a BackEnd per fer comprovació amb la BD
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cambios guardados correctamente.')),
                        );},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                    child: const Text("Guardar dades"),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          keyboardType: label == "Email"
              ? TextInputType.emailAddress
              : label == "Año de nacimiento"
              ? TextInputType.number
              : TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio';
            }
            if (label == "Email" && !value.contains('@')) {
              return 'Email inválido';
            }
            if (label == "Año de nacimiento" && int.tryParse(value) == null) {
              return 'Debe ser un número';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            )
                : null,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
