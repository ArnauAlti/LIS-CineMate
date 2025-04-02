import 'package:flutter/material.dart';
import 'app_drawer.dart';

class CartelleraScreen extends StatefulWidget {
  const CartelleraScreen({super.key});

  @override
  State<CartelleraScreen> createState() => _CartelleraScreenState();
}

class _CartelleraScreenState extends State<CartelleraScreen> {
  String _userRole = 'Usuario No Registrado';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Cartellera", textAlign: TextAlign.center),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _userRole = value;
              });
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'Usuario No Registrado', child: Text('Usuario No Registrado')),
              const PopupMenuItem(value: 'Usuario Registrado', child: Text('Usuario Registrado')),
              const PopupMenuItem(value: 'Administrador', child: Text('Administrador')),
            ],
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      drawer: AppDrawer(
        userRole: _userRole,
        onRoleChange: (String newRole) {
          setState(() {
            _userRole = newRole;
          });
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMovieBox("Pelicula 1"),
                _buildMovieBox("Pelicula 2"),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMovieBox("Pelicula 3"),
                _buildMovieBox("Pelicula 4"),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieBox(String title) {
    return Container(
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
    );
  }
}
