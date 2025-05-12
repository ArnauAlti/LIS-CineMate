import 'package:flutter/material.dart';
import 'afegir_personatge.dart';
import 'app_drawer.dart';
import 'personatges_disponibles.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';

class CercaPersonatgesScreen extends StatefulWidget {
  const CercaPersonatgesScreen({super.key});

  @override
  State<CercaPersonatgesScreen> createState() => _CercaPersonatgesScreen();
}

class _CercaPersonatgesScreen extends State<CercaPersonatgesScreen> {
  final TextEditingController _controller = TextEditingController();
  String _busqueda = "";

  void _realitzarBusqueda() {
    setState(() {
      _busqueda = _controller.text.trim();
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonatgesDisponiblesScreen(busqueda: _busqueda),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = Provider.of<UserRoleProvider>(context).userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Characters", textAlign: TextAlign.center),
      ),
      drawer: userRole == "Administrador"
          ? AppDrawer(
        userRole: userRole,
        onRoleChange: (String newRole) {
          userRoleProvider.setUserRole(newRole);
        },
      )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _realitzarBusqueda(),
                    decoration: const InputDecoration(
                      hintText: "Intro the title from the film or series",
                      prefixIcon: Icon(Icons.search),
                      fillColor: Color(0xFFEAE6f3),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _realitzarBusqueda,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(14),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: userRole == "Administrador"
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AfegirPersonatgeScreen(mode: "New", ),
            ),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }
}