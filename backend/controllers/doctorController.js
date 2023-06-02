const Doctor = require("../models/doctorModel");
const auth = require("./authController");

module.exports = {
  createProfile: async (req, res, userId) => {
    try {
      const doctor = new Doctor({
        username: req.body.username,
        email: req.body.email,
        password: req.body.password,
        roles: req.body.roles,
      });

      if (req.file) {
        print(req.file.path);
        doctor.profileImage = req.file.path;
      }

      const result = await doctor.save();
    } catch (error) {
      res.status(500).json({ message: "Internal server error" });
    }
  },

  getProfile: async (req, res) => {
    try {
      const doctor = await Doctor.findById(req.params.id);

      if (!doctor) {
        return res.status(404).send();
      }

      res.status(200).send(doctor);
    } catch (error) {
      res.status(500).send(error);
    }
  },

  updateProfile: async (req, res) => {
    try {
      const DoctorId = req.params.id;
      if (req.body.password) {
        await auth.hasher(req, res);
      }

      const updateFields = req.body;
      const updatedDoctor = await Doctor.findByIdAndUpdate(
        DoctorId,
        updateFields,
        { new: true, runValidators: true }
      );

      if (!updatedDoctor) {
        return res.status(404).send();
      }

      res.send(updatedDoctor);
    } catch (error) {
      res.status(400).send(error);
    }
  },

  updateProfileImage: async (req, res) => {
    try {
      const doctor = await Doctor.findById(req.params.id);

      if (req.file) {
        const path = req.file.path;
        const parts = path.split("\\");
        const lastPart = parts[parts.length - 1];
        doctor.profileImage = lastPart;
      }
      await doctor.save();
      res.send(doctor);
    } catch (error) {
      res.status(400).send(error);
    }
  },

  deleteProfileFields: async (req, res) => {
    try {
      const doctor = await Doctor.findById(req.params.id);
      if (!doctor) {
        return res.status(404).send("Doctor not found");
      }

      const updateFields = {};
      for (let field of Object.keys(req.body)) {
        if (field in doctor) {
          updateFields[field] = null;
        }
      }
      console.log(updateFields);

      const updatedDoctor = await Doctor.findByIdAndUpdate(
        req.params.id,
        { $unset: updateFields },
        { new: true, runValidators: true }
      );

      res.send(updatedDoctor);
    } catch (error) {
      res.status(400).send(error.message);
    }
  },

  deleteProfileImage: async (req, res) => {
    try {
      const doctor = await Doctor.findById(req.params.id);
      if (!doctor) {
        return res.status(404).send("Doctor not found");
      }

      doctor.profileImage = undefined;

      await doctor.save();
      res.send(doctor);
    } catch (error) {
      res.status(400).send(error.message);
    }
  },

  deleteAccount: async (req, res) => {
    try {
      const account = await Doctor.findByIdAndDelete(req.params.id);
      if (!account) {
        return res.status(404).send("Account not found");
      }

      await Appointment.updateMany(
        { doctor: account._id },
        { $unset: { doctor: 1 } }
      );
      res.send({ message: "Account deleted successfully", account: account });
    } catch (error) {
      res.status(500).send(error.message);
    }
  },

  uploadCertificate: async (req, res) => {
    try {
      const doctor = await Doctor.findById(req.params.id);

      if (req.file) {
        const path = req.file.path;
        const parts = path.split("\\");
        const lastPart = parts[parts.length - 1];
        doctor.certificate = lastPart;
      }
      doctor.certificateStatus = "pending";

      await doctor.save();
      res.send(doctor);
    } catch (error) {
      res.status(400).send(error);
    }
  },

  deleteCertificate: async (req, res) => {
    try {
      const doctor = await Doctor.findById(req.params.id);
      if (!doctor) {
        return res.status(404).send("Doctor not found");
      }

      doctor.certificate = undefined;

      await doctor.save();
      res.send(doctor);
    } catch (error) {
      res.status(400).send(error.message);
    }
  },
};
