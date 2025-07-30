const express = require('express');
const pool = require('./database/db'); 
const fetchPlayers = require('./api/fetchPlayers');
const fetchTeams = require('./api/fetchTeams');
const fetchRandomPlayer = require('./api/fetchRandomPlayer');
const fetchQuestions = require('./api/fetchQuestions');
const cors = require('cors');
const app = express();
app.use(cors());
const PORT = process.env.PORT || 8080;

app.use(express.static('public'));

app.get('/teams/', (req, res) => {
    fetchTeams()
        .then(teams => res.json(teams))
        .catch(err => {
            console.error('Error fetching teams:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.get('/players/', (req, res) => {
    fetchPlayers(req.query.search || '')
        .then(players => res.json(players))
        .catch(err => {
            console.error('Error fetching players:', err);
            res.status(500).send('Internal Server Error');
        });
});    

app.get('/players/:id', (req, res) => {
    const playerId = req.params.id;
    pool.query('SELECT * FROM players WHERE id = $1', [playerId])
        .then(result => {
            if (result.rows.length > 0) {
                res.json(result.rows[0]);
            } else {
                res.status(404).send('Player not found');
            }
        })
        .catch(err => {
            console.error('Error fetching player:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.get('/players/random/', (req, res) => {
    fetchRandomPlayer()
        .then(player => res.json(player))
        .catch(err => {
            console.error('Error fetching random player:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.get('/questions/', (req, res) => {
    fetchQuestions()
        .then(questions => res.json(questions))
        .catch(err => {
            console.error('Error fetching questions:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.get('/questions/:id', (req, res) => {
    const questionId = req.params.id;
    pool.query('SELECT * FROM questions WHERE id = $1', [questionId])
        .then(result => {
            if (result.rows.length > 0) {
                res.json(result.rows[0]);
            } else {
                res.status(404).send('Question not found');
            }
        })
        .catch(err => {
            console.error('Error fetching question:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.get('/check_questions/:id/:option', (req, res) => {
    const questionId = req.params.id;
    const selectedOption = req.params.option;
    pool.query('SELECT correct_option FROM questions WHERE id = $1', [questionId])
        .then(result => {
            if (result.rows.length > 0) {
                const correctOption = result.rows[0].correct_option;
                res.json({ isCorrect: selectedOption === correctOption });
            } else {
                res.status(404).send('Question not found');
            }
        })
        .catch(err => {
            console.error('Error checking question:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.listen(PORT, () => {
    console.log(`Server radi na http://localhost:${PORT}`);
});

