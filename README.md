# Coder — Corporate Training Company Profile

**CSIT128 Assignment 2: Web Technology Mini-Project**

Built by three Computer Science students at the University of Wollongong in Dubai (UOWD):

* Ahmed Almarouf — Co-Founder
* Ted Lokolo — Co-Founder
* Midhlaj Abubacker — Co-Founder

## Overview

Coder is a dynamic, 5-page enterprise web application serving as a corporate profile.

### Key Technical Features

* **Automated MySQL Database:** Run `node create_table.js` and `node insert_data.js` to build the database, tables, and seed data.
  * **JSON Fetching:** loads the course catalog via native API endpoints.
  * **XML + XSLT:** Uses the native browser `XSLTProcessor` to transform and display company awards.

## Quick Start Guide

1. Install dependencies: run `npm install` (this will install `mysql` and `mysql2`).
2. Update your SQL username and password inside `create_table.js`, `insert_data.js`, and `server/db.js`.
3. Build the database schemas: run `node create_table.js`
4. Seed the database records: run `node insert_data.js`
5. Run the server: run `node server/server.js`
6. Open browser: `<http://localhost:8080>` (or access it from your phone via your computer's local IP on port 8080).
