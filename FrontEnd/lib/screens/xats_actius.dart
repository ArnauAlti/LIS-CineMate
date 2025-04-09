import 'package:cine_mate/screens/cerca_personatges.dart';
import 'package:cine_mate/screens/gestionar_xats.dart';
import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'xat_personatge.dart';

class XatsActiusScreen extends StatefulWidget {

  const XatsActiusScreen({super.key});

  @override
  State<XatsActiusScreen> createState() => _XatsActiusScreen();
}

class _XatsActiusScreen extends State<XatsActiusScreen> {

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Chats activos"),
        centerTitle: true,

      ),
      drawer: AppDrawer(
        userRole: userRole,
        onRoleChange: (String newRole) {
          userRoleProvider.setUserRole(newRole);
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                //TODO: Afegir xats actius a partir de la BD
                _buildChatItem(
                  context,
                  name: "Sherlock Holmes",
                  message: "Lo descubrí porque...",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const XatPersonatge(nomPersonatge: "Sherlock Holmes")),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CercaPersonatgesScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Añadir nuevo chat"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GestioXats()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Eliminar chat"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, {
    required String name,
    required String message,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.black87,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
