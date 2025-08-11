import React from 'react';
import { CheckCircle, Download, ArrowLeft, Calendar, Mail } from 'lucide-react';
import { useAppContext } from '../context/AppContext';
import { Button } from '../components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';

const OrderConfirmation: React.FC = () => {
  const { setCurrentPage } = useAppContext();
  const orderNumber = `FR-${Date.now().toString().slice(-6)}`;

  return (
    <div className="min-h-screen bg-gradient-hero">
      <div className="container mx-auto px-6 py-8">
        <div className="max-w-2xl mx-auto">
          {/* Success Header */}
          <div className="text-center mb-8 animate-fade-up">
            <div className="w-20 h-20 bg-success rounded-full flex items-center justify-center mx-auto mb-6 animate-glow">
              <CheckCircle className="w-12 h-12 text-white" />
            </div>
            <h1 className="text-4xl font-bold mb-4">Order Confirmed!</h1>
            <p className="text-xl text-muted-foreground">
              Thank you for choosing FlexiRent. Your booking has been confirmed.
            </p>
          </div>

          {/* Order Details */}
          <Card className="glass border-glass-border mb-6 animate-fade-up">
            <CardHeader>
              <CardTitle className="flex items-center justify-between">
                Order Details
                <span className="text-sm font-mono bg-muted px-3 py-1 rounded-full">
                  #{orderNumber}
                </span>
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <span className="text-muted-foreground">Order Date:</span>
                  <div className="font-medium">{new Date().toLocaleDateString()}</div>
                </div>
                <div>
                  <span className="text-muted-foreground">Order Status:</span>
                  <div className="font-medium text-success">Confirmed</div>
                </div>
                <div>
                  <span className="text-muted-foreground">Payment Status:</span>
                  <div className="font-medium text-success">Paid</div>
                </div>
                <div>
                  <span className="text-muted-foreground">Estimated Pickup:</span>
                  <div className="font-medium">{new Date(Date.now() + 86400000).toLocaleDateString()}</div>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* What's Next */}
          <Card className="glass border-glass-border mb-6 animate-fade-up">
            <CardHeader>
              <CardTitle>What's Next?</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-3">
                <div className="flex items-start space-x-3">
                  <div className="w-6 h-6 bg-primary rounded-full flex items-center justify-center text-white text-sm font-bold">
                    1
                  </div>
                  <div>
                    <div className="font-medium">Confirmation Email</div>
                    <div className="text-sm text-muted-foreground">
                      We've sent a confirmation email with all your rental details
                    </div>
                  </div>
                </div>
                
                <div className="flex items-start space-x-3">
                  <div className="w-6 h-6 bg-primary rounded-full flex items-center justify-center text-white text-sm font-bold">
                    2
                  </div>
                  <div>
                    <div className="font-medium">Pickup Preparation</div>
                    <div className="text-sm text-muted-foreground">
                      We'll prepare your items and send pickup instructions
                    </div>
                  </div>
                </div>
                
                <div className="flex items-start space-x-3">
                  <div className="w-6 h-6 bg-muted rounded-full flex items-center justify-center text-muted-foreground text-sm font-bold">
                    3
                  </div>
                  <div>
                    <div className="font-medium">Pickup & Enjoy</div>
                    <div className="text-sm text-muted-foreground">
                      Collect your items and start your rental period
                    </div>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Action Buttons */}
          <div className="space-y-4 animate-fade-up">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <Button className="btn-premium text-primary-foreground">
                <Download className="w-4 h-4 mr-2" />
                Download Invoice
              </Button>
              <Button 
                variant="outline" 
                className="btn-glass border-glass-border"
                onClick={() => setCurrentPage('customer-portal')}
              >
                <Calendar className="w-4 h-4 mr-2" />
                View My Rentals
              </Button>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <Button 
                variant="outline" 
                className="btn-glass border-glass-border"
                onClick={() => setCurrentPage('marketplace')}
              >
                <ArrowLeft className="w-4 h-4 mr-2" />
                Continue Shopping
              </Button>
              <Button variant="outline" className="btn-glass border-glass-border">
                <Mail className="w-4 h-4 mr-2" />
                Contact Support
              </Button>
            </div>
          </div>

          {/* Support Info */}
          <Card className="glass border-glass-border mt-6 animate-fade-up">
            <CardContent className="p-4 text-center">
              <p className="text-sm text-muted-foreground mb-2">
                Need help? Our customer support team is here 24/7
              </p>
              <p className="text-sm font-medium">
                📧 support@flexirent.com | 📞 +1 (555) 123-4567
              </p>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
};

export default OrderConfirmation;