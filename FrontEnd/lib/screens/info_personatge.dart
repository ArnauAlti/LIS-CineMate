import 'xats_actius.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';

import 'editar_personatge.dart';
import '../requests.dart';

class InfoPersonatge extends StatelessWidget {
  final String name;
  final String imagePath;
  final String contextInfo;

  const InfoPersonatge({super.key, required this.name, required this.imagePath, required this.contextInfo});

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imagePath,
                  width: 180,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),

            Center(
              child: Text(
                contextInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const Spacer(),

            userRole == "Administrador"
                ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditarPersonatgeScreen()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll<Color>(Colors.black),
                    foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  child: const Text("Editar informació"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await addCharacterToChat(name);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const XatsActiusScreen()));

                  },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll<Color>(Colors.red),
                    foregroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  child: const Text("Eliminar"),
                ),
              ],
            )
                : const SizedBox.shrink(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
