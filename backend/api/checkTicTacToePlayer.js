const pool = require('../database/db.js'); 

function checkTicTacToePlayer(nation, teamId, playerId) {
    return pool.query('SELECT * FROM players WHERE nationality = $1 AND team_id = $2 AND id = $3', [nation, teamId, playerId])
        .then(result => {
            if (result.rows.length > 0) {
                return true;
            } else {
                return false;
            }
        })
        .catch(err => {
            console.error('Error checking TicTacToe grid:', err);
            res.status(500).send('Internal Server Error');
        });
}

module.exports = checkTicTacToePlayer;
