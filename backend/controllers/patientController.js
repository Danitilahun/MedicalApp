const Patient = require("../models/patientModel");
const auth = require("./authController");
const path = require("path");
const fs = require("fs");
const Doctor = require("../models/doctorModel");

module.exports = {
  createProfile: async (req, res, userId) => {
    try {
      const patient = new Patient({
        name: req.body.name,
        email: req.body.email,
        password: req.body.password,
        roles: req.body.roles,
      });

      if (req.file) {
        patient.profileImage = req.file.path;
      }

      const result = await patient.save();
    } catch (error) {
      res.status(500).json({ message: "Internal server error" });
    }
  },

  getProfile: async (req, res) => {
    try {
      const patient = await Patient.findById(req.params.id);

      if (!patient) {
        return res.status(404).send();
      }

      res.send(patient);
    } catch (error) {
      res.status(500).send(error);
    }
  },

  updateProfile: async (req, res) => {
    try {
      const patientId = req.params.id;
      if (req.body.password) {
        await auth.hasher(req, res);
      }

      const updateFields = req.body;
      const updatedPatient = await Patient.findByIdAndUpdate(
        patientId,
        updateFields,
        { new: true, runValidators: true }
      );

      if (!updatedPatient) {
        return res.status(404).send();
      }
      res.send(updatedPatient);
    } catch (error) {
      res.status(400).send(error);
    }
  },

  updateProfileImage: async (req, res) => {
    try {
      const patientId = req.params.id;
      const patient = await Patient.findById(patientId);
      if (req.file) {
        const path = req.file.path;
        const parts = path.split("\\");
        const lastPart = parts[parts.length - 1];
        patient.profileImage = lastPart;
      }
      await patient.save();
      res.send(patient);
    } catch (error) {
      res.status(400).send(error);
    }
  },

  deleteProfileImage: async (req, res) => {
    try {
      const patient = await Patient.findById(req.params.id);
      if (!patient) {
        return res.status(404).send("Patient not found");
      }

      const imagePath = path.join(
        __dirname,
        "public",
        "images",
        patient.profileImage
      );
      patient.profileImage = undefined;

      if (fs.existsSync(imagePath)) {
        console.log(true);
        fs.unlinkSync(imagePath);
      }

      await patient.save();
      res.send(patient);
    } catch (error) {
      res.status(400).send(error.message);
    }
  },

  deleteAccount: async (req, res) => {
    console.log("asfksndvksvn");
    console.log(req.params);
    try {
      const account = await Patient.findByIdAndDelete(req.params.userId);
      if (!account) {
        return res.status(404).send("Account not found");
      }

      await Appointment.updateMany(
        { patient: account._id },
        { $unset: { patient: 1 } }
      );
      res
        .status(204)
        .send({ message: "Account deleted successfully", account: account });
    } catch (error) {
      res.status(500).send(error.message);
    }
  },

  searchDoctor: async (req, res) => {
    try {
      const { name } = req.query;

      // Create a regular expression pattern to match the given name partially
      const regex = new RegExp(name, "i");

      // Search for doctors whose name partially matches the given name and have certificateStatus approved
      const doctors = await Doctor.find({
        name: { $regex: regex },
        certificateStatus: "approved",
      });

      if (doctors.length === 0) {
        return res.status(404).json({ error: "Doctor not found" });
      }

      res.status(200).json(doctors);
    } catch (error) {
      res.status(500).json({ error: "Failed to search for doctor" });
    }
  },

  approvedDoctors: async (req, res) => {
    console.log("I am here to get approved doctors");
    try {
      const pendingDoctors = await Doctor.find(
        { certificateStatus: "approved" },
        { updatedAt: 0, createdAt: 0, password: 0, __v: 0 }
      );
      res.send(pendingDoctors);
    } catch (error) {
      res.status(500).send(error.message);
    }
  },

  getDoctor: async (req, res) => {
    try {
      const doctor = await Doctor.findById(req.params.id);
      if (!doctor) {
        return res.status(404).send("Doctor not found");
      }
      res.send(doctor);
    } catch (error) {
      res.status(500).send(error.message);
    }
  },
};
