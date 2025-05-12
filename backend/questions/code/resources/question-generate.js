const axios = require("axios");
const userDB = require("./db-data.js");

async function generateQuestions(req, res) {
    try {
        const { info_id } = req.body;
        if (!info_id) {
            return res.status(400).json({ error: "Falta info_id" });
        }

        const query = await userDB.query(`
            SELECT i.synopsis AS summary
            FROM info i
            JOIN media m ON m.id = i.media_id
            WHERE i.id = $1
        `, [info_id]);

        if (query.rowCount === 0) {
            return res.status(404).json({ error: "No s'ha trobat cap pel·lícula amb aquest info_id" });
        }

        const summary = query.rows[0].summary;

        const prompt = `
You are given a context about the movie Exterritorial. Your task is to generate exactly five multiple‑choice questions based only on the plot.

Each question must have:
1 correct answer
3 plausible but incorrect distractors
Options labeled A, B, C, D
A field "correct_answer" with the letter of the right option

Return only one JSON object like this (do NOT add any other text):

{
  "questions": [
    {
      "question": "string",
      "options": {
        "A": "string",
        "B": "string",
        "C": "string",
        "D": "string"
      },
      "correct_answer": "A|B|C|D"
    }
  ]
}

Context:
"""${summary}"""
`;

        const response = await axios.post(
            "https://vc0ksja03tthzq-8000.proxy.runpod.net/generate/",
            {
                prompt,
                max_new_tokens: 500,
                temperature: 0.7,
                top_p: 0.9
            },
            {
                timeout: 120000
            }
        );

        const rawOutput = response.data?.output || "";
        console.log("Preguntes generades:", rawOutput);
        // Extracció segura del JSON amb regex
        const match = rawOutput.match(/{\s*"questions"\s*:\s*\[.*?\]\s*}/s);

        if (!match) {
            throw new Error("No s'ha pogut trobar cap bloc JSON vàlid a la resposta del model.\n" + rawOutput);
        }

        let questionsData;
        try {
            questionsData = JSON.parse(match[0]);
        } catch (err) {
            throw new Error("Error en parsejar el bloc JSON: " + err.message);
        }

        const questionsArray = questionsData.questions;
        if (!questionsArray || !Array.isArray(questionsArray)) {
            throw new Error("Estructura de resposta no vàlida del model.");
        }

        for (const q of questionsArray) {
            const { question, options, correct_answer } = q;

            if (!question || !options || !correct_answer) continue;

            const optionValues = Object.values(options);
            const optionLabels = Object.keys(options);
            const validIndex = optionLabels.indexOf(correct_answer);
            console.log("Preguntes: ");
            console.log("optionValues:", optionValues);
            console.log("optionLabels:", optionLabels);
            console.log("validIndex:", validIndex);
            console.log({
                info_id,
                question,
                answers: optionValues,
                validIndex
            });

            if (validIndex === -1) continue;
            await userDB.query(`
                INSERT INTO questions (info_id, question, answers, valid)
                VALUES ($1, $2, $3, $4)
            `, [info_id, question, JSON.stringify(optionValues), validIndex]);
        }
        console.log("Preguntes generades:", JSON.stringify(questionsArray, null, 2));
        res.status(200).json({
            ok: true,
            message: "Qüestionari generat correctament",
            questions: questionsArray
        });

    } catch (error) {
        console.error("Error:", error.message);
        res.status(500).json({ ok: false, error: error.message });
    }
}

module.exports = generateQuestions;
