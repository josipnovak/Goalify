const { Pool } = require('pg');

const pool = new Pool({
  user: 'admin',
  host: 'dpg-d2mrjcnfte5s738noh5g-a',
  database: 'admin_pppq',
  password: 'xASQTpyelpnkWx2HXtnKfYcOaqLNDvAh',
  port: 5432,
});

module.exports = pool;