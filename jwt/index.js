const jwt = require('jsonwebtoken')
const config = require('../config')
const error = require('../utils/error')

const secret = config.jwt_secret;

const sign = (data) => {
    return jwt.sign(data, secret);
}

const verify = (token) => {
    try {
        return jwt.verify(token, secret);
    } catch (error) {
        throw new Error(error.message)
    }
}

const getToken = (auth) => {
    if(!auth) {
        throw new Error('No token...');
    }

    if(auth.indexOf('Bearer ') === -1) {
        throw new Error('Invalid format');
    }

    let token = auth.replace('Bearer ', '');

    return token;
}

const decodeHeader = (req) => {
    const authorization = req.headers.authorization || '';
    const token = getToken(authorization);
    const decoded = verify(token);

    req.user = decoded;
    return decoded;
}

const check = {
    own: function(req, owner) {
        const decoded = decodeHeader(req);

        if(decoded.id !== owner) {
            throw error('You can not edit', 401);
        }
    }
}

module.exports = {
    sign,
    check,
}
