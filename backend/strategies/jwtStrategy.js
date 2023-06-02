const jwt = require("jsonwebtoken");
const createError = require('http-errors');
const UserToken = require("../models/userTokenModel")

// Generate access token
const signAccessToken = (userId, userRole) => {
  return new Promise((resolve, reject) => {
    const payload = { userId, userRole };
    const options = {
      expiresIn: "1h",
      issuer: "tenaye.com",
      audience: userId.toString(),
    };

    jwt.sign(payload, process.env.JWT_SECRET_ACCESS, options, (err, token) => {
      if (err) {
        console.log(err);
        return reject(createError.InternalServerError());
      }
      resolve(token);
    });
  });
};

// Generate refresh token
const signRefreshToken = (userId, userRole) => {
  return new Promise((resolve, reject) => {
    const payload = { userId, userRole };
    const options = {
      expiresIn: "1y",
      issuer: "aau.com",
      audience: userId.toString(),
    };

    jwt.sign(payload, process.env.JWT_SECRET_REFRESH, options,  async (err, token) => {
      if (err) {
        console.log(err);
        return reject(createError.InternalServerError());
      }
        const userToken = await UserToken.findOne({ userId: userId });
     
        if (userToken){ 
          await UserToken.deleteOne(userToken);
        }

        await new UserToken({ _id: userId, token: token }).save();
        resolve(token);
     

    });
  });
};

// Middleware for verifying access token
const verifyAccessToken = (req, res, next) => {

  if (!req.headers.authorization) {
    return next(createError.Unauthorized());
  }

  const token = req.headers.authorization.split(" ")[1];
  jwt.verify(token, process.env.JWT_SECRET_ACCESS, (err, payload) => {
    if (err) {
      const message = err.name === "JsonWebTokenError" ? "Unauthorized" : err.message;
      return next(createError.Unauthorized(message));
    }
    req.payload = payload;
    next();
  });
};

// Middleware for verifying refresh token

const verifyRefreshToken = (req, res, next) => {
  const token = req.headers.authorization.split(" ")[1];

  if (!token) {
    return res.status(401).json({ error: 'Refresh token is missing' });
  }
  
  jwt.verify(token, process.env.JWT_SECRET_REFRESH, (err, payload) => {

    if (err) {
      if (err.name === 'TokenExpiredError') {
       
        return res.status(401).json({ error: 'Refresh token has expired' });
      } else {
        
        return res.status(401).json({ error: 'Invalid refresh token' });
      }
    }

    
    req.payload = payload
    next();
  });
};


module.exports = {
  signAccessToken,
  signRefreshToken,
  verifyAccessToken,
  verifyRefreshToken,
};



