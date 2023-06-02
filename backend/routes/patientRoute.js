const express = require("express");
const router = express.Router();
const { authorize } = require("../controllers/authController");
const { verifyAccessToken } = require("../strategies/jwtStrategy");
const patient = require("../controllers/patientController");
const multer = require("multer");
const path = require("path");
const appointmentController = require("../controllers/appointmentController");
const ratingController = require("../controllers/ratingController");
const medicationController = require("../controllers/medicationController");

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "public/images");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});


// Set up multer middleware for handling file uploads
const upload = multer({ storage: storage });

router.get(
  "/profile/:id",
  verifyAccessToken,
  authorize("user"),
  patient.getProfile
);
// Updates patient profile including USERNAME and PASSWORD here
router.put(
  "/profile/:id",
  verifyAccessToken,
  authorize("user"),
  patient.updateProfile
);

router.put(
  "/profileImage/:id",
  verifyAccessToken,
  authorize("user"),
  upload.single("profileImage"),
  patient.updateProfileImage
);
router.delete(
  "/profileImage/:id",
  verifyAccessToken,
  authorize("user"),
  patient.deleteProfileImage
);

// Delete account
router.delete(
  "/deleteAccount/:userId",
  verifyAccessToken,
  authorize("user"),
  patient.deleteAccount
);

// Appointment

router.post(
  "/appointments",
  verifyAccessToken,
  authorize("user"),
  appointmentController.createAppointment
);
// router.get("/appointments/:appointmentId", verifyAccessToken, authorize("user"), appointmentController.getAppointmentById);
router.get(
  "/appointments/:userId",
  verifyAccessToken,
  authorize("user"),
  appointmentController.getAppointmentsByUserId
);

router.delete(
  "/appointments/:appointmentId",
  verifyAccessToken,
  authorize("user"),
  appointmentController.deleteAppointment
);

router.patch(
  "/appointments/:appointmentId",
  verifyAccessToken,
  authorize("user"),
  appointmentController.updateAppointment
);

// Rating

router.post(
  "/ratings",
  verifyAccessToken,
  authorize("user"),
  ratingController.createRating
);
router.get(
  "/ratings/:doctordId",
  verifyAccessToken,
  authorize("user"),
  ratingController.getRatingsByDoctorId
);
router.get(
  "/ratings/:doctorId/user/:userId",
  verifyAccessToken,
  authorize("user"),
  ratingController.getRatingByUserId
);
router.delete(
  "/ratings/:ratingId",
  verifyAccessToken,
  authorize("user"),
  ratingController.deleteRating
);
router.patch(
  "/ratings/:ratingId",
  verifyAccessToken,
  authorize("user"),
  ratingController.updateRating
);

// Medications
router.get(
  "/medications:id",
  verifyAccessToken,
  authorize("user"),
  medicationController.getMedication
);
router.get(
  "/medications",
  verifyAccessToken,
  authorize("user"),
  medicationController.getAllMedications
);
router.get(
  "medications/search",
  verifyAccessToken,
  authorize("user"),
  medicationController.getMedicationByName
);

// get Doctors
router.get(
  "/doctors",
  verifyAccessToken,
  authorize("user"),
  patient.approvedDoctors
);
router.get(
  "/doctor:id",
  verifyAccessToken,
  authorize("user"),
  patient.getDoctor
);
router.get(
  "/searchDoctors",
  verifyAccessToken,
  authorize("user"),
  patient.searchDoctor
);

module.exports = router;
