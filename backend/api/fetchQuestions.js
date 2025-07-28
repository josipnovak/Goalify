const pool = require('../database/db.js');

function fetchQuestions(){
    const query = 'SELECT * FROM questions';
    return pool.query(query)
        .then(result => {
            if (result.rows.length > 0) {
                return result.rows;
            } else {
                throw new Error('No questions found');
            }
        })
        .catch(err => {
            console.error('Error fetching questions:', err);
            throw new Error('Internal Server Error');
        });
}

module.exports = fetchQuestions;