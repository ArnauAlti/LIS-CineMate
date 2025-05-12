import 'package:cine_mate/screens/inici_sessio.dart';
import 'package:flutter/material.dart';
import '../requests.dart';

class RegistreScreen extends StatefulWidget {
  const RegistreScreen({super.key});

  @override
  State<RegistreScreen> createState() => _RegistreScreenState();
}

class _RegistreScreenState extends State<RegistreScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController mailController = TextEditingController();
  late final TextEditingController nickController = TextEditingController();
  late final TextEditingController birthController = TextEditingController();
  late final TextEditingController passController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Register", textAlign: TextAlign.center),
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
                  _buildTextFormField("Name", nameController, hintText: "Introduce your name"),
                  _buildTextFormField("Email", mailController, hintText: "Introduce your email"),
                  _buildTextFormField("Nickname", nickController, hintText: "Introduce your nickname"),
                  _buildTextFormField("Birth date", birthController, hintText: "YYYY/MM/DD"),
                  _buildTextFormField("Password", passController, isPassword: true),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You registered successfully.')),
                );
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to register.')),
                );
              }
            }
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
          child: const Text("Register"),
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
              return 'This field is compulsory';
            }
            if (label == "Email" && !value.contains('@')) {
              return 'Email not valid';
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
