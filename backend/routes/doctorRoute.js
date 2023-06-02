const express = require("express");
const router = express.Router();
const { authorize } = require("../controllers/authController");
const { verifyAccessToken } = require("../strategies/jwtStrategy");
const doctor = require("../controllers/doctorController");
const multer = require("multer");
const path = require("path");
const appointmentController = require("../controllers/appointmentController");
const ratingController = require("../controllers/ratingController");

// Profile images

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "public/images");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage: storage });

// Certificates
const certificateStorage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "public/certificates"); // specify the folder to store images
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname)); // rename the file with current timestamp
  },
});

const certificate = multer({ storage: certificateStorage });

// Profile
router.get(
  "/profile/:id",
  verifyAccessToken,
  authorize("doctor"),
  doctor.getProfile
);

// Updates patient profile including USERNAME and PASSWORD here
router.put(
  "/profile/:id",
  verifyAccessToken,
  authorize("doctor"),
  doctor.updateProfile
);
router.patch(
  "/profile/:id",
  verifyAccessToken,
  authorize("doctor"),
  doctor.deleteProfileFields
);
router.put(
  "/profileImage/:id",
  verifyAccessToken,
  authorize("doctor"),
  upload.single("profileImage"),
  doctor.updateProfileImage
);
router.delete(
  "/profileImage/:id",
  verifyAccessToken,
  authorize("doctor"),
  doctor.deleteProfileImage
);

// Delete account
router.delete(
  "/deleteAccount",
  verifyAccessToken,
  authorize("doctor"),
  doctor.deleteAccount
);

// Certificate
router.put(
  "/certificate/:id",
  verifyAccessToken,
  authorize("doctor"),
  certificate.single("certificate"),
  doctor.uploadCertificate
);
router.patch(
  "/certificate/:id",
  verifyAccessToken,
  authorize("doctor"),
  doctor.deleteCertificate
);

// Appointment
router.post(
  "/appointments",
  verifyAccessToken,
  authorize("doctor"),
  appointmentController.createAppointment
);
// router.get(
//   "/appointments/:appointmentId",
//   verifyAccessToken,
//   authorize("doctor"),
//   appointmentController.getAppointmentById
// );
router.get(
  "/appointments/:doctorId",
  verifyAccessToken,
  authorize("doctor"),
  appointmentController.getAppointmentsByDoctorId
);

router.delete(
  "/appointments/:appointmentId",
  verifyAccessToken,
  authorize("doctor"),
  appointmentController.deleteAppointment
);
router.put(
  "/appointments/:appointmentId",
  verifyAccessToken,
  authorize("doctor"),
  appointmentController.updateAppointment
);
router.patch(
  "/appointments/:appointmentId",
  verifyAccessToken,
  authorize("doctor"),
  appointmentController.appointmentStatus
);

// Date picking
router.get(
  "/availability/:doctorId",
  verifyAccessToken,
  authorize("doctor"),
  appointmentController.getAvailability
);
router.post(
  "/availability/:doctorId",
  verifyAccessToken,
  authorize("doctor"),
  appointmentController.createAvailability
);
router.patch(
  "/availability/:doctorId",
  verifyAccessToken,
  authorize("doctor"),
  appointmentController.updateAvailability
);
router.delete(
  "/doctor/:doctorId/availability/:date",
  verifyAccessToken,
  authorize("doctor"),
  appointmentController.deleteAvailability
);

// Ratings
router.get(
  "/ratings/:doctordId",
  verifyAccessToken,
  authorize("doctor"),
  ratingController.getRatingsByDoctorId
);

module.exports = router;
