const mongoose = require("mongoose");

const doctorSchema = new mongoose.Schema(
  {
    username: {
      type: String,
      required: true,
      max: 50,
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
    phoneNumber: {
      type: String,
    },
    city: {
      type: String,
      default: "",
    },
    country: {
      type: String,
      default: "",
    },
    specialization: {
      type: String,
      default: "",
    },
    experience: {
      type: String,
      default: "",
    },
    feePerConsultation: {
      type: Number,
      default: 0,
    },
    certificate: {
      type: String,
      default: "",
    },
    certificateStatus: {
      type: String,
      enum: ["pending", "approved", "rejected"],
      default: "pending",
    },
    numberOfPeopleRateThisDoctor: {
      type: Number,
      default: 0,
    },
    sumOfRating: {
      type: Number,
      default: 0,
    },
    rating: {
      type: Number,
      default: 0.0,
    },

    roles: {
      type: String,
      enum: ["user", "doctor", "admin"],
      default: "user",
    },
  },
  { timestamps: true }
);

module.exports = Doctor = mongoose.model("Doctor", doctorSchema);
