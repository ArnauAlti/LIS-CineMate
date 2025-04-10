import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'app_drawer.dart';
import 'questionaris_disponibles.dart';

class CercaQuestionarisScreen extends StatelessWidget {
  const CercaQuestionarisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Cuestionarios", textAlign: TextAlign.center),
      ),
      drawer: AppDrawer(
        userRole: userRole,
        onRoleChange: (String newRole) {
          userRoleProvider.setUserRole(newRole);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(100.0),

        child: TextField(
          decoration: InputDecoration(
            hintText: "Introduce el título de la película o serie...",
            prefixIcon: Icon(Icons.search),
            fillColor: Color(0xFFEAE6f3),
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 14.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide.none,
            )
          ),
        ),
      ),
    );
  }
}
