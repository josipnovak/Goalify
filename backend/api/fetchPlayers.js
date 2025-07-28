const pool = require('../database/db.js');

function fetchPlayers(search) {
    const query = "SELECT * FROM players WHERE name ILIKE $1";
    return pool.query(query, [`%${search}%`])
        .then(result => result.rows)
        .catch(err => {
            console.error('Error fetching players with search:', err);
            throw new Error('Internal Server Error');
        });
}

module.exports = fetchPlayers;
