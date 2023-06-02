const Doctor = require("../models/doctorModel");
const Patient = require("../models/patientModel");
const Admin = require("../models/adminModel");
const UserToken = require("../models/userTokenModel");
const bcrypt = require("bcrypt");
const createError = require("http-errors");
const {
  signAccessToken,
  signRefreshToken,
} = require("../strategies/jwtStrategy");

async function hasher(req, res) {
  const password = req.body.password;
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(password, salt);
  req.body.password = hashedPassword;
  console.log(req.body.password);
}

async function tokenGenerator(req, res, user) {
  const accessToken = await signAccessToken(user._id, user.roles);
  const refreshToken = await signRefreshToken(user._id, user.roles);

  res.set("Authorization", `Bearer ${accessToken}`);
  res.set("x-refresh-token", refreshToken);
  const { password, ...others } = user._doc;
  console.log({ ...others, accessToken, refreshToken });
  res.send({ ...others, accessToken, refreshToken });
}

async function createNewUser(req, res, collection) {
  await hasher(req, res);

  const newUser = new collection(req.body);
  const savedUser = await newUser.save();
  tokenGenerator(req, res, savedUser);
}

module.exports = {
  signup: async (req, res) => {
    try {
      let newUser;
      if (req.body.roles == "user") {
        newUser = await Patient.findOne({ email: req.body.email });
      } else if (req.body.roles == "doctor") {
        newUser = await Doctor.findOne({ email: req.body.email });
      } else if (req.body.roles == "admin") {
        newUser = await Admin.findOne({ email: req.body.email });
      }

      if (newUser) {
        return res
          .status(200)
          .send({ message: "User already exists", success: false });
      }
      // creating a user

      if (req.body.roles == "user") {
        createNewUser(req, res, Patient);
      } else if (req.body.roles == "doctor") {
        createNewUser(req, res, Doctor);
      } else if (req.body.roles == "admin") {
        createNewUser(req, res, Admin);
      }
    } catch (error) {
      console.log(error);
      res
        .status(500)
        .send({ message: "Error creating user", success: false, error });
    }
  },

  login: async (req, res) => {
    try {
      let user;

      user = await Patient.findOne({ email: req.body.email });
      if (!user) {
        user = await Doctor.findOne({ email: req.body.email });
        if (!user) {
          user = await Admin.findOne({ email: req.body.email });
        }
      }

      if (!user)
        return res.status(401).json({ error: true, message: "Invalid email" });

      const verifiedPassword = await bcrypt.compare(
        req.body.password,
        user.password
      );

      if (!verifiedPassword)
        return res
          .status(401)
          .json({ error: true, message: "Invalid password" });

      tokenGenerator(req, res, user);
    } catch (err) {
      console.log(err);
      res.status(500).json({ error: true, message: "Internal Server Error" });
    }
  },

  logout: async (req, res) => {
    try {
      const userToken = await UserToken.findOne({
        token: req.body.refreshToken,
      });
      if (!userToken)
        return res
          .status(200)
          .json({ error: false, message: "Logged Out Sucessfully" });

      const temp = await UserToken.deleteOne(userToken);
      return res.status(200).json({
        error: false,
        token: temp,
        message: "Logged out successfully",
      });
    } catch (err) {
      console.log(err);
      res.status(500).json({ error: true, message: "Internal Server Error" });
    }
  },

  refreshToken: async (req, res) => {
    try {
      const { userId, userRole } = req.payload;
      const accessToken = await signAccessToken(userId, userRole);

      res.json({
        success: true,
        message: "Refresh token verified successfully",
        accessToken,
      });
    } catch (error) {
      return next(createError.InternalServerError());
    }
  },

  authorize: (requiredRole) => {
    return (req, res, next) => {
      if (req.payload.userRole === requiredRole) {
        next();
      } else {
        return res.status(403).json({ error: "unauthorized" });
      }
    };
  },

  hasher,
};
