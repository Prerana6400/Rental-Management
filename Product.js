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
    category: { type: String, required: true, trim: true }, // Changed from categoryId to category string
    description: { type: String, required: true, trim: true },
    image: { type: String, default: '' }, // Changed from images array to single image
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
    // Additional fields for better product management
    createdBy: { type: Schema.Types.ObjectId, ref: 'User' },
    updatedBy: { type: Schema.Types.ObjectId, ref: 'User' },
  },
  { timestamps: true }
);

productSchema.index({ name: 'text', description: 'text' });
productSchema.index({ category: 1 });
productSchema.index({ isActive: 1 });
productSchema.index({ availability: 1 });

module.exports = mongoose.model('Product', productSchema);


