import 'package:flutter/material.dart';

class BibliotecaSeguitsScreen extends StatefulWidget {
  final String userName;

  const BibliotecaSeguitsScreen({super.key, required this.userName});

  @override
  State<BibliotecaSeguitsScreen> createState() => _BibliotecaSeguitsScreenState();
}

class _BibliotecaSeguitsScreenState extends State<BibliotecaSeguitsScreen> {
  bool isPeliculasSelected = true;

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
      body: Column(
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
          Expanded(
            child: Column(
              children: [
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
        ],
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
        //TODO: Anar als detalls de biblioteca de l'usuari seleccionat
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
