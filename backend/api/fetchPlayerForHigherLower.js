const pool = require('../database/db.js')

function fetchPlayerForHigherLower(){
    const query = `
        SELECT players.*, teams.name AS club
        FROM players
        JOIN teams ON players.team_id = teams.id
        WHERE teams.popularity = 1
        ORDER BY RANDOM()
        LIMIT 1
    `;
    return pool.query(query)
        .then(result => result.rows[0])
        .catch(err => {
            console.error('Error fetching player for higher-lower game:', err);
            throw err;
        });
}

module.exports = fetchPlayerForHigherLower;