const express = require('express');
const pool = require('./database/db'); 
const fetchPlayers = require('./api/fetchPlayers');
const fetchTeams = require('./api/fetchTeams');
const fetchRandomPlayer = require('./api/fetchRandomPlayer');
const fetchQuestions = require('./api/fetchQuestions');
const fetchPlayerById = require('./api/fetchPlayerById');
const fetchQuestionById = require('./api/fetchQuestionById');
const checkQuestion = require('./api/checkQuestion');
const fetchRandomQuestion = require('./api/fetchRandomQuestion');
const generateTicTacToe = require('./api/generateTicTacToe');
const checkTicTacToePlayer = require('./api/checkTicTacToePlayer');
const fetchPlayerForHigherLower = require('./api/fetchPlayerForHigherLower');
const checkHigherLowerPlayer = require('./api/checkHigherLowerPlayer');
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

app.get('/player/:id', (req, res) => {
    fetchPlayerById(req.params.id)
        .then(player => res.json(player))
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

app.get('/question/:id', (req, res) => {
    fetchQuestionById(req.params.id)
        .then(question => res.json(question))
        .catch(err => {
            console.error('Error fetching question:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.get('/questions/random', (req, res) => {
    fetchRandomQuestion()
        .then(question => res.json(question))
        .catch(err => {
            console.error('Error fetching random question:', err);
            res.status(500).send('Internal Server Error');
        });
}); 

app.get('/check_question/:id/:option', (req, res) => {
    checkQuestion(req.params.id, req.params.option)
        .then(result => res.json(result))
        .catch(err => {
            console.error('Error checking question:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.get('/generate/tictactoe/:difficulty', async (req, res) => {
    generateTicTacToe(res, req.params.difficulty)
        .then(result => res.json(result))
        .catch(err => {
            console.error('Error generating TicTacToe game:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.get('/tictactoe/check/:nation/:teamId/:playerId', (req, res) => {
    checkTicTacToePlayer(req.params.nation, req.params.teamId, req.params.playerId)
        .then(result => {
            if (result) {
                res.json({ success: true });
            } else {
                res.json({ success: false });
            }
        })
        .catch(err => {
            console.error('Error checking TicTacToe player:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.get('/higherlower/player/', (req, res) => {
    fetchPlayerForHigherLower()
        .then(player => res.json(player))
        .catch(err => {
            console.error('Error fetching player for higher-lower game:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.get('/higherlower/check/:leftPlayerId/:rightPlayerId/:higher', async (req, res) => {
    await checkHigherLowerPlayer(req, res)
        .then(result => res.json(
            { success: result }
        ))
        .catch(err => {
            console.error('Error checking higher-lower player:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.get('/', (req, res) => {
    res.send(`
        <h1>Goalify API Endpoints</h1>
        <ul>
            <li>GET /teams/</li>
            <li>GET /players/?search=</li>
            <li>GET /player/:id</li>
            <li>GET /players/random/</li>
            <li>GET /questions/</li>
            <li>GET /question/:id</li>
            <li>GET /questions/random</li>
            <li>GET /check_question/:id/:option</li>
            <li>GET /generate/tictactoe/:difficulty</li>
            <li>GET /tictactoe/check/:nation/:teamId/:playerId</li>
            <li>GET /higherlower/player/</li>
            <li>GET /higherlower/check/:leftPlayerId/:rightPlayerId/:higher </li>
        </ul>
    `);
});

app.listen(PORT, () => {
    console.log(`Server running at: http://localhost:${PORT}`);
});

