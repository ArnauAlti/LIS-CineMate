import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../requests.dart';
import '../user_role_provider.dart';
import 'cartellera.dart';
import 'package:intl/intl.dart';

//TODO: Mirar por qué no cambia el nombre
class PerfilUsuari extends StatefulWidget {
  const PerfilUsuari({super.key});

  @override
  State<PerfilUsuari> createState() => _PerfilUsuari();
}

class _PerfilUsuari extends State<PerfilUsuari> {
  Map<String, dynamic>? user;

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final List<String> _profileImages = List.generate(9, (index) => 'assets/perfil${index + 1}.jpg');
  String _selectedImage = 'assets/perfil1.jpg';

  // Controllers
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final nickController = TextEditingController();
  final birthController = TextEditingController();
  final passController = TextEditingController();

  get userRoleProvider => null;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserRoleProvider>(context, listen: false);
    final data = userProvider.getUser;

    setState(() {
      user = data;
      nameController.text = data?['name'] ?? '';
      mailController.text = data?['mail'] ?? '';
      nickController.text = data?['nick'] ?? '';
      passController.text = data?['pass'] ?? '';
      _selectedImage = data?['profileImage'] ?? 'assets/perfil1.jpg';

      if (data?['birth'] != null) {
        final date = DateTime.parse(data!['birth'].toString());
        final formattedDate = DateFormat('yyyy-MM-dd').format(date);
        birthController.text = formattedDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Your profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(_selectedImage),
                  ),
                  const SizedBox(height: 12),
                  const Text("Select an image for your profile:"),
                  const SizedBox(height: 12),

                  // Selector d'imatges, permet seleccionar una de les nou imatges disponibles
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
                  _buildTextFormField("Name", nameController),
                  _buildTextFormField("Email", mailController),
                  _buildTextFormField("Nickname", nickController),
                  _buildTextFormField("Birth date", birthController),
                  _buildTextFormField("Password", passController, isPassword: true),
                  ElevatedButton(
                    onPressed: _guardarDades,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    ),
                    child: const Text("Save data"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _guardarDades() async {
    if (_formKey.currentState!.validate()) {
      // Aquí pots fer la crida a una funció per actualitzar l’usuari:
      final validation = await modifyUserInfo(nameController.text, mailController.text,
        nickController.text, birthController.text, passController.text, _selectedImage
      );

      if (validation) {
        final updatedUser = {
          'name': nameController.text,
          'mail': mailController.text,
          'nick': nickController.text,
          'birth': birthController.text,
          'pass': passController.text,
          'profileImage': _selectedImage,
          // Puedes conservar también otros campos antiguos si no se actualizan, como 'admin', 'created', etc.
          ...Provider.of<UserRoleProvider>(context, listen: false).getUser ?? {},
        };

        print(updatedUser);

        final userRoleProvider = Provider.of<UserRoleProvider>(context, listen: false);
        userRoleProvider.setUser(updatedUser);
        userRoleProvider.setUserEmail(mailController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully.')),
        );
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => const CartelleraScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to modify your data.')),
        );
      }
    }
  }

  Widget _buildTextFormField(String label, TextEditingController controller, {bool isPassword = false}) {
    final bool nonEditableField = label == "Birth date" || label == "Email" || label == "Nickname";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          enabled: !nonEditableField,
          keyboardType: label == "Email"
              ? TextInputType.emailAddress
              : TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is compulsory';
            }
            if (label == "Email" && !value.contains('@')) {
              return 'Not valid email';
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
