import React, { useState } from 'react';
import { ArrowLeft, Heart, Share2, Calendar, Clock, Shield, Star, Plus, Minus } from 'lucide-react';
import { useAppContext } from '../context/AppContext';
import { Button } from '../components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
import { Badge } from '../components/ui/badge';
import { Separator } from '../components/ui/separator';
import { Checkbox } from '../components/ui/checkbox';
import { toast } from '../hooks/use-toast';

interface ProductDetailProps {
  productId: string;
}

const ProductDetail: React.FC<ProductDetailProps> = ({ productId }) => {
  const { products, addToCart, setCurrentPage, user } = useAppContext();
  const product = products.find(p => p.id === productId);
  
  const [quantity, setQuantity] = useState(1);
  const [duration, setDuration] = useState(1);
  const [durationType, setDurationType] = useState<'hour' | 'day' | 'week'>('day');
  const [selectedAddOns, setSelectedAddOns] = useState<string[]>([]);
  const [startDate, setStartDate] = useState(new Date());

  if (!product) {
    return (
      <div className="min-h-screen bg-gradient-hero flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-2xl font-bold mb-4">Product not found</h2>
          <Button onClick={() => setCurrentPage('marketplace')}>
            Back to Marketplace
          </Button>
        </div>
      </div>
    );
  }

  const getPrice = () => {
    switch (durationType) {
      case 'hour': return product.pricePerHour;
      case 'day': return product.pricePerDay;
      case 'week': return product.pricePerWeek;
      default: return product.pricePerDay;
    }
  };

  const getAddOnTotal = () => {
    return product.addOns
      .filter(addOn => selectedAddOns.includes(addOn.id))
      .reduce((total, addOn) => total + addOn.price, 0);
  };

  const getTotalPrice = () => {
    const basePrice = getPrice() * quantity * duration;
    const addOnTotal = getAddOnTotal() * quantity;
    return basePrice + addOnTotal;
  };

  const handleAddToCart = () => {
    if (!user) {
      setCurrentPage('login');
      return;
    }

    const endDate = new Date(startDate);
    if (durationType === 'hour') {
      endDate.setHours(endDate.getHours() + duration);
    } else if (durationType === 'day') {
      endDate.setDate(endDate.getDate() + duration);
    } else {
      endDate.setDate(endDate.getDate() + (duration * 7));
    }

    const cartItem = {
      product,
      quantity,
      duration,
      durationType,
      selectedAddOns: product.addOns.filter(addOn => selectedAddOns.includes(addOn.id)),
      startDate,
      endDate
    };

    addToCart(cartItem);
    toast({
      title: "Added to cart!",
      description: `${product.name} has been added to your cart.`,
    });
  };

  const toggleAddOn = (addOnId: string) => {
    setSelectedAddOns(prev => 
      prev.includes(addOnId) 
        ? prev.filter(id => id !== addOnId)
        : [...prev, addOnId]
    );
  };

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
            Back
          </Button>
          <div className="flex-1">
            <h1 className="text-3xl font-bold">{product.name}</h1>
            <p className="text-muted-foreground">{product.category}</p>
          </div>
          <div className="flex space-x-2">
            <Button variant="outline" size="sm" className="btn-glass">
              <Heart className="w-4 h-4" />
            </Button>
            <Button variant="outline" size="sm" className="btn-glass">
              <Share2 className="w-4 h-4" />
            </Button>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Product Images & Info */}
          <div className="lg:col-span-2 space-y-6">
            {/* Image Gallery */}
            <Card className="glass border-glass-border">
              <CardContent className="p-6">
                <div className="aspect-video bg-gradient-accent opacity-20 rounded-lg flex items-center justify-center mb-4">
                  <span className="text-8xl">📦</span>
                </div>
                <div className="flex space-x-3">
                  {[1,2,3,4].map(i => (
                    <div key={i} className="w-20 h-20 bg-muted rounded-lg opacity-60 cursor-pointer hover:opacity-100 transition-opacity">
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Product Details */}
            <Card className="glass border-glass-border">
              <CardHeader>
                <CardTitle className="flex items-center justify-between">
                  Product Details
                  <Badge className={product.availability === 'available' ? 'badge-available' : 'badge-booked'}>
                    {product.availability === 'available' ? 'Available' : 'Booked'}
                  </Badge>
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <p className="text-muted-foreground">{product.description}</p>
                
                <div>
                  <h4 className="font-semibold mb-2">Features</h4>
                  <div className="grid grid-cols-2 gap-2">
                    {product.features.map((feature, index) => (
                      <div key={index} className="flex items-center space-x-2">
                        <Shield className="w-4 h-4 text-accent" />
                        <span className="text-sm">{feature}</span>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="flex items-center space-x-4">
                  <div className="flex items-center space-x-1">
                    {[1,2,3,4,5].map(i => (
                      <Star key={i} className="w-4 h-4 text-secondary fill-current" />
                    ))}
                  </div>
                  <span className="text-sm text-muted-foreground">4.8 (24 reviews)</span>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Booking Panel */}
          <div className="space-y-6">
            <Card className="glass border-glass-border animate-fade-up">
              <CardHeader>
                <CardTitle>Book This Item</CardTitle>
              </CardHeader>
              <CardContent className="space-y-6">
                {/* Pricing Options */}
                <div className="space-y-3">
                  <h4 className="font-semibold">Rental Duration</h4>
                  <div className="grid grid-cols-3 gap-2">
                    {[
                      { type: 'hour' as const, label: 'Hourly', price: product.pricePerHour },
                      { type: 'day' as const, label: 'Daily', price: product.pricePerDay },
                      { type: 'week' as const, label: 'Weekly', price: product.pricePerWeek }
                    ].map(option => (
                      <button
                        key={option.type}
                        onClick={() => setDurationType(option.type)}
                        className={`p-3 rounded-lg border text-center transition-all ${
                          durationType === option.type
                            ? 'bg-primary text-primary-foreground border-primary'
                            : 'border-glass-border hover:border-primary'
                        }`}
                      >
                        <div className="text-sm font-medium">{option.label}</div>
                        <div className="text-xs">${option.price}</div>
                      </button>
                    ))}
                  </div>
                </div>

                <Separator />

                {/* Quantity & Duration */}
                <div className="space-y-4">
                  <div>
                    <label className="block text-sm font-medium mb-2">Quantity</label>
                    <div className="flex items-center space-x-3">
                      <Button 
                        variant="outline" 
                        size="sm"
                        onClick={() => setQuantity(Math.max(1, quantity - 1))}
                        className="btn-glass"
                      >
                        <Minus className="w-4 h-4" />
                      </Button>
                      <span className="font-bold text-lg w-8 text-center">{quantity}</span>
                      <Button 
                        variant="outline" 
                        size="sm"
                        onClick={() => setQuantity(quantity + 1)}
                        className="btn-glass"
                      >
                        <Plus className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>

                  <div>
                    <label className="block text-sm font-medium mb-2">
                      Duration ({durationType}s)
                    </label>
                    <div className="flex items-center space-x-3">
                      <Button 
                        variant="outline" 
                        size="sm"
                        onClick={() => setDuration(Math.max(1, duration - 1))}
                        className="btn-glass"
                      >
                        <Minus className="w-4 h-4" />
                      </Button>
                      <span className="font-bold text-lg w-8 text-center">{duration}</span>
                      <Button 
                        variant="outline" 
                        size="sm"
                        onClick={() => setDuration(duration + 1)}
                        className="btn-glass"
                      >
                        <Plus className="w-4 h-4" />
                      </Button>
                    </div>
                  </div>
                </div>

                <Separator />

                {/* Add-ons */}
                {product.addOns.length > 0 && (
                  <div className="space-y-3">
                    <h4 className="font-semibold">Add-ons</h4>
                    {product.addOns.map(addOn => (
                      <div key={addOn.id} className="flex items-center space-x-3">
                        <Checkbox
                          id={addOn.id}
                          checked={selectedAddOns.includes(addOn.id)}
                          onCheckedChange={() => toggleAddOn(addOn.id)}
                        />
                        <label htmlFor={addOn.id} className="flex-1 text-sm cursor-pointer">
                          {addOn.name}
                        </label>
                        <span className="text-sm font-medium">${addOn.price}</span>
                      </div>
                    ))}
                  </div>
                )}

                <Separator />

                {/* Price Breakdown */}
                <div className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span>Base price ({quantity} × {duration} {durationType}s)</span>
                    <span>${getPrice() * quantity * duration}</span>
                  </div>
                  {getAddOnTotal() > 0 && (
                    <div className="flex justify-between text-sm">
                      <span>Add-ons ({quantity} × selected)</span>
                      <span>${getAddOnTotal() * quantity}</span>
                    </div>
                  )}
                  <Separator />
                  <div className="flex justify-between font-bold text-lg">
                    <span>Total</span>
                    <span className="text-primary">${getTotalPrice()}</span>
                  </div>
                </div>

                {/* Action Buttons */}
                <div className="space-y-3">
                  <Button 
                    onClick={handleAddToCart}
                    disabled={product.availability === 'booked'}
                    className="w-full btn-premium text-primary-foreground"
                  >
                    <Calendar className="w-4 h-4 mr-2" />
                    {product.availability === 'available' ? 'Add to Cart' : 'Currently Booked'}
                  </Button>
                  <Button 
                    variant="outline" 
                    className="w-full btn-glass border-glass-border"
                    disabled={product.availability === 'booked'}
                  >
                    <Clock className="w-4 h-4 mr-2" />
                    Instant Reserve
                  </Button>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ProductDetail;