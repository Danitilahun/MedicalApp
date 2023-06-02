require('dotenv').config();
const mongoose = require('mongoose');

mongoose.connect(process.env.DB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
        }
    )
    .then(() =>{console.log("connected to monogodb")})
    .catch((err) => {
        console.log(err.message)
    })

    mongoose.connection.on("connected", () => {
        console.log('Mongoose connected to db')
      })
      
      mongoose.connection.on('error', (err) => {
        console.log(err.message)
      })
      
      mongoose.connection.on('disconnected', () => {
        console.log('Mongoose connection is disconnected.')
      })