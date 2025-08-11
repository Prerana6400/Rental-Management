import React from 'react';
import { useAppContext } from '../context/AppContext';
import { Button } from '../components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
import { Separator } from '../components/ui/separator';
import { Calendar, ArrowLeft, Package } from 'lucide-react';

const CustomerPortal: React.FC = () => {
  const { rentals, setCurrentPage } = useAppContext();

  if (rentals.length === 0) {
    return (
      <div className="min-h-screen bg-gradient-hero">
        <div className="container mx-auto px-6 py-8">
          <div className="max-w-3xl mx-auto text-center space-y-6">
            <div className="w-20 h-20 bg-muted rounded-full flex items-center justify-center mx-auto">
              <Package className="w-10 h-10 text-muted-foreground" />
            </div>
            <h1 className="text-3xl font-bold">No rentals yet</h1>
            <p className="text-muted-foreground">Browse the marketplace to start a new rental.</p>
            <Button onClick={() => setCurrentPage('marketplace')} className="btn-premium text-primary-foreground">
              Explore Marketplace
            </Button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-hero">
      <div className="container mx-auto px-6 py-8">
        <div className="flex items-center space-x-4 mb-8">
          <Button 
            variant="outline" 
            onClick={() => setCurrentPage('marketplace')}
            className="btn-glass border-glass-border"
          >
            <ArrowLeft className="w-4 h-4 mr-2" />
            Back to Marketplace
          </Button>
          <div className="flex-1">
            <h1 className="text-3xl font-bold">My Rentals</h1>
            <p className="text-muted-foreground">View and manage your rental orders</p>
          </div>
        </div>

        <div className="space-y-6">
          {rentals.map(rental => (
            <Card key={rental.id} className="glass border-glass-border animate-fade-up">
              <CardHeader>
                <CardTitle className="flex items-center justify-between">
                  <span>Order #{rental.id}</span>
                  <span className="text-sm font-medium capitalize">{rental.status}</span>
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                  <div>
                    <span className="text-muted-foreground">Created</span>
                    <div className="font-medium">{new Date(rental.createdAt).toLocaleString()}</div>
                  </div>
                  <div>
                    <span className="text-muted-foreground">Payment</span>
                    <div className="font-medium capitalize">{rental.paymentMode}</div>
                  </div>
                  <div>
                    <span className="text-muted-foreground">Total</span>
                    <div className="font-bold text-primary">${rental.total}</div>
                  </div>
                </div>

                <Separator />

                <div className="space-y-2">
                  {rental.items.map((item, idx) => (
                    <div key={`${rental.id}-${item.product.id}-${idx}`} className="flex items-start justify-between text-sm">
                      <div>
                        <div className="font-medium">{item.product.name}</div>
                        <div className="text-muted-foreground">
                          {item.quantity} × {item.duration} {item.durationType}(s)
                        </div>
                        <div className="text-muted-foreground">
                          From {new Date(item.startDate).toLocaleDateString()} to {new Date(item.endDate).toLocaleDateString()}
                        </div>
                      </div>
                      <div className="flex items-center text-muted-foreground">
                        <Calendar className="w-4 h-4 mr-2" />
                        <span>{item.duration} {item.durationType}(s)</span>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </div>
  );
};

export default CustomerPortal; 