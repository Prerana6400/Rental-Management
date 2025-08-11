import React, { useState } from 'react';
import { ArrowLeft, CreditCard, Shield, CheckCircle } from 'lucide-react';
import { useAppContext } from '../context/AppContext';
import { Button } from '../components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
import { Input } from '../components/ui/input';
import { Separator } from '../components/ui/separator';
import { RadioGroup, RadioGroupItem } from '../components/ui/radio-group';

const Checkout: React.FC = () => {
  const { cart, getCartTotal, clearCart, setCurrentPage } = useAppContext();
  const [paymentMode, setPaymentMode] = useState('full');
  const [customerDetails, setCustomerDetails] = useState({
    name: '',
    email: '',
    phone: '',
    address: '',
    city: '',
    zipCode: ''
  });

  const subtotal = getCartTotal();
  const serviceFee = Math.round(subtotal * 0.05);
  const tax = Math.round(subtotal * 0.08);
  const total = Math.round(subtotal * 1.13);
  const depositAmount = Math.round(total * 0.3);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Mock order processing
    setTimeout(() => {
      clearCart();
      setCurrentPage('order-confirmation');
    }, 2000);
  };

  const handleInputChange = (field: string, value: string) => {
    setCustomerDetails(prev => ({ ...prev, [field]: value }));
  };

  return (
    <div className="min-h-screen bg-gradient-hero">
      <div className="container mx-auto px-6 py-8">
        {/* Header */}
        <div className="flex items-center space-x-4 mb-8">
          <Button 
            variant="outline" 
            onClick={() => setCurrentPage('cart')}
            className="btn-glass border-glass-border"
          >
            <ArrowLeft className="w-4 h-4 mr-2" />
            Back to Cart
          </Button>
          <div className="flex-1">
            <h1 className="text-3xl font-bold">Checkout</h1>
            <p className="text-muted-foreground">Complete your rental booking</p>
          </div>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {/* Customer Details & Payment */}
            <div className="lg:col-span-2 space-y-6">
              {/* Customer Information */}
              <Card className="glass border-glass-border animate-fade-up">
                <CardHeader>
                  <CardTitle>Customer Information</CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium mb-2">Full Name *</label>
                      <Input
                        required
                        placeholder="John Doe"
                        value={customerDetails.name}
                        onChange={(e) => handleInputChange('name', e.target.value)}
                        className="glass border-glass-border"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium mb-2">Email *</label>
                      <Input
                        type="email"
                        required
                        placeholder="john@example.com"
                        value={customerDetails.email}
                        onChange={(e) => handleInputChange('email', e.target.value)}
                        className="glass border-glass-border"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium mb-2">Phone *</label>
                      <Input
                        required
                        placeholder="+1 (555) 123-4567"
                        value={customerDetails.phone}
                        onChange={(e) => handleInputChange('phone', e.target.value)}
                        className="glass border-glass-border"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium mb-2">Address</label>
                      <Input
                        placeholder="123 Main St"
                        value={customerDetails.address}
                        onChange={(e) => handleInputChange('address', e.target.value)}
                        className="glass border-glass-border"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium mb-2">City</label>
                      <Input
                        placeholder="New York"
                        value={customerDetails.city}
                        onChange={(e) => handleInputChange('city', e.target.value)}
                        className="glass border-glass-border"
                      />
                    </div>
                    <div>
                      <label className="block text-sm font-medium mb-2">ZIP Code</label>
                      <Input
                        placeholder="10001"
                        value={customerDetails.zipCode}
                        onChange={(e) => handleInputChange('zipCode', e.target.value)}
                        className="glass border-glass-border"
                      />
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* Payment Method */}
              <Card className="glass border-glass-border animate-fade-up">
                <CardHeader>
                  <CardTitle>Payment Method</CardTitle>
                </CardHeader>
                <CardContent className="space-y-6">
                  {/* Payment Mode Selection */}
                  <div>
                    <label className="block text-sm font-medium mb-3">Payment Mode</label>
                    <RadioGroup value={paymentMode} onValueChange={setPaymentMode}>
                      <div className="flex items-center space-x-2 p-4 border border-glass-border rounded-lg">
                        <RadioGroupItem value="full" id="full" />
                        <label htmlFor="full" className="flex-1 cursor-pointer">
                          <div className="font-medium">Pay Full Amount</div>
                          <div className="text-sm text-muted-foreground">
                            Pay the complete amount now (${total})
                          </div>
                        </label>
                      </div>
                      <div className="flex items-center space-x-2 p-4 border border-glass-border rounded-lg">
                        <RadioGroupItem value="deposit" id="deposit" />
                        <label htmlFor="deposit" className="flex-1 cursor-pointer">
                          <div className="font-medium">Pay Deposit (30%)</div>
                          <div className="text-sm text-muted-foreground">
                            Pay ${depositAmount} now, remaining ${total - depositAmount} on pickup
                          </div>
                        </label>
                      </div>
                    </RadioGroup>
                  </div>

                  {/* Credit Card Details */}
                  <div className="space-y-4">
                    <div>
                      <label className="block text-sm font-medium mb-2">Card Number *</label>
                      <Input
                        required
                        placeholder="1234 5678 9012 3456"
                        className="glass border-glass-border"
                      />
                    </div>

                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium mb-2">Expiry Date *</label>
                        <Input
                          required
                          placeholder="MM/YY"
                          className="glass border-glass-border"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium mb-2">CVV *</label>
                        <Input
                          required
                          placeholder="123"
                          className="glass border-glass-border"
                        />
                      </div>
                    </div>

                    <div>
                      <label className="block text-sm font-medium mb-2">Cardholder Name *</label>
                      <Input
                        required
                        placeholder="John Doe"
                        className="glass border-glass-border"
                      />
                    </div>
                  </div>

                  {/* Security Notice */}
                  <div className="flex items-center space-x-2 p-3 bg-success/10 border border-success/20 rounded-lg">
                    <Shield className="w-5 h-5 text-success" />
                    <div className="text-sm">
                      <div className="font-medium text-success">Secure Payment</div>
                      <div className="text-muted-foreground">Your payment information is encrypted and secure</div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>

            {/* Order Summary */}
            <div className="space-y-6">
              <Card className="glass border-glass-border animate-fade-up">
                <CardHeader>
                  <CardTitle>Order Summary</CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  {/* Items */}
                  <div className="space-y-3">
                    {cart.map((item, index) => (
                      <div key={`checkout-${item.product.id}-${index}`} className="space-y-1">
                        <div className="flex justify-between">
                          <span className="font-medium">{item.product.name}</span>
                          <span>
                            ${item.durationType === 'hour' ? item.product.pricePerHour : 
                              item.durationType === 'day' ? item.product.pricePerDay : 
                              item.product.pricePerWeek} × {item.quantity} × {item.duration}
                          </span>
                        </div>
                        <div className="text-sm text-muted-foreground">
                          {item.quantity} item(s) for {item.duration} {item.durationType}(s)
                        </div>
                        {item.selectedAddOns.length > 0 && (
                          <div className="text-sm text-muted-foreground">
                            Add-ons: {item.selectedAddOns.map(addOn => addOn.name).join(', ')}
                          </div>
                        )}
                      </div>
                    ))}
                  </div>

                  <Separator />

                  {/* Pricing Breakdown */}
                  <div className="space-y-2">
                    <div className="flex justify-between text-sm">
                      <span>Subtotal</span>
                      <span>${subtotal}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span>Service Fee</span>
                      <span>${serviceFee}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span>Tax</span>
                      <span>${tax}</span>
                    </div>
                    <Separator />
                    <div className="flex justify-between font-bold text-lg">
                      <span>Total</span>
                      <span className="text-primary">${total}</span>
                    </div>
                    {paymentMode === 'deposit' && (
                      <>
                        <Separator />
                        <div className="space-y-1 p-3 bg-primary/10 rounded-lg">
                          <div className="flex justify-between font-medium">
                            <span>Amount Due Now (30%)</span>
                            <span className="text-primary">${depositAmount}</span>
                          </div>
                          <div className="flex justify-between text-sm text-muted-foreground">
                            <span>Remaining on Pickup</span>
                            <span>${total - depositAmount}</span>
                          </div>
                        </div>
                      </>
                    )}
                  </div>

                  {/* Submit Button */}
                  <Button 
                    type="submit"
                    className="w-full btn-premium text-primary-foreground mt-6"
                  >
                    <CreditCard className="w-4 h-4 mr-2" />
                    {paymentMode === 'full' 
                      ? `Pay $${total}` 
                      : `Pay Deposit $${depositAmount}`
                    }
                  </Button>
                </CardContent>
              </Card>

              {/* Trust Indicators */}
              <Card className="glass border-glass-border">
                <CardContent className="p-4 space-y-3">
                  <div className="flex items-center space-x-2">
                    <CheckCircle className="w-5 h-5 text-success" />
                    <span className="text-sm">30-day money back guarantee</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <CheckCircle className="w-5 h-5 text-success" />
                    <span className="text-sm">Free cancellation up to 24h</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <CheckCircle className="w-5 h-5 text-success" />
                    <span className="text-sm">24/7 customer support</span>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Checkout;