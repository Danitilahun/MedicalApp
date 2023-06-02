const express = require("express");
const router = express.Router();
const admin = require("../controllers/adminController");
const { authorize } = require("../controllers/authController");
const { verifyAccessToken } = require("../strategies/jwtStrategy");
const medicationController = require("../controllers/medicationController");
const multer = require("multer");
const path = require("path");


// Medication Image
const medicationStorage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "public/medications");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const medicationsUpload = multer({ storage: medicationStorage });

// Admin profile
router.get(
  "/profile/:id",
  verifyAccessToken,
  authorize("admin"),
  admin.getProfile
);
// Updates patient profile including USERNAME and PASSWORD here
router.put(
  "/profile/:id",
  verifyAccessToken,
  authorize("admin"),
  admin.updateProfile
);
// Delete account
router.delete(
  "/deleteAccount",
  verifyAccessToken,
  authorize("admin"),
  admin.deleteAccount
);


// Roles
router.put(
  "/users/:userId/roles",
  verifyAccessToken,
  authorize("admin"),
  admin.updateRole
);
router.delete(
  "/users/:userId/roles",
  verifyAccessToken,
  authorize("admin"),
  admin.deleteRole
);

// Patients
router.get(
  "/getAllPatients",
  verifyAccessToken,
  authorize("admin"),
  admin.getAllPatients
);
router.get(
  "/getAllDoctors",
  verifyAccessToken,
  authorize("admin"),
  admin.getAllDoctors
);
router.get(
  "/patient:id",
  verifyAccessToken,
  authorize("admin"),
  admin.getPatient
);
router.delete(
  "/patient:id",
  verifyAccessToken,
  authorize("admin"),
  admin.deletePatient
);

// Doctors
router.get(
  "/doctor:id",
  verifyAccessToken,
  authorize("admin"),
  admin.getDoctor
);
router.get(
  "/pendingDoctors",
  verifyAccessToken,
  authorize("admin"),
  admin.pendingDoctors
);
router.get(
  "/approvedDoctors",
  verifyAccessToken,
  authorize("admin"),
  admin.approvedDoctors
);
router.patch(
  "/doctorStatus:id",
  verifyAccessToken,
  authorize("admin"),
  admin.doctorStatus
);
router.delete(
  "/doctor:id",
  verifyAccessToken,
  authorize("admin"),
  admin.deleteDoctor
);

// Medications
router.get(
  "/medications:id",
  verifyAccessToken,
  authorize("admin"),
  medicationController.getMedication
);
router.get(
  "/medications",
  verifyAccessToken,
  authorize("admin"),
  medicationController.getAllMedications
);
router.post(
  "/medications:id",
  verifyAccessToken,
  authorize("admin"),
  medicationsUpload.single("image"),
  medicationController.addMedication
);
router.put(
  "/medications:id",
  verifyAccessToken,
  authorize("admin"),
  medicationController.updateMedication
);
router.put(
  "/medicationImage:id",
  verifyAccessToken,
  authorize("admin"),
  medicationsUpload.single("image"),
  medicationController.updateMedicationImage
);
router.delete(
  "/medications:id",
  verifyAccessToken,
  authorize("admin"),
  medicationController.deleteMedication
);
router.delete(
  "/medicationImage:id",
  verifyAccessToken,
  authorize("admin"),
  medicationController.deleteMedicationImage
);
router.get(
  "medications/search",
  verifyAccessToken,
  authorize("admin"),
  medicationController.getMedicationByName
);

module.exports = router;
