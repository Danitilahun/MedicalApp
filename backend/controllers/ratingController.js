const Rating = require("../models/ratingModel");
const Appointment = require("../models/appointmentModel");
const Doctor = require("../models/doctorModel");
module.exports = {
  createRating: async (req, res) => {
    console.log(req.body);
    try {
      const { doctorId, userId, rating, message } = req.body;
      console.log(doctorId, userId, rating, message);
      const appointment = await Appointment.find({
        doctorId,
        userId,
      });
      console.log("APP", appointment);
      if (appointment.length === 0) {
        console.log("ERROR");
        return res.status(400).json({
          error:
            "You cannot rate a doctor you did not have an appointment with.",
        });
      }
      const newRating = new Rating({
        doctorId,
        userId,
        rating,
        message,
      });

      await newRating.save();

      const doctor = await Doctor.findById(doctorId);

      doctor.numberOfPeopleRateThisDoctor += 1;

      doctor.sumOfRating += rating;

      doctor.rating = doctor.sumOfRating / doctor.numberOfPeopleRateThisDoctor;

      await doctor.save();

      res.status(201).json({ message: "Rating created successfully" });
    } catch (error) {
      res.status(500).json({ error: "Failed to create rating" });
    }
  },

  getRatingsByDoctorId: async (req, res) => {
    console.log("doctor rating");
    try {
      console.log("id", req.params);
      const ratings = await Rating.find({ doctorId: req.params.doctordId });
      console.log(ratings);
      res.status(200).json(ratings);
    } catch (error) {
      res.status(500).json({ error: "Failed to get ratings" });
    }
  },

  getRatingByUserId: async (req, res) => {
    try {
      const { doctorId, userId } = req.params;
      const rating = await Rating.findOne({ doctorId, userId });

      if (!rating) {
        return res.status(404).json({ error: "Rating not found" });
      }

      res.status(200).json(rating);
    } catch (error) {
      res.status(500).json({ error: "Failed to get rating" });
    }
  },

  updateRating: async (req, res) => {
    try {
      const { ratingId } = req.params;
      const { rating, message } = req.body;
      console.log(ratingId, message, rating);
      const updatedRating = await Rating.findByIdAndUpdate(
        ratingId,
        { rating, message },
        { new: true }
      );
      if (!updatedRating) {
        return res.status(404).json({ error: "Rating not found" });
      }

      res.status(200).json(updatedRating);
    } catch (error) {
      res.status(500).json({ error: "Failed to update rating" });
    }
  },

  deleteRating: async (req, res) => {
    console.log("deleteRating");
    try {
      const { ratingId } = req.params;
      console.log(req.params);
      const deletedRating = await Rating.findByIdAndDelete({ _id: ratingId });
      if (!deletedRating) {
        return res.status(404).json({ error: "Rating not found" });
      }
      console.log("success");
      res.status(200).json({ message: "Rating deleted successfully" });
    } catch (error) {
      res.status(500).json({ error: "Failed to delete rating" });
    }
  },
};
