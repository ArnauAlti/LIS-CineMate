import 'package:cine_mate/screens/detalls_peli_follower.dart';
import 'package:cine_mate/screens/usuaris_seguits.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../requests.dart';
import '../user_role_provider.dart';

class BibliotecaSeguitsScreen extends StatefulWidget {
  final String userMail;
  final String userNick;
  final bool follows;

  const BibliotecaSeguitsScreen({super.key, required this.userMail, required this.userNick, required this.follows});

  @override
  State<BibliotecaSeguitsScreen> createState() => _BibliotecaSeguitsScreenState();
}

class _BibliotecaSeguitsScreenState extends State<BibliotecaSeguitsScreen> {
  bool isPeliculasSelected = true;
  late Future<List<Map<String, dynamic>>> _filmsFuture;

  @override
  void initState() {
    print(widget.userMail);
    super.initState();
    _filmsFuture = getLibraryFilms(widget.userMail, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text("Biblioteca de ${widget.userNick}"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _filmsFuture,
        //Comprovacions per saber si s'han agafat bé les películes de la BD
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final films = snapshot.data ?? [];

          return SingleChildScrollView(
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
                        _filmsFuture = getLibraryFilms(widget.userMail, true);
                      });
                    }),
                    const SizedBox(width: 20),
                    _buildSectionButton("Series", !isPeliculasSelected, () {
                      setState(() {
                        isPeliculasSelected = false;
                        _filmsFuture = getLibraryFilms(widget.userMail, false);
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 30),

                // Generar las filas dinámicamente
                for (int i = 0; i < films.length; i += 2)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildMovieBox(context, films[i]),
                          if (i + 1 < films.length)
                            _buildMovieBox(context, films[i + 1]),
                        ],
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final scrMail = Provider.of<UserRoleProvider>(context, listen: false).userEmail;

            if (widget.follows == true) {
              bool response = await unfollowUser(srcMail: scrMail, dstMail: widget.userMail);
              if(response){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You unfollowed ${widget.userNick}')),
                );
              }
            } else {
              bool response = await followUser(srcMail: scrMail, dstMail: widget.userMail);
              if(response){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You now follow ${widget.userNick}')),
                );
              }
            }

            Navigator.push(context, MaterialPageRoute(builder: (context) => const UsuarisSeguits()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(widget.follows == true ? "Unfollow ${widget.userNick}" : "Follow ${widget.userNick}"),
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

  Widget _buildMovieBox(BuildContext context, Map<String, dynamic> film) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallsPeliFollowerScreen(film: film),
          ),
        );
      },
      child: Container(
        width: 135,
        height: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(8),
          image: film['media_png'] != null
              ? DecorationImage(
            image: NetworkImage(film['media_png']),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          )
              : null,
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              film['media_name'] ?? 'Título desconocido',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
