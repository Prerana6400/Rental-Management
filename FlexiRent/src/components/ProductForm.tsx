import React, { useState, useEffect } from 'react';
import { X, Plus, Trash2 } from 'lucide-react';
import { Product, AddOn } from '../context/AppContext';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Textarea } from './ui/textarea';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Badge } from './ui/badge';

interface ProductFormProps {
  product?: Product;
  onSave: (product: Omit<Product, 'id'>) => void;
  onCancel: () => void;
}

const ProductForm: React.FC<ProductFormProps> = ({ product, onSave, onCancel }) => {
  const [formData, setFormData] = useState({
    name: '',
    category: '',
    description: '',
    image: '',
    pricePerHour: 0,
    pricePerDay: 0,
    pricePerWeek: 0,
    availability: 'available' as 'available' | 'booked',
    features: [''],
    addOns: [] as Omit<AddOn, 'id'>[]
  });

  useEffect(() => {
    if (product) {
      setFormData({
        name: product.name,
        category: product.category,
        description: product.description,
        image: product.image,
        pricePerHour: product.pricePerHour,
        pricePerDay: product.pricePerDay,
        pricePerWeek: product.pricePerWeek,
        availability: product.availability,
        features: [...product.features],
        addOns: product.addOns.map(({ id, ...addOn }) => addOn)
      });
    }
  }, [product]);

  const handleInputChange = (field: string, value: string | number) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleFeatureChange = (index: number, value: string) => {
    const newFeatures = [...formData.features];
    newFeatures[index] = value;
    setFormData(prev => ({ ...prev, features: newFeatures }));
  };

  const addFeature = () => {
    setFormData(prev => ({ ...prev, features: [...prev.features, ''] }));
  };

  const removeFeature = (index: number) => {
    setFormData(prev => ({ 
      ...prev, 
      features: prev.features.filter((_, i) => i !== index) 
    }));
  };

  const handleAddOnChange = (index: number, field: string, value: string | number) => {
    const newAddOns = [...formData.addOns];
    newAddOns[index] = { ...newAddOns[index], [field]: value };
    setFormData(prev => ({ ...prev, addOns: newAddOns }));
  };

  const addAddOn = () => {
    setFormData(prev => ({ 
      ...prev, 
      addOns: [...prev.addOns, { name: '', price: 0 }] 
    }));
  };

  const removeAddOn = (index: number) => {
    setFormData(prev => ({ 
      ...prev, 
      addOns: prev.addOns.filter((_, i) => i !== index) 
    }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate required fields
    if (!formData.name || !formData.category || !formData.description) {
      alert('Please fill in all required fields');
      return;
    }

    // Filter out empty features and add-ons
    const cleanFeatures = formData.features.filter(f => f.trim());
    const cleanAddOns = formData.addOns
      .filter(a => a.name.trim() && a.price > 0)
      .map((addOn, index) => ({ ...addOn, id: `temp-${index}` }));

    const productData = {
      ...formData,
      features: cleanFeatures,
      addOns: cleanAddOns
    };

    onSave(productData);
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-6 z-50">
      <Card className="w-full max-w-4xl max-h-[90vh] overflow-y-auto glass border-glass-border">
        <CardHeader className="flex items-center justify-between">
          <CardTitle>{product ? 'Edit Product' : 'Add New Product'}</CardTitle>
          <Button variant="ghost" size="sm" onClick={onCancel}>
            <X className="w-4 h-4" />
          </Button>
        </CardHeader>
        
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Basic Information */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-2">Product Name *</label>
                <Input
                  required
                  value={formData.name}
                  onChange={(e) => handleInputChange('name', e.target.value)}
                  placeholder="Professional Camera Kit"
                  className="glass border-glass-border"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium mb-2">Category *</label>
                <Input
                  required
                  value={formData.category}
                  onChange={(e) => handleInputChange('category', e.target.value)}
                  placeholder="Photography"
                  className="glass border-glass-border"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium mb-2">Description *</label>
              <Textarea
                required
                value={formData.description}
                onChange={(e) => handleInputChange('description', e.target.value)}
                placeholder="Describe the product..."
                rows={3}
                className="glass border-glass-border"
              />
            </div>

            <div>
              <label className="block text-sm font-medium mb-2">Image URL</label>
              <Input
                value={formData.image}
                onChange={(e) => handleInputChange('image', e.target.value)}
                placeholder="/placeholder-image.jpg"
                className="glass border-glass-border"
              />
            </div>

            {/* Pricing */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium mb-2">Price per Hour ($)</label>
                <Input
                  type="number"
                  min="0"
                  step="0.01"
                  value={formData.pricePerHour}
                  onChange={(e) => handleInputChange('pricePerHour', parseFloat(e.target.value) || 0)}
                  className="glass border-glass-border"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium mb-2">Price per Day ($)</label>
                <Input
                  type="number"
                  min="0"
                  step="0.01"
                  value={formData.pricePerDay}
                  onChange={(e) => handleInputChange('pricePerDay', parseFloat(e.target.value) || 0)}
                  className="glass border-glass-border"
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium mb-2">Price per Week ($)</label>
                <Input
                  type="number"
                  min="0"
                  step="0.01"
                  value={formData.pricePerWeek}
                  onChange={(e) => handleInputChange('pricePerWeek', parseFloat(e.target.value) || 0)}
                  className="glass border-glass-border"
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium mb-2">Availability</label>
              <select
                value={formData.availability}
                onChange={(e) => handleInputChange('availability', e.target.value)}
                className="w-full p-2 border border-glass-border rounded-lg bg-transparent"
              >
                <option value="available">Available</option>
                <option value="booked">Booked</option>
              </select>
            </div>

            {/* Features */}
            <div>
              <div className="flex items-center justify-between mb-3">
                <label className="block text-sm font-medium">Features</label>
                <Button type="button" variant="outline" size="sm" onClick={addFeature}>
                  <Plus className="w-4 h-4 mr-2" />
                  Add Feature
                </Button>
              </div>
              <div className="space-y-2">
                {formData.features.map((feature, index) => (
                  <div key={index} className="flex items-center space-x-2">
                    <Input
                      value={feature}
                      onChange={(e) => handleFeatureChange(index, e.target.value)}
                      placeholder="Feature description"
                      className="glass border-glass-border"
                    />
                    <Button
                      type="button"
                      variant="outline"
                      size="sm"
                      onClick={() => removeFeature(index)}
                      className="text-destructive hover:bg-destructive hover:text-destructive-foreground"
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </div>
                ))}
              </div>
            </div>

            {/* Add-ons */}
            <div>
              <div className="flex items-center justify-between mb-3">
                <label className="block text-sm font-medium">Add-ons</label>
                <Button type="button" variant="outline" size="sm" onClick={addAddOn}>
                  <Plus className="w-4 h-4 mr-2" />
                  Add Add-on
                </Button>
              </div>
              <div className="space-y-2">
                {formData.addOns.map((addOn, index) => (
                  <div key={index} className="flex items-center space-x-2">
                    <Input
                      value={addOn.name}
                      onChange={(e) => handleAddOnChange(index, 'name', e.target.value)}
                      placeholder="Add-on name"
                      className="flex-1 glass border-glass-border"
                    />
                    <Input
                      type="number"
                      min="0"
                      step="0.01"
                      value={addOn.price}
                      onChange={(e) => handleAddOnChange(index, 'price', parseFloat(e.target.value) || 0)}
                      placeholder="Price"
                      className="w-24 glass border-glass-border"
                    />
                    <Button
                      type="button"
                      variant="outline"
                      size="sm"
                      onClick={() => removeAddOn(index)}
                      className="text-destructive hover:bg-destructive hover:text-destructive-foreground"
                    >
                      <Trash2 className="w-4 h-4" />
                    </Button>
                  </div>
                ))}
              </div>
            </div>

            {/* Action Buttons */}
            <div className="flex justify-end space-x-3 pt-4">
              <Button type="button" variant="outline" onClick={onCancel}>
                Cancel
              </Button>
              <Button type="submit" className="btn-premium text-primary-foreground">
                {product ? 'Update Product' : 'Create Product'}
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
};

export default ProductForm; 