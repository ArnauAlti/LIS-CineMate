import 'package:flutter/material.dart';

class CercaUsuarisScreen extends StatefulWidget {
  const CercaUsuarisScreen({super.key});

  @override
  State<CercaUsuarisScreen> createState() => _CercaUsuarisScreenState();
}

class _CercaUsuarisScreenState extends State<CercaUsuarisScreen> {
  final TextEditingController _controller = TextEditingController();
  String _busqueda = "";

  void _realitzarBusqueda() {
    setState(() {
      _busqueda = _controller.text.trim();
    });

    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UsuarisDisponibles(busqueda: _busqueda),
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Buscar usuario", textAlign: TextAlign.center),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pop(context);
            }
        ),
      ),
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
                      hintText: "Introduce el nombre de usuario...",
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
    );
  }
}