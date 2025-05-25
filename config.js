const { config } = require('dotenv')

config();

module.exports = {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
    jwt_secret: process.env.SECRET,
    users_port: process.env.USERS_PORT,
};