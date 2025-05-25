const { Router } = require('express')
const Controller = require('./index')
const response = require('../../../network/response')
const ControllerAuth = require('../auth/index')
const bcrypt = require('bcryptjs')
const checkAuth = require('./secure')

const router = Router();

router.get('/', list);
router.get('/:id', findOne);
router.post('/register', create);
router.put('/:id', update);
router.put('/account/:id', checkAuth('update'), update)
router.delete('/:id', remove)

function list (req, res, next) {
    Controller.list()
    .then((list) => {
        response.success(req, res, list, 200);
    })
    .catch(next);
}

function findOne (req, res, next) {
    if(req.params.id) {
        Controller.findOne(req.params.id)
        .then((find) => {
            response.success(req, res, find, 200);
        })
        .catch(next);
    }
}

async function create (req, res, next) {
    if(req.body) {
        const { name, username, roleid, password } = req.body
        const dataUser = { name, username, roleid }

        const hashedPassword = await bcrypt.hash(password, 10)
            const dataAuth = {
                username: username,
                password: hashedPassword,
            }

        Controller.create(dataUser)
        .then((create) => {
            response.success(req, res, create, 200);
            return ControllerAuth.create(dataAuth)
        })
        .catch(next);
    }
}

function update (req, res, next) {
    if(req.params.id && req.body ) {
        Controller.update(req.params.id, req.body)
        .then((update) => {
            response.success(req, res, update, 200);
        })
        .catch(next);
    }
}

function remove (req, res, next) {
    const { id } = req.params
    if(id) {
        Controller.remove(id)
        .then((remove) => {
            response.success(req, res, remove, 200);
        })
        .catch(next);
    }
}

module.exports = router;