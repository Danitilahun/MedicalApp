// ratingModel.js
const mongoose = require("mongoose");

const ratingSchema = new mongoose.Schema({
  doctorId: {
    type: String,
    required: true,
  },
  
  userId: { type: String, required: true },
  rating: { type: Number, min: 1, max: 5, required: true },
  message: { type: String, max: 500 },
});


const Rating = mongoose.model("Rating", ratingSchema);

module.exports = Rating;
