const pool = require('../database/db.js'); 

async function generateTicTacToe(res, difficulty) {
    const difficulties = {
        easy: 1,
        medium: 2,
        hard: 3
    };
    const query1 = 'SELECT * FROM teams WHERE popularity <= $1 ORDER BY RANDOM() LIMIT 3';
    const query2 = `
        SELECT nationality 
        FROM (
            SELECT nationality, COUNT(*) as player_count
            FROM players 
            WHERE nationality IS NOT NULL
            GROUP BY nationality
            ORDER BY player_count DESC
            LIMIT 10
        ) AS top_nationalities 
        ORDER BY RANDOM() 
        LIMIT 3`;
    const checkPlayerQuery = `
        SELECT EXISTS (
            SELECT 1 
            FROM players p 
            WHERE p.nationality = $1 AND p.team_id = $2
        )`;

    const maxAttempts = 200; 
    let attempts = 0;
    let validGrid = false;
    let response;

    while (!validGrid && attempts < maxAttempts) {
        attempts++;
        try {
            const [result1, result2] = await Promise.all([pool.query(query1, [difficulties[difficulty]]), pool.query(query2)]);
            if (result1.rows.length !== 3) {
                console.log(`Attempt ${attempts}: Insufficient teams`);
                continue;
            }
            const teams = result1.rows;
            const nationalities = result2.rows.map(row => row.nationality);

            if (nationalities.length !== 3 || nationalities.some(n => n == null)) {
                console.log(`Attempt ${attempts}: Insufficient or invalid nationalities`);
                continue;
            }
            const gridChecks = [];
            for (const nationality of nationalities) {
                for (const team of teams) {
                    gridChecks.push(
                        pool.query(checkPlayerQuery, [nationality, team.id])
                            .then(result => ({
                                nationality,
                                team: team.name,
                                playerExists: result.rows[0].exists
                            }))
                            .catch(err => {
                                console.error(`Error checking player for nationality=${nationality}, team_id=${team.id}:`, err);
                                return {
                                    nationality,
                                    team: team.name,
                                    playerExists: false
                                };
                            })
                    );
                }
            }

            const gridResults = await Promise.all(gridChecks);
            const trueCount = gridResults.filter(item => item.playerExists).length;
            if (trueCount >= 8) {
                validGrid = true;
                response = {
                    teams: teams,
                    nationalities: nationalities
                };
            }
        } catch (err) {
            console.error(`Attempt ${attempts}: Error fetching data:`, err);
            continue;
        }
    }

    if (validGrid) {
        return response;
    } else {
        console.error(`Failed to find a grid with at least 8 true values after ${maxAttempts} attempts`);
        return { error: 'Could not generate right now, please try again later.' };
    }
}

module.exports = generateTicTacToe;