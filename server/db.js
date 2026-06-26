/*
 * CODER — server/db.js
 * Creates and exports a connection pool for the backend.
 */

const mysql = require('mysql2');

const pool = mysql.createPool({
  host:             'localhost',
  port:             3306,
  user:             'root',
  password:         '',
  database:         'coder_db',
  waitForConnections: true,
  connectionLimit:  10,
  queueLimit:       0
});

module.exports = pool.promise();
