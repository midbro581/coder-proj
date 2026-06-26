# Coder — Corporate Training Company Profile

**CSIT128 Assignment 2: Web Technology Mini-Project**

Built by three Computer Science students at the University of Wollongong in Dubai (UOWD):

* Ahmed Almarouf — Co-Founder
* Ted Lokolo — Co-Founder
* Midhlaj Abubacker — Co-Founder

## Overview

Coder is a dynamic, 5-page enterprise web application serving as a corporate profile.

### Key Technical Features

* **Automated MySQL Database:** Run `node create_db.js` to automatically build the database, tables, and seed data.
  * **JSON Fetching:** loads the course catalog.
  * **XML + XSLT:** Uses the native browser `XSLTProcessor` to transform and display company awards.

## Quick Start Guide

1. Install dependencies: `npm install` and`npm install mysql`
2. update your sql username and pass inside `create_db.js`.
3. Build the database: run `node create_db.js`
4. Run the server: run `node server/server.js`
5. Open browser: <http://localhost:3000>
