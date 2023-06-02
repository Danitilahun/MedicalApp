const express = require("express");
const router = express.Router();
const {signup, login, logout, refreshToken} = require("../controllers/authController")
const { verifyRefreshToken} = require("../strategies/jwtStrategy")

router.post("/signup",  signup);
router.post("/login", login);
router.delete("/logout", logout)

//        Note!!!
// Changing username/password and Deleting an account is implemented 
// in each specific user's route(patient, doctor and admin)
// We handle each type of user in different collection for performance(retrival)
// Deleting an account is done after authorization

router.post("/refreshToken", verifyRefreshToken, refreshToken)

module.exports = router
