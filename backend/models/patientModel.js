const mongoose = require("mongoose");
const patientSchema = mongoose.Schema(
  {
    username: {
      type: String,
      required: true,
      max: 50,
    },
    location: {
      type: String,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      min: 5,
      max: 35,
      validate: {
        validator: (value) => {
          const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          return emailRegex.test(value);
        },
        message: "Invalid email format",
      },
    },
    password: {
      type: String,
      required: true,
      min: 4,
      max: 1028,
    },
    profileImage: {
      type: String,
    },

    roles: {
      type: String,
      enum: ["user", "doctor", "admin"],
      default: "user",
    },
  },
  { timestamps: true }
);

module.exports = Patient = mongoose.model("Patient", patientSchema);
