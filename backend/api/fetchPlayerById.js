const pool = require('../database/db.js');

function fetchPlayerById(id) {
    return pool.query('SELECT * FROM players WHERE id = $1', [id])
        .then(result => {
            if (result.rows.length > 0) {
                return result.rows[0];
            } else {
                throw new Error('Player not found');
            }
        });
}

module.exports = fetchPlayerById;