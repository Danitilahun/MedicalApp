const Patient = require('../models/patientModel');
const Doctor = require('../models/doctorModel');
const Admin = require('../models/adminModel');
const fs = require('fs');

module.exports = {

  getProfile: async (req, res) => {
    try {
      const admin = await Admin.findById(req.params.id);
      
      if (!admin) {
        return res.status(404).send();
      }
        res.send(admin);

    } catch (error) {
        res.status(500).send(error);
    }
  },

  updateProfile: async (req, res) => {
    try {
      const adminId = req.params.id;
      if (req.body.password){
         await auth.hasher(req, res)    
      }

      const updateFields = req.body;
      const updatedAdmin = await Admin.findByIdAndUpdate( adminId, updateFields,
        { new: true, runValidators: true }
      );
  
      if (!updatedAdmin) {
        return res.status(404).send();
      }
      res.send(updatedAdmin);

    } catch (error) {
      res.status(400).send(error);
    }
  },

  deleteAccount : async (req, res) => {
    try {
      const account = await Admin.findByIdAndDelete(req.params.id);
      if (!account) {
        return res.status(404).send('Account not found');
      }
     
      res.send({message: "Account deleted successfully",account: account});

    } catch (error) {
      res.status(500).send(error.message);
    }
  },

  updateRole: async (req, res) => {
    const userId = req.params.userId;
    const roles = req.body.roles; 
  
    Doctor.findByIdAndUpdate(userId, { roles }, { new: true })
      .then((user) => {
        res.json(user);
      })
      .catch((error) => {
        res.status(500).json({ error: 'Failed to update user roles' });
      });
  },

  deleteRole: async  (req, res) => {
    const userId = req.params.userId;
    const roles = req.body.roles; 
  
    Doctor.findByIdAndUpdate(userId, { $pull: { roles: { $in: roles } } }, { new: true })
      .then((user) => {
        res.json(user);
      })
      .catch((error) => {
        res.status(500).json({ error: 'Failed to revoke user roles' });
      });
  },

    getAllPatients:  async (req, res) => {
        try {
          const patients = await Patient.find();
          res.send(patients);

        } catch (error) {
          res.status(500).send(error);
        }
      },

      getAllDoctors:  async (req, res) => {
        try {
          const doctor = await Doctor.find();
          res.send(doctor);

        } catch (error) {
          res.status(500).send(error);
        }
      },

      getPatient : async (req, res) => {
        try {
          const patient = await Patient.findById(req.params.id);
          if (!patient) {
            return res.status(404).send('Patient not found');
          }
          res.send(patient);
        } catch (error) {
          res.status(500).send(error.message);
        }
    },
      

      getDoctor : async (req, res) => {
        try {
          const doctor = await Doctor.findById(req.params.id);
          if (!doctor) {
            return res.status(404).send('Doctor not found');
          }
          res.send(doctor);
        } catch (error) {
          res.status(500).send(error.message);
        }
    },

    pendingDoctors: async (req, res) => {

        try {
          const pendingDoctors = await Doctor.find({ certificateStatus: 'pending' });
          res.send(pendingDoctors);
        } catch (error) {
          res.status(500).send(error.message);
        }
      },

    approvedDoctors: async (req, res) => {

        try {
          const pendingDoctors = await Doctor.find({ certificateStatus: 'approved' });
          res.send(pendingDoctors);
        } catch (error) {
          res.status(500).send(error.message);
        }
      },

    doctorStatus:  async (req, res) => {
        try {
          const doctor = await Doctor.findByIdAndUpdate( req.params.id,
            { certificateStatus: req.body.certificateStatus },
            { new: true }
          );

          if (!doctor) {
            return res.status(404).send('Doctor not found');
          }

          res.send(doctor);

        } catch (error) {
          res.status(400).send(error.message);
        }
      },

    deletePatient : async (req, res) => {

        try {
          const deletedPatient = await Patient.findByIdAndDelete(req.params.id);
          if (!deletedPatient) {
            return res.status(404).send('Patient not found');
          }
          if (deletedPatient.profileImage) {
            fs.unlinkSync(deletedPatient.profileImage);
          }

          await Appointment.updateMany(
            { patient: deletedPatient._id },
            { $unset: { patient: 1 } }
          );
          res.send(deletedPatient);

        } catch (error) {
          res.status(500).send(error.message);
        }
      },

      deleteDoctor: async (req, res) => {
        try {
          const deletedDoctor = await Doctor.findByIdAndDelete(req.params.id);
          if (!deletedDoctor) {
            return res.status(404).send('Doctor not found');
          }
          if (deletedDoctor.profileImage) {
            fs.unlinkSync(deletedDoctor.profileImage);
          }
          
          res.send(deletedDoctor);

        } catch (error) {
          res.status(500).send(error.message);
        }
      },

}
