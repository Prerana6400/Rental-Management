const mongoose = require('mongoose');
const { Schema } = mongoose;

const InvoiceSchema = new Schema({
  invoiceNumber: {
    type: String,
    required: true,
    unique: true,
    index: true
  },
  rentalId: {
    type: Schema.Types.ObjectId,
    ref: 'Rental',
    required: true,
    index: true
  },
  customerId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  customerDetails: {
    name: { type: String, required: true },
    email: { type: String, required: true },
    phone: { type: String },
    address: { type: String },
    city: { type: String },
    zipCode: { type: String }
  },
  items: [{
    productId: {
      type: Schema.Types.ObjectId,
      ref: 'Product',
      required: true
    },
    productSnapshot: {
      name: { type: String, required: true },
      category: { type: String, required: true },
      pricePerHour: { type: Number },
      pricePerDay: { type: Number },
      pricePerWeek: { type: Number }
    },
    quantity: { type: Number, required: true },
    duration: { type: Number, required: true },
    durationType: { type: String, enum: ['hour', 'day', 'week'], required: true },
    selectedAddOns: [{
      name: { type: String },
      price: { type: Number }
    }],
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
    lineTotal: { type: Number, required: true }
  }],
  pricing: {
    subtotal: { type: Number, required: true },
    serviceFee: { type: Number, required: true },
    tax: { type: Number, required: true },
    total: { type: Number, required: true },
    currency: { type: String, default: 'INR' }
  },
  paymentDetails: {
    paymentMode: { type: String, enum: ['full', 'deposit'], required: true },
    paymentStatus: { type: String, enum: ['pending', 'paid', 'failed'], default: 'pending' },
    paymentMethod: { type: String, enum: ['paytm', 'card', 'cash'], default: 'paytm' },
    transactionId: { type: String },
    paidAmount: { type: Number },
    paidAt: { type: Date }
  },
  status: {
    type: String,
    enum: ['draft', 'sent', 'paid', 'overdue', 'cancelled'],
    default: 'draft',
    index: true
  },
  dueDate: { type: Date, required: true },
  notes: { type: String },
  terms: { type: String },
  issuedAt: { type: Date, default: Date.now },
  paidAt: { type: Date }
}, {
  timestamps: true
});

// Generate invoice number
InvoiceSchema.pre('save', async function(next) {
  if (this.isNew && !this.invoiceNumber) {
    const lastInvoice = await this.constructor.findOne({}, {}, { sort: { 'invoiceNumber': -1 } });
    let nextNumber = 1;
    
    if (lastInvoice && lastInvoice.invoiceNumber) {
      const lastNumber = parseInt(lastInvoice.invoiceNumber.replace('INV-', ''));
      nextNumber = lastNumber + 1;
    }
    
    this.invoiceNumber = `INV-${String(nextNumber).padStart(6, '0')}`;
  }
  
  if (this.isNew) {
    this.issuedAt = new Date();
    // Set due date to 7 days from now
    this.dueDate = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
  }
  
  next();
});

module.exports = mongoose.model('Invoice', InvoiceSchema);
