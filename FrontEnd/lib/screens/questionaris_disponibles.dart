import 'package:cine_mate/screens/cerca_pelicules.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'app_drawer.dart';

class QuestionarisDisponibles extends StatelessWidget {
  const QuestionarisDisponibles({super.key, required this.busqueda});
  final String busqueda;


  @override
  Widget build(BuildContext context) {
    //Agafar el rol actual per mostrar diferents drawers depenent del rol
    final userRoleProvider = Provider.of<UserRoleProvider>(context);
    final userRole = userRoleProvider.userRole;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Cuestionarios", textAlign: TextAlign.center),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CercaPelicules()),
              );
            },
          ),
        ],

      ),
      drawer: AppDrawer(
        userRole: userRole,
        onRoleChange: (String newRole) {
          userRoleProvider.setUserRole(newRole);
        },
      ),
      body: Center(
        //TODO: Comunicació amb BackEnd per agafar qüestionatis relacionats amb la cerca de la BD
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cuestionarios disponibles sobre: \n "$busqueda"',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuestBox(context, "Stranger Things 1"),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuestBox(context, "Stranger Things 2"),
              ],
            ),
            ],
        ),
      ),
    );
  }

  Widget _buildQuestBox(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detalls_peli_serie',
          arguments: {'title': title},
        );
      },
      child: Container(
        width: 135,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
