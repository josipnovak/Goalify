const pool = require('../database/db.js');

async function checkHigherLowerPlayer(req, res){
    const query = `
        SELECT * FROM players WHERE id = $1 OR id = $2
    `;
    const result = await pool.query(query, [req.params.leftPlayerId, req.params.rightPlayerId]);

    if(result.rows.length !== 2) {
        return res.status(404).send('Players not found');
    }

    const left = result.rows.find(player => player.id === parseInt(req.params.leftPlayerId));
    const right = result.rows.find(player => player.id === parseInt(req.params.rightPlayerId));

    const leftMV = left.market_value;
    const rightMV = right.market_value;

    let correct;

    if(req.params.higher === 'true') {
        correct = leftMV >= rightMV;
    } else {
        correct = leftMV <= rightMV;
    }
    return correct;
}

module.exports = checkHigherLowerPlayer;
