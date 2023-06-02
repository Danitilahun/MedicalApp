const mongoose = require("mongoose");
const adminSchema = mongoose.Schema(
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
    roles: {
      type: String,
      enum: ["user", "doctor", "admin"],
      default: "admin",
    },
  },
  { timestamps: true }
);

module.exports = Admin = mongoose.model("Admin", adminSchema);
