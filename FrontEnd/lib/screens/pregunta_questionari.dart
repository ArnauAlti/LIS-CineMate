import 'package:cine_mate/screens/cerca_pelicules.dart';
import 'package:cine_mate/screens/cerca_questionaris.dart';
import 'package:flutter/material.dart';
import '../requests.dart';

class PreguntaQuestionari extends StatefulWidget {
  const PreguntaQuestionari({super.key, required this.title});
  final String title;

  @override
  State<PreguntaQuestionari> createState() => _PreguntaQuestionari();
}

class _PreguntaQuestionari extends State<PreguntaQuestionari> {
  late Future<List<Map<String, dynamic>>> _questionsFuture;
  List<String?> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _questionsFuture = getQuestions(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final questions = snapshot.data ?? [];

          if (questions.isEmpty) {
            return const Center(child: Text('No se han encontrado preguntas'));
          }

          if (selectedAnswers.length != questions.length) {
            selectedAnswers = List<String?>.filled(questions.length, null);
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, i) =>
                  _buildQuestion(context, questions[i], i),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final questions = await _questionsFuture;

            int correct = 0;
            List<String> results = [];
            for (int i = 0; i < questions.length; i++) {
              final correctAnswer = questions[i]['correctAnswer'] as String?;
              final selectedAnswer = selectedAnswers[i];
              if (selectedAnswer != null) {
                if (selectedAnswer == correctAnswer) {
                  correct++;
                  results.add('Pregunta ${i + 1}: Correcta');
                } else {
                  results.add('Pregunta ${i + 1}: Incorrecta (Correcta: $correctAnswer)');
                }
              } else {
                results.add('Pregunta ${i + 1}: No respondida');
              }
            }

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Resultados del cuestionario'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Has acertado $correct de ${questions.length} preguntas.'),
                    const SizedBox(height: 10),
                    Text('Respuestas:'),
                    const SizedBox(height: 10),
                    for (var result in results) Text(result),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Tanca el diàleg
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const CercaQuestionarisScreen()),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text("FINALIZAR CUESTIONARIO"),
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, Map<String, dynamic> question, int num) {
    final String text = question['question']?.toString() ?? 'Pregunta no disponible';
    final List<String> options = (question['possibleAnswers'] as List?)?.cast<String>() ?? [];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pregunta ${num + 1}/10', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            ...options.map(
                  (option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedAnswers[num],
                onChanged: (value) {
                  setState(() {
                    selectedAnswers[num] = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
