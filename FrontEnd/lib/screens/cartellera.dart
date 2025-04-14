import 'package:cine_mate/screens/cerca_pelicules.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_role_provider.dart';
import 'afegir_peli_admin.dart';
import 'app_drawer.dart';


class CartelleraScreen extends StatelessWidget {
  const CartelleraScreen({super.key});

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
        title: const Text("Cartellera", textAlign: TextAlign.center),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          //TODO: Comunicació amb BackEnd per agafar pel·lícules i sèries de la BD
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMovieBox(context, "Pelicula 1"),
                  _buildMovieBox(context, "Pelicula 2"),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMovieBox(context, "Pelicula 3"),
                  _buildMovieBox(context, "Pelicula 4"),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMovieBox(context, "Pelicula 5"),
                  _buildMovieBox(context, "Pelicula 6"),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButton: userRole == "Administrador"
          ? FloatingActionButton(
        onPressed: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AfegirPeliScreen()),
          );*/
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null, // No mostris cap botó si no és administrador
    );
  }

  //Funció per construir un requadre amb cada pel·lícula o sèrie que surt per pantalla
  Widget _buildMovieBox(BuildContext context, String title) {
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
