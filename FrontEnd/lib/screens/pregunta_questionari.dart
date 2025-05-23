import 'package:cine_mate/screens/cerca_pelicules.dart';
import 'package:cine_mate/screens/cerca_questionaris.dart';
import 'package:flutter/material.dart';
import '../requests.dart';

class PreguntaQuestionari extends StatefulWidget {
  final String title;
  final String mediaId;

  const PreguntaQuestionari({super.key, required this.title, required this.mediaId,});

  @override
  State<PreguntaQuestionari> createState() => _PreguntaQuestionari();
}

class _PreguntaQuestionari extends State<PreguntaQuestionari> {
  late Future<List<Map<String, dynamic>>> _questionsFuture;
  List<String?> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _questionsFuture = getQuestions(widget.mediaId, false);
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
            return const Center(child: Text('No questions found'));
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
                  results.add('Question ${i + 1}: Correct');
                } else {
                  results.add('Question ${i + 1}: Incorrect (Correct: $correctAnswer)');
                }
              } else {
                results.add('Question ${i + 1}: Not answered');
              }
            }

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Results from the questionnaire'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('You selected $correct correct from ${questions.length} questions.'),
                    const SizedBox(height: 10),
                    const Text('Answers:'),
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
          child: const Text("End questionnaire"),
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context, Map<String, dynamic> question, int num) {
    final String text = question['question']?.toString() ?? 'Unknown question';
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
            Text('Question ${num + 1}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
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
