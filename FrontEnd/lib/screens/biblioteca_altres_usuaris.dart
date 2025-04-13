import 'package:cine_mate/screens/detalls_peli_follower.dart';
import 'package:flutter/material.dart';

class BibliotecaAltresUsuarisScreen extends StatefulWidget {
  final String userName;
  final bool followed;

  const BibliotecaAltresUsuarisScreen({super.key, required this.userName, required this.followed});

  @override
  State<BibliotecaAltresUsuarisScreen> createState() => _BibliotecaAltresUsuarisScreen();
}

class _BibliotecaAltresUsuarisScreen extends State<BibliotecaAltresUsuarisScreen> {
  bool isPeliculasSelected = true;

  //Variable per saber si un usuari segueix a un altre
  late bool follows;

  @override
  void initState() {
    super.initState();
    follows = widget.followed;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.userName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSectionButton("Películas", isPeliculasSelected, () {
                  setState(() {
                    isPeliculasSelected = true;
                  });
                }),
                const SizedBox(width: 20),
                _buildSectionButton("Series", !isPeliculasSelected, () {
                  setState(() {
                    isPeliculasSelected = false;
                  });
                }),
              ],
            ),
            const SizedBox(height: 30),
            //TODO: Posar totes les altres pel·lícules o sèries de l'usuari visitat a partir de la BD
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMovieBox(context, isPeliculasSelected ? "Película 1" : "Serie 1"),
                _buildMovieBox(context, isPeliculasSelected ? "Película 2" : "Serie 2"),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMovieBox(context, isPeliculasSelected ? "Película 3" : "Serie 3"),
                _buildMovieBox(context, isPeliculasSelected ? "Película 4" : "Serie 4"),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              follows = !follows;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(follows ? "DEJAR DE SEGUIR" : "SEGUIR USUARIO"),
        ),
      ),
    );
  }

  Widget _buildSectionButton(String title, bool isSelected, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.black : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(title),
    );
  }

  Widget _buildMovieBox(BuildContext context, String title) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute( builder: (context) => DetallsPeliFollowerScreen(title: title),
        ));
      },
      child: Container(
        width: 135,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
