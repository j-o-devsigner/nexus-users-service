const TABLE = "auth"
const bcrypt = require('bcryptjs')
const auth = require('../../jwt/index')

module.exports = function(injectedDb) {

    let database = injectedDb

    const login = async (username, password) => {
        const data = await database.findOne(TABLE, username, "username");
        console.log(data)
        if (data.length === 0) {
            return { message: "Wrong username or password" }
        }

        const hashedPassword = data[0].password;
        return await bcrypt.compare(password, hashedPassword)
            .then(async (areEquals) => {
            if (areEquals === true) {
                const dataUser = await database.findOne("users", username, "username")
                if(!dataUser[0].active) {
                    return { message: "This account is disabled" }
                }
                const setData = {
                    ...data[0],
                    id: dataUser[0].id
                }
                const token =  auth.sign(setData);
                return {
                    id: dataUser[0].id,
                    username: data[0].username,
                    name: dataUser[0].name,
                    role: dataUser[0].roleid,
                    token
                }
            } else {
                return { message: "Wrong username or password", status: 401 }
            }
        });
    };

    const create = (data) => {
            return database.create(TABLE, data);
    }


    return {
        login,
        create
    }
}