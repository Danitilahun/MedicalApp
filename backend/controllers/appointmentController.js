const Appointment = require("../models/appointmentModel");
const Availability = require("../models/doctorsAvailabilityModel");

module.exports = {
  createAppointment: async (req, res) => {
    console.log(req.body);
    try {
      const { doctorId, userId, bookTime, bookDate } = req.body;
      const appointment = await Appointment.create({
        doctorId: req.body.doctorId,
        userId: req.body.userId,
        bookTime: req.body.time,
        bookDate: req.body.date,
        reply: req.body.reply,
        message: req.body.message,
        reason: req.body.reason,
      });

      res.status(201).json(appointment);
    } catch (error) {
      res.status(500).json({ error: "Failed to create appointment" });
    }
  },

  
  getAppointmentById: async (req, res) => {
    try {
      const { appointmentId } = req.params;
      const appointment = await Appointment.findById(appointmentId);

      if (!appointment) {
        return res.status(404).json({ error: "Appointment not found" });
      }

      res.status(200).json(appointment);
    } catch (error) {
      res.status(500).json({ error: "Failed to get appointment" });
    }
  },

  getAppointmentsByDoctorId: async (req, res) => {
    console.log("printing Appointments");
    try {
      console.log(req.params);
      const appointments = await Appointment.find({
        doctorId: req.params.doctorId,
      });

      if (appointments.length === 0) {
        return res
          .status(404)
          .json({ error: "No appointments found for the user" });
      }

      res.status(200).json(appointments);
    } catch (error) {
      res.status(500).json({ error: "Failed to get appointments" });
    }
  },

  getAppointmentsByUserId: async (req, res) => {
    console.log("printing Appointments user");
    try {
      console.log(req.params);
      const appointments = await Appointment.find({
        userId: req.params.userId,
      });

      if (appointments.length === 0) {
        return res
          .status(404)
          .json({ error: "No appointments found for the user" });
      }

      res.status(200).json(appointments);
    } catch (error) {
      res.status(500).json({ error: "Failed to get appointments" });
    }
  },

  updateAppointment: async (req, res) => {
    console.log(req.body);
    try {
      const { appointmentId } = req.params;
      const { reply, message, reason, time } = req.body;
      const appointment = await Appointment.findByIdAndUpdate(
        appointmentId,
        { reply, message, reason, bookTime: time },
        { new: true }
      );

      if (!appointment) {
        return res.status(404).json({ error: "Appointment not found" });
      }

      res.status(200).json(appointment);
    } catch (error) {
      res.status(500).json({ error: "Failed to update appointment" });
    }
  },

  deleteAppointment: async (req, res) => {
    try {
      const { appointmentId } = req.params;
      await Appointment.findByIdAndDelete(appointmentId);

      res.status(204).end();
    } catch (error) {
      res.status(500).json({ error: "Failed to delete appointment" });
    }
  },

  appointmentStatus: async (req, res) => {
    console.log("i am here");

    console.log(req.params);
    try {
      const appointment = await Appointment.findByIdAndUpdate(
        req.params.appointmentId,
        { reply: req.body.reply },
        { new: true }
      );

      if (!appointment) {
        return res.status(404).send("No appointment made");
      }

      res.status(200).send(appointment);
    } catch (error) {
      res.status(400).send(error.message);
    }
  },

  getAvailability: async (req, res) => {
    try {
      const { doctorId } = req.params;
      const availability = await Availability.find({ doctorId });
      res.status(200).json(availability);
    } catch (error) {
      res.status(500).json({ error: "Failed to get availability" });
    }
  },

  createAvailability: async (req, res) => {
    try {
      const { doctorId } = req.params;
      const { date, time } = req.body;

      const newAvailability = {
        date,
        time,
      };

      await Availability.updateOne(
        { doctorId },
        { $push: { availability: newAvailability } }
      );
      res.status(201).json({ message: "Availability created successfully" });
    } catch (error) {
      res.status(500).json({ error: "Failed to create availability" });
    }
  },

  updateAvailability: async (req, res) => {
    try {
      const { doctorId } = req.params;
      const { date, time } = req.body;

      const doctor = await Availability.findById(doctorId);
      if (!doctor) {
        return res.status(404).json({ error: "Doctor not found" });
      }

      const availability = doctor.availability.find(
        (avail) => avail.date === date
      );
      if (!availability) {
        return res.status(404).json({ error: "Availability not found" });
      }

      if (time) {
        availability.time = time;
      }

      await doctor.save();

      res.status(200).json({ message: "Availability updated successfully" });
    } catch (error) {
      res.status(500).json({ error: "Failed to update availability" });
    }
  },

  deleteAvailability: async (req, res) => {
    try {
      const { doctorId, date } = req.params;

      const doctor = await Availability.findById(doctorId);
      if (!doctor) {
        return res.status(404).json({ error: "Doctor not found" });
      }

      const availabilityIndex = doctor.availability.findIndex(
        (avail) => avail.date === date
      );
      if (availabilityIndex === -1) {
        return res.status(404).json({ error: "Availability not found" });
      }

      doctor.availability.splice(availabilityIndex, 1);
      await doctor.save();

      res.status(200).json({ message: "Availability deleted successfully" });
    } catch (error) {
      res.status(500).json({ error: "Failed to delete availability" });
    }
  },
};
