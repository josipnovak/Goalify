const pool = require('../database/db.js');

function fetchQuestionById(id) {
    return pool.query('SELECT * FROM questions WHERE id = $1', [id])
        .then(result => {
            if (result.rows.length > 0) {
                return result.rows[0];
            } else {
                throw new Error('Question not found');
            }
        });
}

module.exports = fetchQuestionById;