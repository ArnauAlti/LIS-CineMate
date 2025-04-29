import 'package:cine_mate/screens/cartellera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import '../requests.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController mailController = TextEditingController();
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
        title: const Text("Inicio de sesión", textAlign: TextAlign.center),
        centerTitle: true,
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
                  _buildTextFormField("Email", mailController),
                  _buildTextFormField("Contraseña", passController, isPassword: true),
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
              final user = await validateLogin(mailController.text, passController.text);

              if (user != null) {
                userRoleProvider.setUserRole(user["admin"] ? "Administrador" : "Usuario Registrado");
                userRoleProvider.setUserEmail(user["mail"]);
                userRoleProvider.setUser(user);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Has iniciado sesión correctamente.')),
                );
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const CartelleraScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error al iniciar sesión.')),
                );
              }
            }
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
          child: const Text("Iniciar sesión"),
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
