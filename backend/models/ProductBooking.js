const mongoose = require('mongoose');

const { Schema } = mongoose;

const productBookingSchema = new Schema(
  {
    productId: { type: Schema.Types.ObjectId, ref: 'Product', required: true, index: true },
    rentalId: { type: Schema.Types.ObjectId, ref: 'Rental' },
    status: { type: String, enum: ['hold', 'confirmed', 'cancelled', 'returned'], default: 'hold', index: true },
    startDate: { type: Date, required: true, index: true },
    endDate: { type: Date, required: true, index: true },
    quantity: { type: Number, default: 1, min: 1 },
  },
  { timestamps: true }
);

productBookingSchema.index({ productId: 1, startDate: 1, endDate: 1 });

module.exports = mongoose.model('ProductBooking', productBookingSchema);


