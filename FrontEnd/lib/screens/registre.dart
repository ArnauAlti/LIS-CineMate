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
                  _buildTextFormField("Nombre", nameController, hintText: "Introduce tu nombre"),
                  _buildTextFormField("Email", mailController, hintText: "Introduce tu mail"),
                  _buildTextFormField("Nombre de usuario", nickController, hintText: "Introduce tu nombre de usuario"),
                  _buildTextFormField("Fecha de nacimiento", birthController, hintText: "YYYY/MM/DD"),
                  _buildTextFormField("Contraseña", passController, isPassword: true),
                  //TODO: Quitar los roles a escoger
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
                nickController.text, birthController.text, passController.text,
              );

              if (validation) {
                userRoleProvider.setUserRole(_selectedRole);
                userRoleProvider.setUserEmail(mailController.text);

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

  //Funció per a construir un camp de text customitzat segons el nom del camp
  //Es crea una validació primària per evitar camps null o introducció de variables de diferent tipus o
  //que no segueixen el format necessari

  Widget _buildTextFormField(String label, TextEditingController controller, {bool isPassword = false, String? hintText}) {
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
              : TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio';
            }
            if (label == "Email" && !value.contains('@')) {
              return 'Email inválido';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
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
