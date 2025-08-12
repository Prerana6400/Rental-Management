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

const cartItemSchema = new Schema(
  {
    productId: { type: Schema.Types.ObjectId, ref: 'Product', required: true },
    quantity: { type: Number, required: true, min: 1 },
    duration: { type: Number, required: true, min: 1 },
    durationType: { type: String, enum: ['hour', 'day', 'week'], required: true },
    selectedAddOns: { type: [selectedAddOnSchema], default: [] },
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
  },
  { _id: false }
);

const cartSchema = new Schema(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, unique: true, index: true },
    items: { type: [cartItemSchema], default: [] },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Cart', cartSchema);


