const { Router } = require('express')
const response = require('../../network/response')
const Controller = require('./index')

const router = Router();

router.post('/login', login)

function login (req, res, next) {
    if(req.body) {
        const { username, password } = req.body
        Controller.login(username, password)
            .then(token => {
                response.success(req, res, token, 200);
            })
            .catch(next);
    }
}



module.exports = router