import React, { createContext, useContext, useState, ReactNode } from 'react';

// Types for our rental application
export interface Product {
  id: string;
  name: string;
  category: string;
  description: string;
  image: string;
  pricePerHour: number;
  pricePerDay: number;
  pricePerWeek: number;
  availability: 'available' | 'booked';
  features: string[];
  addOns: AddOn[];
}

export interface AddOn {
  id: string;
  name: string;
  price: number;
}

export interface CartItem {
  product: Product;
  quantity: number;
  duration: number;
  durationType: 'hour' | 'day' | 'week';
  selectedAddOns: AddOn[];
  startDate: Date;
  endDate: Date;
}

export interface User {
  id: string;
  name: string;
  email: string;
  role: 'customer' | 'admin';
}

interface AppContextType {
  // User & Auth
  user: User | null;
  setUser: (user: User | null) => void;
  
  // Cart Management
  cart: CartItem[];
  addToCart: (item: CartItem) => void;
  removeFromCart: (productId: string) => void;
  updateCartItem: (productId: string, updates: Partial<CartItem>) => void;
  clearCart: () => void;
  getCartTotal: () => number;
  
  // Products
  products: Product[];
  
  // Navigation
  currentPage: string;
  setCurrentPage: (page: string) => void;
}

const AppContext = createContext<AppContextType | undefined>(undefined);

// Mock data
const mockProducts: Product[] = [
  {
    id: '1',
    name: 'Professional Camera Kit',
    category: 'Photography',
    description: 'High-end DSLR camera with multiple lenses and accessories',
    image: '/placeholder-camera.jpg',
    pricePerHour: 25,
    pricePerDay: 150,
    pricePerWeek: 900,
    availability: 'available',
    features: ['4K Video', 'Multiple Lenses', 'Tripod Included'],
    addOns: [
      { id: 'a1', name: 'Extra Battery', price: 15 },
      { id: 'a2', name: 'Memory Card 64GB', price: 20 }
    ]
  },
  {
    id: '2',
    name: 'MacBook Pro 16"',
    category: 'Technology',
    description: 'Latest MacBook Pro with M3 chip for professional work',
    image: '/placeholder-laptop.jpg',
    pricePerHour: 15,
    pricePerDay: 80,
    pricePerWeek: 500,
    availability: 'available',
    features: ['M3 Chip', '32GB RAM', '1TB SSD'],
    addOns: [
      { id: 'a3', name: 'External Monitor', price: 30 },
      { id: 'a4', name: 'Wireless Mouse', price: 10 }
    ]
  },
  {
    id: '3',
    name: 'Power Drill Set',
    category: 'Tools',
    description: 'Professional cordless drill with complete bit set',
    image: '/placeholder-drill.jpg',
    pricePerHour: 8,
    pricePerDay: 35,
    pricePerWeek: 200,
    availability: 'booked',
    features: ['Cordless', 'Multiple Bits', 'Case Included'],
    addOns: [
      { id: 'a5', name: 'Extra Battery Pack', price: 25 }
    ]
  },
  {
    id: '4',
    name: 'Conference Table',
    category: 'Furniture',
    description: 'Modern glass conference table for 8 people',
    image: '/placeholder-table.jpg',
    pricePerHour: 12,
    pricePerDay: 60,
    pricePerWeek: 350,
    availability: 'available',
    features: ['Glass Top', 'Seats 8', 'Modern Design'],
    addOns: [
      { id: 'a6', name: 'Chair Set (8)', price: 40 }
    ]
  }
];

export const AppProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [cart, setCart] = useState<CartItem[]>([]);
  const [currentPage, setCurrentPage] = useState('login');
  const [products] = useState<Product[]>(mockProducts);

  const addToCart = (item: CartItem) => {
    setCart(prev => [...prev, item]);
  };

  const removeFromCart = (productId: string) => {
    setCart(prev => prev.filter(item => item.product.id !== productId));
  };

  const updateCartItem = (productId: string, updates: Partial<CartItem>) => {
    setCart(prev => prev.map(item => 
      item.product.id === productId ? { ...item, ...updates } : item
    ));
  };

  const clearCart = () => {
    setCart([]);
  };

  const getCartTotal = (): number => {
    return cart.reduce((total, item) => {
      const basePrice = item.durationType === 'hour' 
        ? item.product.pricePerHour 
        : item.durationType === 'day' 
        ? item.product.pricePerDay 
        : item.product.pricePerWeek;
      
      const addOnTotal = item.selectedAddOns.reduce((sum, addOn) => sum + addOn.price, 0);
      return total + (basePrice * item.quantity * item.duration) + (addOnTotal * item.quantity);
    }, 0);
  };

  const value: AppContextType = {
    user,
    setUser,
    cart,
    addToCart,
    removeFromCart,
    updateCartItem,
    clearCart,
    getCartTotal,
    products,
    currentPage,
    setCurrentPage
  };

  return (
    <AppContext.Provider value={value}>
      {children}
    </AppContext.Provider>
  );
};

export const useAppContext = () => {
  const context = useContext(AppContext);
  if (context === undefined) {
    throw new Error('useAppContext must be used within an AppProvider');
  }
  return context;
};