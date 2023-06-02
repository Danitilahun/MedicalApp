const express = require("express");
const app = express();
require("dotenv").config();
const db = require("./config/db");
const bodyParser = require("body-parser");
const userRoute = require("./routes/userRoute");
const doctorRoute = require("./routes/doctorRoute");
const adminRoute = require("./routes/adminRoute");
const patientRoute = require("./routes/patientRoute");

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use(express.static("public/"));

app.use("/api/user", userRoute);
app.use("/api/patient", patientRoute);
app.use("/api/doctor", doctorRoute);
app.use("/api/admin", adminRoute);

app.get("/", (req, res) => {
  res.status(200).send("Working");
});
app.use((err, req, res, next) => {
  res.status(err.status || 500).json({
    error: {
      message: err.message || "Internal Server Error",
    },
  });
});

app.listen(process.env.PORT, console.log("listening on port 3000"));
