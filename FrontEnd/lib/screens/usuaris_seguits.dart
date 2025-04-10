import 'package:cine_mate/screens/cerca_pelicules.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'app_drawer.dart';

class UsuarisSeguits extends StatelessWidget {
  const UsuarisSeguits({super.key});

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
        title: const Text("Otros usuarios", textAlign: TextAlign.center),
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
        //TODO: Comunicació amb BackEnd per agafar usuaris que segueix l'actual
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUserBox(context, "User 1"),
                _buildUserBox(context, "User 2"),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUserBox(context, "User 3"),
                _buildUserBox(context, "User 4"),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
        const SizedBox(height: 100),
        ElevatedButton(
          onPressed: () {
            //TODO: Posar link usuari escollit
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CercaQuestionarisScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text("ABANDONAR CUESTIONARIO"),
        ),
      ),
    );
  }

  Widget _buildUserBox(BuildContext context, String user) {
    return InkWell(
      onTap: () {
        /*
        Navigator.pushNamed(
          context,
          '/detalls_peli_serie',
          arguments: {'user': user},
        );*/
      },
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(user),
          ),
        ),
      ),
    );
  }
}
