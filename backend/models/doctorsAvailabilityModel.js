const mongoose = require("mongoose");

const availabilitySchema = new mongoose.Schema({
  doctorId: { type: String },
  
  availability: [
    {
      date: { type: Date, required: true },
      time: { type: String, required: true },
    },
  ],
  // Other fields if needed
});

module.exports = mongoose.model("Availability", availabilitySchema);
