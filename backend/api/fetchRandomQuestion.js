const pool = require('../database/db.js');

function fetchRandomQuestion() {
    return pool.query('SELECT * FROM questions ORDER BY RANDOM() LIMIT 1')
        .then(result => {
            if (result.rows.length > 0) {
                return result.rows[0];
            } else {
                throw new Error('No questions found');
            }
        })
        .catch(err => {
            console.error('Error fetching random question:', err);
            throw new Error('Internal Server Error');
        });
}

module.exports = fetchRandomQuestion;