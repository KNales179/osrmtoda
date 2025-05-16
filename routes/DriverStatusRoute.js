const express = require('express');
const router = express.Router();
const DriverStatus = require('../models/DriverStatus');

// POST /api/driver-status
router.post('/driver-status', async (req, res) => {
  try {
    const { driverId, isOnline, location } = req.body;

    const status = await DriverStatus.findOneAndUpdate(
      { driverId },
      { isOnline, location, updatedAt: new Date() },
      { upsert: true, new: true }
    );

    console.log('✅ Driver status updated:', status);
    res.status(200).json({ message: 'Status updated', status });
    console.log("👤 Matched driver name:", nearestDriver.driverName);
  } catch (err) {
    console.error('❌ Error updating driver status:', err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
