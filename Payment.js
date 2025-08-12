const mongoose = require('mongoose');

const { Schema } = mongoose;

const paymentSchema = new Schema(
  {
    rentalId: { type: Schema.Types.ObjectId, ref: 'Rental', required: true, index: true },
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    amount: { type: Number, required: true, min: 0 },
    currency: { type: String, default: 'INR' },
    paymentType: { type: String, enum: ['deposit', 'balance', 'full', 'refund'], required: true },
    method: { type: String, enum: ['card', 'upi', 'cash', 'bank', 'paypal', 'paytm'], required: true },
    status: { type: String, enum: ['pending', 'succeeded', 'failed', 'refunded'], default: 'pending', index: true },
    provider: String,
    providerRef: String,
    errorReason: String,
    // Paytm specific fields
    paytmOrderId: String,
    paytmTransactionId: String,
    bankTransactionId: String,
    bankName: String,
    paymentMode: String,
    gatewayName: String,
    responseCode: String,
    responseMessage: String,
  },
  { timestamps: true }
);

paymentSchema.index({ createdAt: -1 });

module.exports = mongoose.model('Payment', paymentSchema);


