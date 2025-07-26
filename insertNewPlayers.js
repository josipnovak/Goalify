const pool = require('./db');
const API_KEY = '63cadfcbd6814c179f045d79c51c96fa';

fetchTeamIds().then(teamIds => {
  console.log('Team IDs:', teamIds);
    fetch(`https://api.football-data.org/v4/teams/${teamIds[0]}/`, {
      headers: { 'X-Auth-Token': API_KEY }
    })
      .then(res => res.json())
      .then(data => {
        console.log(data.squad[0]);
      })
      .catch(err => console.error(err));
});
// const player = {
//   id: data.id,
//   name: `${data.firstName} ${data.lastName}`,
//   dateOfBirth: data.dateOfBirth,
//   nationality: data.nationality,
//   position: data.position,
// };
// console.log(player);
// insertPlayer(player);

async function insertPlayer(player){
    const {
        name,
        dateOfBirth,
        nationality,
        position,
        team_id
  } = player;

  const query = `
    INSERT INTO players (name, date_of_birth, nationality, position, team_id)
    VALUES ($1, $2, $3, $4, $5)
    ON CONFLICT (id) DO UPDATE SET
      name = EXCLUDED.name,
      date_of_birth = EXCLUDED.date_of_birth,
      nationality = EXCLUDED.nationality,
      position = EXCLUDED.position,
      team_id = EXCLUDED.team_id
  `;

  const values = [name, dateOfBirth, nationality, position, team_id];

  try {
    await pool.query(query, values);
    console.log(`Player ${name} inserted/updated successfully.`);
  } catch (error) {
    console.error('Error inserting player:', error);
  }
}

async function fetchTeamIds(){
  const query = `
    SELECT api_id FROM teams
  `;

  try {
    const res = await pool.query(query);
    const teamIds = res.rows.map(row => row.api_id);
    return teamIds;
  } catch (error) {
    console.error('Error fetching team IDs:', error);
  }
}
