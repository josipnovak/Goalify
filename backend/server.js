const express = require('express');
const pool = require('./database/db'); 
const fetchPlayers = require('./api/fetchPlayers');
const fetchTeams = require('./api/fetchTeams');
const fetchRandomPlayer = require('./api/fetchRandomPlayer');
const app = express();
const PORT = process.env.PORT || 3000;

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

app.get('/players/random/', (req, res) => {
    fetchRandomPlayer()
        .then(player => res.json(player))
        .catch(err => {
            console.error('Error fetching random player:', err);
            res.status(500).send('Internal Server Error');
        });
});

app.listen(PORT, () => {
    console.log(`Server radi na http://localhost:${PORT}`);
});

