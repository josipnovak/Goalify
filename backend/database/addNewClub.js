const pool = require('../db');

const API_KEY = '63cadfcbd6814c179f045d79c51c96fa';

fetch(`https://api.football-data.org/v4/competitions/2019/teams`, {
  headers: { 'X-Auth-Token': API_KEY }
})
  .then(res => res.json())
  .then(data => {
    console.log(data);
    teams = data.teams;
    teams.forEach(team => {
        const filteredTeam = {
            name: team.shortName,
            country: team.area.name,
            logo_url: team.crest,
            api_id: team.id
        }
            insertTeam(filteredTeam);
        });
  })
  .catch(err => console.error(err));


async function insertTeam(team) {
    const {
    name,
    country,
    logo_url,
    api_id
  } = team;

  const query = `
    INSERT INTO teams (name, logo_url, country, api_id)
    VALUES ($1, $2, $3, $4)
    ON CONFLICT (id) DO UPDATE SET
      name = EXCLUDED.name,
      logo_url = EXCLUDED.logo_url,
      country = EXCLUDED.country,
      api_id = EXCLUDED.api_id
  `;

  const values = [name, logo_url, country, api_id];
    try {
        await pool.query(query, values);
        console.log(`Team ${name} inserted/updated successfully.`);
    } catch (error) {
        console.error('Error inserting team:', error);
    }
}

