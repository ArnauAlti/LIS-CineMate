import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'cartellera.dart';
import '../requests.dart';

class RegistreScreen extends StatefulWidget {
  const RegistreScreen({super.key});

  @override
  State<RegistreScreen> createState() => _RegistreScreenState();
}

class _RegistreScreenState extends State<RegistreScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = "Usuario Registrado";
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController mailController = TextEditingController();
  late final TextEditingController nickController = TextEditingController();
  late final TextEditingController birthController = TextEditingController();
  late final TextEditingController passController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Registro", textAlign: TextAlign.center),
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
                  _buildTextFormField("Nombre", nameController),
                  _buildTextFormField("Email", mailController),
                  _buildTextFormField("Nombre de usuario", nickController),
                  _buildTextFormField("Año de nacimiento", birthController),
                  _buildTextFormField("Contraseña", passController, isPassword: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Rol: "),
                      DropdownButton<String>(
                        value: _selectedRole,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRole = newValue!;
                          });
                        },
                        items: <String>[
                          "Usuario Registrado",
                          "Administrador",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final validation = await validateRegister(nameController.text, mailController.text,
                nickController.text, int.parse(birthController.text), passController.text,
              );

              if (validation) {
                userRoleProvider.setUserRole(_selectedRole);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Te has registrado correctamente.')),
                );
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const CartelleraScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al registrar.')),
                );
              }
            }
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
          child: const Text("Registrarse"),
        ),
      ),
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
