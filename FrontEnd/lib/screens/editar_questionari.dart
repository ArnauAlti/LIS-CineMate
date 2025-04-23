import 'package:flutter/material.dart';


//TODO: Fer request per editar les coses del questionari, canviar distribució
class QuestionariAdminScreen extends StatefulWidget {
  const QuestionariAdminScreen({super.key});

  @override
  State<QuestionariAdminScreen> createState() => _QuestionariAdminScreenState();
}

class _QuestionariAdminScreenState extends State<QuestionariAdminScreen> {
  final TextEditingController preguntaController = TextEditingController(
    text: "Quin és el personatge que desapareix al principi de la temporada?",
  );

  final List<TextEditingController> respostaControllers = [
    TextEditingController(text: "VECNA"),
    TextEditingController(text: "ELEVEN"),
    TextEditingController(text: "WILL"),
    TextEditingController(text: "DUSTIN"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Stranger Things: 1a Temporada"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              "Pregunta 1/5",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Pregunta editable
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person, color: Colors.black54),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: preguntaController,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  right: 8,
                  top: 8,
                  child: Icon(Icons.edit, size: 20, color: Colors.black45),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Respuestas editables
            Wrap(
              spacing: 20,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: List.generate(4, (index) {
                return Stack(
                  children: [
                    SizedBox(
                      width: 140,
                      child: TextField(
                        controller: respostaControllers[index],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const Positioned(
                      right: 8,
                      top: 4,
                      child: Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ],
                );
              }),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                // Acción al pasar a la siguiente pregunta
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text("Siguiente pregunta"),
            ),
          ],
        ),
      ),
    );
  }
}
