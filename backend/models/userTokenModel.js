const mongoose = require('mongoose');

const Schema = mongoose.Schema;
const userTokenSchema = new Schema({
    _id: { type: Schema.Types.ObjectId, required: true },
    token: { type: String, required: true },
    createdAt: { type: Date, default: Date.now, expires: 365 * 86400 }, // 1 year
});


const UserToken = mongoose.model("UserToken", userTokenSchema);

module.exports =  UserToken;
