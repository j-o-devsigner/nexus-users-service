const express = require('express')
const morgan = require('morgan')
const cors = require('cors')
const errors = require('../network/errors')
const router = require('./components/users/router')
const routerAuth = require('./components/auth/router')
const config = require('../config')

const PORT = config.users_port || 3001
const app = express();

app.use(express.json());
app.use(cors());

app.use('/users', router);
app.use('/', routerAuth);

app.use(morgan("dev"));
app.use(errors);

app.listen(PORT, () => {
    console.log('users in', PORT);
});