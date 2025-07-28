const pool = require('../database/db.js');

function fetchRandomPlayer(){
    const query = 'SELECT * FROM players ORDER BY RANDOM() LIMIT 1';
    return pool.query(query)
        .then(result => {
            if (result.rows.length > 0) {
                return result.rows[0];
            } else {
                throw new Error('No players found');
            }
        })
        .catch(err => {
            console.error('Error fetching random player:', err);
            throw new Error('Internal Server Error');
        });
}

module.exports = fetchRandomPlayer;