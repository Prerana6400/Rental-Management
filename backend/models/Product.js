const mongoose = require('mongoose');

const { Schema } = mongoose;

const addOnSchema = new Schema(
  {
    id: { type: String, required: true },
    name: { type: String, required: true },
    price: { type: Number, required: true, min: 0 },
  },
  { _id: false }
);

const productSchema = new Schema(
  {
    name: { type: String, required: true, trim: true },
    categoryId: { type: Schema.Types.ObjectId, ref: 'Category', required: true, index: true },
    description: { type: String, default: '' },
    images: { type: [String], default: [] },
    pricePerHour: { type: Number, default: 0, min: 0 },
    pricePerDay: { type: Number, default: 0, min: 0 },
    pricePerWeek: { type: Number, default: 0, min: 0 },
    features: { type: [String], default: [] },
    addOns: { type: [addOnSchema], default: [] },
    availability: { type: String, enum: ['available', 'booked'], default: 'available' },
    isActive: { type: Boolean, default: true },
    location: {
      lat: Number,
      lng: Number,
      address: String,
    },
  },
  { timestamps: true }
);

productSchema.index({ name: 'text', description: 'text' });
productSchema.index({ isActive: 1 });
productSchema.index({ availability: 1 });

module.exports = mongoose.model('Product', productSchema);


