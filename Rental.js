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

const rentalItemSchema = new Schema(
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

const rentalSchema = new Schema(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    items: { type: [rentalItemSchema], validate: (v) => Array.isArray(v) && v.length > 0 },
    paymentMode: { type: String, enum: ['full', 'deposit'], required: true },
    subtotal: { type: Number, required: true, min: 0 },
    serviceFee: { type: Number, required: true, min: 0 },
    tax: { type: Number, required: true, min: 0 },
    total: { type: Number, required: true, min: 0 },
    depositAmount: { type: Number, default: 0, min: 0 },
    balanceDue: { type: Number, default: 0, min: 0 },
    status: {
      type: String,
      enum: ['upcoming', 'confirmed', 'deposit_paid', 'active', 'completed', 'cancelled'],
      default: 'upcoming',
      index: true,
    },
    delivery: {
      method: { type: String, enum: ['pickup', 'delivery'], default: 'pickup' },
      address: { street: String, city: String, state: String, zipCode: String, country: String },
      deliveryFee: { type: Number, default: 0, min: 0 },
      notes: String,
    },
    customerSnapshot: {
      name: String,
      email: String,
      phone: String,
    },
  },
  { timestamps: true }
);

rentalSchema.index({ createdAt: -1 });
rentalSchema.index({ 'items.productId': 1 });

module.exports = mongoose.model('Rental', rentalSchema);


