const pool = require('../database/db.js');

function fetchTeams() {
    const query = "SELECT * FROM teams";
    return pool.query(query)
        .then(result => result.rows)
        .catch(err => {
            console.error('Error fetching teams:', err);
            throw new Error('Internal Server Error');
        });
}

module.exports = fetchTeams;
