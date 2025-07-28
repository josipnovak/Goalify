const pool = require('./db');
const API_KEY = '63cadfcbd6814c179f045d79c51c96fa';

fetchTeamIds().then((teamPairs => {
  console.log('Team IDs:', teamPairs);
  teamPairs.forEach(({id, api_id}) => {
    fetch(`https://api.football-data.org/v4/teams/${api_id}/`, {
      headers: { 'X-Auth-Token': API_KEY }
    })
      .then(res => res.json())
      .then(data => {
        let players = data.squad;
        players.forEach(player => {
          const playerForInsert = {
            name: removeSpecialChars(player.name),
            dateOfBirth: player.dateOfBirth,
            nationality: player.nationality,
            position: player.position,
            team_id: id,
            api_id: player.id
          }
          insertPlayer(playerForInsert);
        });
      })
      .catch(err => console.error(err));
 });
}));

async function insertPlayer(player){
    const {
        name,
        dateOfBirth,
        nationality,
        position,
        team_id,
        api_id
  } = player;

  const query = `
    INSERT INTO players (name, date_of_birth, nationality, position, team_id, api_id)
    VALUES ($1, $2, $3, $4, $5, $6)
    ON CONFLICT (api_id) DO UPDATE SET
      name = EXCLUDED.name,
      date_of_birth = EXCLUDED.date_of_birth,
      nationality = EXCLUDED.nationality,
      position = EXCLUDED.position,
      team_id = EXCLUDED.team_id
  `;

  const values = [name, dateOfBirth, nationality, position, team_id, api_id];

  try {
    await pool.query(query, values);
    console.log(`Player ${name} inserted/updated successfully.`);
  } catch (error) {
    console.error('Error inserting player:', error);
  }
}

async function fetchTeamIds(){
  const query = `
    SELECT id, api_id FROM teams
  `;

  try {
    const res = await pool.query(query);
    return res.rows;
  } catch (error) {
    console.error('Error fetching team IDs:', error);
  }
}

function removeSpecialChars(input) {
  return input
    .normalize('NFD') 
    .replace(/[\u0300-\u036f]/g, '')
    .replace(/[^A-Za-z0-9 ]/g, ''); 
}