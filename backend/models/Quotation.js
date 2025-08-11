const mongoose = require('mongoose');

const { Schema } = mongoose;

const selectedAddOnSchema = new Schema(
  {
    id: String,
    name: String,
    price: { type: Number, min: 0 },
  },
  { _id: false }
);

const productSnapshotSchema = new Schema(
  {
    name: String,
    pricePerHour: Number,
    pricePerDay: Number,
    pricePerWeek: Number,
  },
  { _id: false }
);

const quotationItemSchema = new Schema(
  {
    productId: { type: Schema.Types.ObjectId, ref: 'Product', required: true },
    productSnapshot: { type: productSnapshotSchema, default: {} },
    quantity: { type: Number, required: true, min: 1 },
    duration: { type: Number, required: true, min: 1 },
    durationType: { type: String, enum: ['hour', 'day', 'week'], required: true },
    selectedAddOns: { type: [selectedAddOnSchema], default: [] },
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
    unitBasePrice: { type: Number, required: true, min: 0 },
    addOnTotal: { type: Number, required: true, min: 0 },
    lineTotal: { type: Number, required: true, min: 0 },
  },
  { _id: false }
);

const quotationSchema = new Schema(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    items: { type: [quotationItemSchema], validate: (v) => Array.isArray(v) && v.length > 0 },
    subtotal: { type: Number, required: true, min: 0 },
    serviceFee: { type: Number, required: true, min: 0 },
    tax: { type: Number, required: true, min: 0 },
    total: { type: Number, required: true, min: 0 },
    status: { type: String, enum: ['pending', 'accepted', 'rejected', 'expired'], default: 'pending', index: true },
    validUntil: { type: Date, required: true, index: true },
    convertedRentalId: { type: Schema.Types.ObjectId, ref: 'Rental' },
  },
  { timestamps: true }
);

quotationSchema.index({ createdAt: -1 });

module.exports = mongoose.model('Quotation', quotationSchema);


