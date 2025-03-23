const express = require('express');
const axios = require('axios');

const app = express();
const port = 3000;

app.use(express.json()); // Middleware to parse JSON

app.get("/hello", async (req, res) => {
    var patata = {}
    patata["patata"] = "patata_answer"
    patata["zanahoria"] = "zanahoria_answer"
    res.status(200).json(patata);
})

// Endpoint that calls another service and returns the response
app.get('/fastapi', async (req, res) => {
    try {
        const response = await axios.get("http://fastapi:8000/hello");
        res.status(200).send(response.data.message);
    } catch (error) {
        res.status(500).json({ error: 'Error connecting to backend service', details: error.message });
    }
});

app.listen(port, () => {
    console.log(`API running on http://localhost:${port}`);
});