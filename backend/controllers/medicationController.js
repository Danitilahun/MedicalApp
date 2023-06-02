const { Medication } = require("../models/medicationModel");

module.exports = {
  // Medication

  getAllMedications: async (req, res) => {
    try {
      const medications = await Medication.find();
      res.status(200).json(medications);
    } catch (error) {
      res.status(500).json({ error: "Failed to get medications" });
    }
  },

  getMedication: async (req, res) => {
    try {
      const { id } = req.params;
      const medication = await Medication.findById(id);
      if (!medication) {
        return res.status(404).json({ error: "Medication not found" });
      }
      res.status(200).json(medication);
    } catch (error) {
      res.status(500).json({ error: "Failed to get medication" });
    }
  },

  addMedication: async (req, res) => {
    try {
      const name = req.body;

      let medication = await Medication.findOne({ name });

      if (!medication) {
        const image = req.file ? req.file.path : "";
        medication = new Medication({
          name: req.body.name,
          description: req.body.description,
          image: image,
          prescription: req.body.prescription,
          duration: req.body.duration,
          pharmacies: [req.body.pharmacy],
        });
      } else {
        medication.pharmacies.push(req.body.pharmacy);
      }

      await medication.save();
      res.status(201).json({ message: "Medication created successfully" });
    } catch (error) {
      res.status(500).json({ error: "Failed to create medication" });
    }
  },

  updateMedication: async (req, res) => {
    try {
      const { id } = req.params;
      const medication = await Medication.findById(id);

      if (!medication) {
        return res.status(404).json({ error: "Medication not found" });
      }
      const updateFields = req.body;
      const updatedMedication = await Medication.findByIdAndUpdate(
        id,
        updateFields,
        { new: true, runValidators: true }
      );

      if (!updatedMedication) {
        return res.status(404).json({ error: "Medication not found" });
      }
      res.status(200).json(updatedMedication);
    } catch (error) {
      res.status(500).json({ error: "Failed to update medication" });
    }
  },
  updateMedicationImage: async (req, res) => {
    try {
      const medication = await Medication.findById(req.params.id);

      if (req.file) {
        medication.image = req.file.path;
      }
      await medication.save();
      res.send(medication);
    } catch (error) {
      res.status(400).send(error);
    }
  },

  deleteMedicationImage: async (req, res) => {
    try {
      const medication = await Medication.findById(req.params.id);
      if (!medication) {
        return res.status(404).send("Medication not found");
      }

      medication.profileImage = undefined;
      await medication.save();
      res.send(medication);
    } catch (error) {
      res.status(400).send(error.message);
    }
  },

  deleteMedication: async (req, res) => {
    try {
      const { id } = req.params;
      const deletedMedication = await Medication.findByIdAndDelete(id);

      if (!deletedMedication) {
        return res.status(404).json({ error: "Medication not found" });
      }
    } catch (error) {
      return res.status(404).json({ error: "failed to delete medication" });
    }
  },

  getMedicationByName: async (req, res) => {
    try {
      const { name } = req.query;

      // Search for medications that partially match the given name
      const medications = await Medication.find({
        name: { $regex: name, $options: "i" },
      });

      if (medications.length === 0) {
        return res.status(404).json({ error: "Medication not found" });
      }

      // Get the pharmacies that have the searched medication
      const pharmacyIds = medications
        .map((medication) => medication.pharmacies)
        .flat();
      const pharmacies = await Pharmacy.find({ _id: { $in: pharmacyIds } });

      res.status(200).json({ medications, pharmacies });
    } catch (error) {
      res.status(500).json({ error: "Failed to search for medication" });
    }
  },
};
