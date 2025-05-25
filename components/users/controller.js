
const TABLE = 'users';
const bcrypt = require('bcryptjs')

module.exports = function(injectedDB) {

    let database = injectedDB;

    const list = () => {
        return database.list(TABLE);
    };

    const findOne = (id) => {
        if(id) {
            return database.findOne(TABLE, id, "id");
        }
    }

    const create = (data) => {
        if(data) {
            return database.create(TABLE, data);
        }
    }

    const update = async (id, data) => {
        console.log(data)
        if(id && data) {

            const key = "id";
            const { username, password, oldUsername } = data
            if(username && password) {
                delete(data.password)
                delete(data.oldUsername)

                const hashedPassword = await bcrypt.hash(password, 10)

                database.update(TABLE, id, data, key)
                .then( () => {
                    return database.update("auth", username, {password: hashedPassword}, "username")
                })

            }
            else if(password) {
                const hashedPassword = await bcrypt.hash(password, 10)
                return database.update("auth", `'${oldUsername}'`, {password: hashedPassword}, "username");
            }
            delete(data.oldUsername)
            return database.update(TABLE, id, data, key)
        }
    }

    const remove = (id) => {
        const key = "id";
        return database.remove(TABLE, id, key)
    }

    return {
        list,
        findOne,
        create,
        update,
        remove,
    }
}
