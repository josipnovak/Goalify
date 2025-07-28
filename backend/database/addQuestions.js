const pool = require('./db.js');
const data = require('./questions.json');

data.forEach(question => {
    const query = `
        INSERT INTO questions (question_text, option_a, option_b, option_c, option_d, correct_option, category)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        ON CONFLICT (question_text) DO UPDATE SET
            option_a = EXCLUDED.option_a,
            option_b = EXCLUDED.option_b,
            option_c = EXCLUDED.option_c,
            option_d = EXCLUDED.option_d,
            correct_option = EXCLUDED.correct_option,
            category = EXCLUDED.category
    `;
    const values = [question.question_text, question.option_a, question.option_b, question.option_c, question.option_d, question.correct_option, question.category];
    pool.query(query, values)
        .then(res => {
            console.log(`Question "${question.question_text}" inserted successfully.`);
        })
        .catch(err => {
            console.error('Error inserting question:', err);
        });
});