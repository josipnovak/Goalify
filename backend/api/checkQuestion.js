const pool = require('../database/db.js');

function checkQuestion(id, option){
    return pool.query('SELECT correct_option FROM questions WHERE id = $1', [id])
        .then(result => {
            if (result.rows.length > 0) {
                const correctOption = result.rows[0].correct_option;
                return { correct: option === correctOption };
            } else {
                throw new Error('Question not found');
            }
        })
        .catch(err => {
            console.error('Error checking question:', err);
            throw err;
        });
}

module.exports = checkQuestion;