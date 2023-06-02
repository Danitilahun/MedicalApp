const mongoose = require("mongoose");

const appointmentSchema = new mongoose.Schema({
  doctorId: {
    type: String,
    required: true,
  },
  userId: { type: String, required: true },
  bookTime: { type: String, required: true },
  reason: { type: String, default: "" },
  message: { type: String, default: "" },
  reply: { type: String, default: "" },
  bookDate: { type: String, required: true },
  
  progress: {
    type: String,
    enum: ["completed", "cancled", "waiting", "approved"],
  },
});

module.exports = mongoose.model("Appointment", appointmentSchema);
