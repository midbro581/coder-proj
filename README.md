# Coder — Learn to Code Web Application
**CSIT128 Assignment 2 — Group Project**

## Setup Instructions

### 1. Install Node.js
Download from https://nodejs.org (LTS version)

### 2. Install MySQL
Download MySQL Community Server from https://dev.mysql.com/downloads/

### 3. Set up the Database
Open MySQL Workbench or MySQL CLI and run:
```sql
source C:/Users/ahmed/Desktop/Coder/database/schema.sql
```

### 4. Configure Environment
Edit `.env` in the project root and set your MySQL password:
```
DB_PASSWORD=your_actual_mysql_password
```

### 5. Install Dependencies
Open a terminal in the Coder folder:
```bash
npm install
```

### 6. Start the Server
```bash
npm start
```
Server runs at: http://localhost:3000

---

## Pages
| Page | URL |
|------|-----|
| Home | http://localhost:3000 |
| Login | http://localhost:3000/login |
| Register | http://localhost:3000/register |
| Courses | http://localhost:3000/courses |
| Compiler | http://localhost:3000/compiler |
| Team | http://localhost:3000/team |
| About | http://localhost:3000/about |
| Contact | http://localhost:3000/contact |

## Tech Stack
- **Frontend**: HTML5, CSS3, JavaScript (all external files)
- **Backend**: Node.js + Express
- **Database**: MySQL
- **Data**: JSON, XML + DTD
- **Security**: JWT auth, bcrypt, helmet, rate limiting, input sanitization
- **Compiler**: Piston API (free, no API key needed)
