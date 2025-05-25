const auth = require('../../jwt')

const checkAuth = (action) => {

    const middleware = (req, next) => {
        switch(action) {
            case 'update':
                const owner = Number(req.params.id);
                auth.check.own(req, owner);
                next();
                break;

            default:
                next();
        }
    }

    return middleware;
}

module.exports = checkAuth;