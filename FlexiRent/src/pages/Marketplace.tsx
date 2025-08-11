import React, { useState } from 'react';
import { Search, Filter, Grid, Calendar, MapPin, Star } from 'lucide-react';
import { useAppContext } from '../context/AppContext';
import { Button } from '../components/ui/button';
import { Input } from '../components/ui/input';
import { Card, CardContent } from '../components/ui/card';
import { Badge } from '../components/ui/badge';
import heroImage from '../assets/hero-rental.jpg';

const Marketplace: React.FC = () => {
  const { products, setCurrentPage } = useAppContext();
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');

  const categories = ['all', 'Photography', 'Technology', 'Tools', 'Furniture'];

  const filteredProducts = products.filter(product => {
    const matchesSearch = product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         product.category.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || product.category === selectedCategory;
    return matchesSearch && matchesCategory;
  });

  return (
    <div className="min-h-screen bg-gradient-hero">
      {/* Hero Section */}
      <section className="relative overflow-hidden">
        <div className="absolute inset-0">
          <img 
            src={heroImage} 
            alt="Premium rental marketplace" 
            className="w-full h-full object-cover opacity-20"
          />
          <div className="absolute inset-0 bg-gradient-hero opacity-90"></div>
        </div>
        
        <div className="relative container mx-auto px-6 py-20">
          <div className="text-center space-y-8 animate-fade-up">
            <div className="space-y-4">
              <h1 className="text-5xl md:text-7xl font-bold">
                <span className="bg-gradient-primary bg-clip-text text-transparent">
                  Premium Rentals
                </span>
              </h1>
              <p className="text-xl md:text-2xl text-muted-foreground max-w-3xl mx-auto">
                Discover professional-grade equipment, furniture, and technology for your next project
              </p>
            </div>

            {/* Search Bar */}
            <div className="max-w-2xl mx-auto">
              <div className="relative">
                <Search className="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-muted-foreground" />
                <Input
                  type="text"
                  placeholder="Search for cameras, laptops, tools, furniture..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-12 pr-4 py-4 text-lg glass border-glass-border"
                />
                <Button className="absolute right-2 top-1/2 transform -translate-y-1/2 btn-premium">
                  <Filter className="w-4 h-4 mr-2" />
                  Filter
                </Button>
              </div>
            </div>

            <div className="flex flex-wrap justify-center gap-3">
              {categories.map(category => (
                <Button
                  key={category}
                  variant={selectedCategory === category ? "default" : "outline"}
                  onClick={() => setSelectedCategory(category)}
                  className={selectedCategory === category 
                    ? "btn-premium text-primary-foreground" 
                    : "btn-glass border-glass-border"
                  }
                >
                  {category === 'all' ? 'All Categories' : category}
                </Button>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Products Grid */}
      <section className="container mx-auto px-6 py-16">
        <div className="flex items-center justify-between mb-8">
          <div className="space-y-2">
            <h2 className="text-3xl font-bold">Available Items</h2>
            <p className="text-muted-foreground">{filteredProducts.length} items available</p>
          </div>
          <Button variant="outline" className="btn-glass border-glass-border">
            <Grid className="w-4 h-4 mr-2" />
            Grid View
          </Button>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {filteredProducts.map(product => (
            <Card 
              key={product.id} 
              className="glass border-glass-border hover-lift cursor-pointer animate-fade-up"
              onClick={() => setCurrentPage(`product-${product.id}`)}
            >
              <div className="relative overflow-hidden rounded-t-lg">
                <div className="w-full h-48 bg-gradient-accent opacity-20 flex items-center justify-center">
                  <span className="text-6xl">📦</span>
                </div>
                <Badge 
                  className={`absolute top-3 right-3 ${
                    product.availability === 'available' 
                      ? 'badge-available' 
                      : 'badge-booked'
                  }`}
                >
                  {product.availability === 'available' ? 'Available' : 'Booked'}
                </Badge>
              </div>

              <CardContent className="p-6 space-y-4">
                <div className="space-y-2">
                  <Badge variant="outline" className="text-xs">
                    {product.category}
                  </Badge>
                  <h3 className="font-bold text-lg leading-tight">{product.name}</h3>
                  <p className="text-sm text-muted-foreground line-clamp-2">
                    {product.description}
                  </p>
                </div>

                <div className="space-y-3">
                  <div className="flex items-center space-x-2">
                    <Star className="w-4 h-4 text-secondary fill-current" />
                    <span className="text-sm font-medium">4.8 (24 reviews)</span>
                  </div>

                  <div className="space-y-1">
                    <div className="flex justify-between text-sm">
                      <span className="text-muted-foreground">Hourly</span>
                      <span className="font-bold">${product.pricePerHour}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-muted-foreground">Daily</span>
                      <span className="font-bold text-primary">${product.pricePerDay}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-muted-foreground">Weekly</span>
                      <span className="font-bold">${product.pricePerWeek}</span>
                    </div>
                  </div>

                  <Button 
                    className="w-full btn-premium text-primary-foreground"
                    disabled={product.availability === 'booked'}
                  >
                    {product.availability === 'available' ? 'View Details' : 'Currently Booked'}
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {filteredProducts.length === 0 && (
          <div className="text-center py-16">
            <div className="w-24 h-24 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
              <Search className="w-12 h-12 text-muted-foreground" />
            </div>
            <h3 className="text-xl font-bold mb-2">No items found</h3>
            <p className="text-muted-foreground">Try adjusting your search or filters</p>
          </div>
        )}
      </section>
    </div>
  );
};

export default Marketplace;