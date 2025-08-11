import React from 'react';
import { ArrowLeft, Plus, Minus, Trash2, ShoppingBag, CreditCard } from 'lucide-react';
import { useAppContext } from '../context/AppContext';
import { Button } from '../components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
import { Separator } from '../components/ui/separator';
import { Badge } from '../components/ui/badge';

const Cart: React.FC = () => {
  const { cart, updateCartItem, removeFromCart, getCartTotal, setCurrentPage } = useAppContext();

  const updateQuantity = (productId: string, newQuantity: number) => {
    if (newQuantity < 1) return;
    updateCartItem(productId, { quantity: newQuantity });
  };

  const updateDuration = (productId: string, newDuration: number) => {
    if (newDuration < 1) return;
    updateCartItem(productId, { duration: newDuration });
  };

  const getItemTotal = (item: any) => {
    const basePrice = item.durationType === 'hour' 
      ? item.product.pricePerHour 
      : item.durationType === 'day' 
      ? item.product.pricePerDay 
      : item.product.pricePerWeek;
    
    const addOnTotal = item.selectedAddOns.reduce((sum: number, addOn: any) => sum + addOn.price, 0);
    return (basePrice * item.quantity * item.duration) + (addOnTotal * item.quantity);
  };

  if (cart.length === 0) {
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
            <h1 className="text-3xl font-bold">Shopping Cart</h1>
          </div>

          <div className="text-center py-16">
            <div className="w-24 h-24 bg-muted rounded-full flex items-center justify-center mx-auto mb-6">
              <ShoppingBag className="w-12 h-12 text-muted-foreground" />
            </div>
            <h2 className="text-2xl font-bold mb-4">Your cart is empty</h2>
            <p className="text-muted-foreground mb-6">Add some items to get started</p>
            <Button 
              onClick={() => setCurrentPage('marketplace')}
              className="btn-premium text-primary-foreground"
            >
              Continue Shopping
            </Button>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-hero">
      <div className="container mx-auto px-6 py-8">
        {/* Header */}
        <div className="flex items-center space-x-4 mb-8">
          <Button 
            variant="outline" 
            onClick={() => setCurrentPage('marketplace')}
            className="btn-glass border-glass-border"
          >
            <ArrowLeft className="w-4 h-4 mr-2" />
            Continue Shopping
          </Button>
          <div className="flex-1">
            <h1 className="text-3xl font-bold">Shopping Cart</h1>
            <p className="text-muted-foreground">{cart.length} item(s) in your cart</p>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Cart Items */}
          <div className="lg:col-span-2 space-y-4">
            {cart.map((item, index) => (
              <Card key={`${item.product.id}-${index}`} className="glass border-glass-border animate-fade-up">
                <CardContent className="p-6">
                  <div className="flex space-x-4">
                    {/* Product Image */}
                    <div className="w-24 h-24 bg-gradient-accent opacity-20 rounded-lg flex items-center justify-center flex-shrink-0">
                      <span className="text-2xl">📦</span>
                    </div>

                    {/* Product Details */}
                    <div className="flex-1 space-y-3">
                      <div className="flex justify-between items-start">
                        <div>
                          <h3 className="font-bold text-lg">{item.product.name}</h3>
                          <p className="text-sm text-muted-foreground">{item.product.category}</p>
                          <Badge variant="outline" className="mt-1">
                            {item.durationType} rental
                          </Badge>
                        </div>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => removeFromCart(item.product.id)}
                          className="btn-glass border-glass-border text-destructive hover:bg-destructive hover:text-destructive-foreground"
                        >
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>

                      {/* Rental Period */}
                      <div className="text-sm text-muted-foreground">
                        <p>From: {item.startDate.toLocaleDateString()}</p>
                        <p>To: {item.endDate.toLocaleDateString()}</p>
                      </div>

                      {/* Add-ons */}
                      {item.selectedAddOns.length > 0 && (
                        <div className="text-sm">
                          <span className="font-medium">Add-ons: </span>
                          <span className="text-muted-foreground">
                            {item.selectedAddOns.map(addOn => addOn.name).join(', ')}
                          </span>
                        </div>
                      )}

                      {/* Quantity & Duration Controls */}
                      <div className="flex space-x-6">
                        <div className="flex items-center space-x-2">
                          <span className="text-sm font-medium">Qty:</span>
                          <Button 
                            variant="outline" 
                            size="sm"
                            onClick={() => updateQuantity(item.product.id, item.quantity - 1)}
                            className="w-8 h-8 p-0 btn-glass"
                          >
                            <Minus className="w-3 h-3" />
                          </Button>
                          <span className="w-8 text-center font-bold">{item.quantity}</span>
                          <Button 
                            variant="outline" 
                            size="sm"
                            onClick={() => updateQuantity(item.product.id, item.quantity + 1)}
                            className="w-8 h-8 p-0 btn-glass"
                          >
                            <Plus className="w-3 h-3" />
                          </Button>
                        </div>

                        <div className="flex items-center space-x-2">
                          <span className="text-sm font-medium">Duration:</span>
                          <Button 
                            variant="outline" 
                            size="sm"
                            onClick={() => updateDuration(item.product.id, item.duration - 1)}
                            className="w-8 h-8 p-0 btn-glass"
                          >
                            <Minus className="w-3 h-3" />
                          </Button>
                          <span className="w-8 text-center font-bold">{item.duration}</span>
                          <Button 
                            variant="outline" 
                            size="sm"
                            onClick={() => updateDuration(item.product.id, item.duration + 1)}
                            className="w-8 h-8 p-0 btn-glass"
                          >
                            <Plus className="w-3 h-3" />
                          </Button>
                          <span className="text-sm text-muted-foreground">
                            {item.durationType}(s)
                          </span>
                        </div>
                      </div>

                      {/* Price */}
                      <div className="flex justify-between items-center pt-2">
                        <div className="text-sm text-muted-foreground">
                          ${item.durationType === 'hour' ? item.product.pricePerHour : 
                            item.durationType === 'day' ? item.product.pricePerDay : 
                            item.product.pricePerWeek} per {item.durationType}
                        </div>
                        <div className="text-right">
                          <div className="text-lg font-bold text-primary">
                            ${getItemTotal(item)}
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>

          {/* Order Summary */}
          <div className="space-y-6">
            <Card className="glass border-glass-border animate-fade-up">
              <CardHeader>
                <CardTitle>Order Summary</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {/* Item breakdown */}
                <div className="space-y-2">
                  {cart.map((item, index) => (
                    <div key={`summary-${item.product.id}-${index}`} className="flex justify-between text-sm">
                      <span className="truncate mr-2">
                        {item.product.name} ({item.quantity}×{item.duration}{item.durationType.charAt(0)})
                      </span>
                      <span>${getItemTotal(item)}</span>
                    </div>
                  ))}
                </div>

                <Separator />

                {/* Totals */}
                <div className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span>Subtotal</span>
                    <span>${getCartTotal()}</span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span>Service Fee</span>
                    <span>${Math.round(getCartTotal() * 0.05)}</span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span>Tax</span>
                    <span>${Math.round(getCartTotal() * 0.08)}</span>
                  </div>
                  <Separator />
                  <div className="flex justify-between font-bold text-lg">
                    <span>Total</span>
                    <span className="text-primary">
                      ${Math.round(getCartTotal() * 1.13)}
                    </span>
                  </div>
                </div>

                {/* Action Buttons */}
                <div className="space-y-3 pt-4">
                  <Button 
                    onClick={() => setCurrentPage('checkout')}
                    className="w-full btn-premium text-primary-foreground"
                  >
                    <CreditCard className="w-4 h-4 mr-2" />
                    Proceed to Checkout
                  </Button>
                  <Button 
                    variant="outline"
                    onClick={() => setCurrentPage('marketplace')} 
                    className="w-full btn-glass border-glass-border"
                  >
                    Continue Shopping
                  </Button>
                </div>
              </CardContent>
            </Card>

            {/* Security Notice */}
            <Card className="glass border-glass-border">
              <CardContent className="p-4 text-center">
                <div className="text-sm text-muted-foreground">
                  🔒 Secure checkout powered by FlexiRent
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Cart;