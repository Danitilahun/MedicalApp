const mongoose = require('mongoose');

const medicationSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String },
  image: { type: String },
  duration: { type: String },
  prescription: { type: String },
  pharmacies: [{
    name: { type: String, required: true },
    address: {
      street: { type: String },
      city: { type: String },
      state: { type: String },
      zipCode: { type: String },
      country: { type: String },
    },
  }],
});

const Medication = mongoose.model('Medication', medicationSchema);


module.exports = {
  Medication
};
