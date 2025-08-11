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
  createdAt: Date;
  lastLogin?: Date;
}

// New rental types
export interface Rental {
  id: string;
  items: CartItem[];
  paymentMode: 'full' | 'deposit';
  subtotal: number;
  serviceFee: number;
  tax: number;
  total: number;
  createdAt: Date;
  status: 'upcoming' | 'active' | 'completed' | 'cancelled';
  customerId: string;
  customerName: string;
  customerEmail: string;
}

// New quotation types
export interface Quotation {
  id: string;
  customerId: string;
  customerName: string;
  customerEmail: string;
  items: CartItem[];
  subtotal: number;
  serviceFee: number;
  tax: number;
  total: number;
  createdAt: Date;
  status: 'pending' | 'accepted' | 'rejected' | 'expired';
  validUntil: Date;
}

// Admin-specific types
export interface AdminStats {
  totalRentals: number;
  totalRevenue: number;
  activeRentals: number;
  totalCustomers: number;
  monthlyRevenue: number;
  popularCategories: { category: string; count: number; revenue: number }[];
  topProducts: { product: string; ordered: number; revenue: number }[];
  topCustomers: { customer: string; ordered: number; revenue: number }[];
  totalQuotations: number;
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
  addProduct: (product: Omit<Product, 'id'>) => void;
  updateProduct: (id: string, updates: Partial<Product>) => void;
  deleteProduct: (id: string) => void;
  toggleProductAvailability: (id: string) => void;
  
  // Rentals
  rentals: Rental[];
  placeOrder: (paymentMode: 'full' | 'deposit') => Rental;
  updateRentalStatus: (id: string, status: Rental['status']) => void;
  
  // Quotations
  quotations: Quotation[];
  createQuotation: (customerId: string, items: CartItem[]) => Quotation;
  updateQuotationStatus: (id: string, status: Quotation['status']) => void;
  
  // Users (for admin)
  users: User[];
  addUser: (user: Omit<User, 'id' | 'createdAt'>) => void;
  updateUser: (id: string, updates: Partial<User>) => void;
  deleteUser: (id: string) => void;
  
  // Admin Stats
  getAdminStats: () => AdminStats;

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
  },
  {
    id: '5',
    name: 'Wheelchair',
    category: 'Medical',
    description: 'Comfortable wheelchair for mobility assistance',
    image: '/placeholder-wheelchair.jpg',
    pricePerHour: 8,
    pricePerDay: 45,
    pricePerWeek: 280,
    availability: 'available',
    features: ['Adjustable', 'Lightweight', 'Foldable'],
    addOns: [
      { id: 'a7', name: 'Cushion', price: 12 }
    ]
  },
  {
    id: '6',
    name: 'Office Chair',
    category: 'Furniture',
    description: 'Ergonomic office chair with lumbar support',
    image: '/placeholder-chair.jpg',
    pricePerHour: 5,
    pricePerDay: 25,
    pricePerWeek: 150,
    availability: 'available',
    features: ['Ergonomic', 'Adjustable Height', 'Swivel'],
    addOns: [
      { id: 'a8', name: 'Footrest', price: 8 }
    ]
  }
];

// Mock users
const mockUsers: User[] = [
  {
    id: '1',
    name: 'Admin User',
    email: 'admin@flexirent.com',
    role: 'admin',
    createdAt: new Date('2024-01-01'),
    lastLogin: new Date()
  },
  {
    id: '2',
    name: 'John Customer',
    email: 'john@example.com',
    role: 'customer',
    createdAt: new Date('2024-01-15'),
    lastLogin: new Date(Date.now() - 86400000)
  },
  {
    id: '3',
    name: 'Sarah Smith',
    email: 'sarah@example.com',
    role: 'customer',
    createdAt: new Date('2024-02-01'),
    lastLogin: new Date(Date.now() - 172800000)
  },
  {
    id: '4',
    name: 'Mike Johnson',
    email: 'mike@example.com',
    role: 'customer',
    createdAt: new Date('2024-02-15'),
    lastLogin: new Date(Date.now() - 259200000)
  }
];

// Mock quotations
const mockQuotations: Quotation[] = [
  {
    id: 'Q-001',
    customerId: '2',
    customerName: 'John Customer',
    customerEmail: 'john@example.com',
    items: [mockProducts[0], mockProducts[1]].map(product => ({
      product,
      quantity: 1,
      duration: 2,
      durationType: 'day' as const,
      selectedAddOns: [],
      startDate: new Date(),
      endDate: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000)
    })),
    subtotal: 460,
    serviceFee: 23,
    tax: 37,
    total: 520,
    createdAt: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000),
    status: 'pending',
    validUntil: new Date(Date.now() + 5 * 24 * 60 * 60 * 1000)
  },
  {
    id: 'Q-002',
    customerId: '3',
    customerName: 'Sarah Smith',
    customerEmail: 'sarah@example.com',
    items: [mockProducts[4]].map(product => ({
      product,
      quantity: 1,
      duration: 1,
      durationType: 'week' as const,
      selectedAddOns: [],
      startDate: new Date(),
      endDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
    })),
    subtotal: 280,
    serviceFee: 14,
    tax: 22,
    total: 316,
    createdAt: new Date(Date.now() - 1 * 24 * 60 * 60 * 1000),
    status: 'accepted',
    validUntil: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000)
  }
];

export const AppProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [cart, setCart] = useState<CartItem[]>([]);
  const [currentPage, setCurrentPage] = useState('login');
  const [products, setProducts] = useState<Product[]>(mockProducts);
  const [rentals, setRentals] = useState<Rental[]>([]);
  const [users, setUsers] = useState<User[]>(mockUsers);
  const [quotations, setQuotations] = useState<Quotation[]>(mockQuotations);

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

  // Create a rental from current cart and persist it in context
  const placeOrder = (paymentMode: 'full' | 'deposit'): Rental => {
    const subtotal = getCartTotal();
    const serviceFee = Math.round(subtotal * 0.05);
    const tax = Math.round(subtotal * 0.08);
    const total = Math.round(subtotal * 1.13);

    const newRental: Rental = {
      id: `FR-${Date.now().toString().slice(-6)}`,
      items: cart,
      paymentMode,
      subtotal,
      serviceFee,
      tax,
      total,
      createdAt: new Date(),
      status: 'upcoming',
      customerId: user?.id || 'unknown',
      customerName: user?.name || 'Unknown',
      customerEmail: user?.email || 'unknown@example.com'
    };

    setRentals(prev => [newRental, ...prev]);
    clearCart();
    return newRental;
  };

  // Product management functions
  const addProduct = (product: Omit<Product, 'id'>) => {
    const newProduct: Product = {
      ...product,
      id: Date.now().toString()
    };
    setProducts(prev => [...prev, newProduct]);
  };

  const updateProduct = (id: string, updates: Partial<Product>) => {
    setProducts(prev => prev.map(product => 
      product.id === id ? { ...product, ...updates } : product
    ));
  };

  const deleteProduct = (id: string) => {
    setProducts(prev => prev.filter(product => product.id !== id));
  };

  const toggleProductAvailability = (id: string) => {
    setProducts(prev => prev.map(product => 
      product.id === id 
        ? { ...product, availability: product.availability === 'available' ? 'booked' : 'available' }
        : product
    ));
  };

  // Rental management functions
  const updateRentalStatus = (id: string, status: Rental['status']) => {
    setRentals(prev => prev.map(rental => 
      rental.id === id ? { ...rental, status } : rental
    ));
  };

  // Quotation management functions
  const createQuotation = (customerId: string, items: CartItem[]): Quotation => {
    const subtotal = items.reduce((total, item) => {
      const basePrice = item.durationType === 'hour' 
        ? item.product.pricePerHour 
        : item.durationType === 'day' 
        ? item.product.pricePerDay 
        : item.product.pricePerWeek;
      
      const addOnTotal = item.selectedAddOns.reduce((sum, addOn) => sum + addOn.price, 0);
      return total + (basePrice * item.quantity * item.duration) + (addOnTotal * item.quantity);
    }, 0);

    const serviceFee = Math.round(subtotal * 0.05);
    const tax = Math.round(subtotal * 0.08);
    const total = subtotal + serviceFee + tax;

    const customer = users.find(u => u.id === customerId);
    
    const newQuotation: Quotation = {
      id: `Q-${Date.now().toString().slice(-6)}`,
      customerId,
      customerName: customer?.name || 'Unknown',
      customerEmail: customer?.email || 'unknown@example.com',
      items,
      subtotal,
      serviceFee,
      tax,
      total,
      createdAt: new Date(),
      status: 'pending',
      validUntil: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) // 7 days validity
    };

    setQuotations(prev => [newQuotation, ...prev]);
    return newQuotation;
  };

  const updateQuotationStatus = (id: string, status: Quotation['status']) => {
    setQuotations(prev => prev.map(quotation => 
      quotation.id === id ? { ...quotation, status } : quotation
    ));
  };

  // User management functions
  const addUser = (userData: Omit<User, 'id' | 'createdAt'>) => {
    const newUser: User = {
      ...userData,
      id: Date.now().toString(),
      createdAt: new Date()
    };
    setUsers(prev => [...prev, newUser]);
  };

  const updateUser = (id: string, updates: Partial<User>) => {
    setUsers(prev => prev.map(user => 
      user.id === id ? { ...user, ...updates } : user
    ));
  };

  const deleteUser = (id: string) => {
    setUsers(prev => prev.filter(user => user.id !== id));
  };

  // Admin statistics
  const getAdminStats = (): AdminStats => {
    const totalRentals = rentals.length;
    const totalRevenue = rentals.reduce((sum, rental) => sum + rental.total, 0);
    const activeRentals = rentals.filter(rental => 
      rental.status === 'upcoming' || rental.status === 'active'
    ).length;
    const totalCustomers = users.filter(user => user.role === 'customer').length;
    const totalQuotations = quotations.length;
    
    // Calculate monthly revenue (last 30 days)
    const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
    const monthlyRevenue = rentals
      .filter(rental => rental.createdAt > thirtyDaysAgo)
      .reduce((sum, rental) => sum + rental.total, 0);

    // Popular categories with revenue
    const categoryData: { [key: string]: { count: number; revenue: number } } = {};
    rentals.forEach(rental => {
      rental.items.forEach(item => {
        const category = item.product.category;
        if (!categoryData[category]) {
          categoryData[category] = { count: 0, revenue: 0 };
        }
        categoryData[category].count += 1;
        categoryData[category].revenue += item.product.pricePerDay * item.duration * item.quantity;
      });
    });
    
    const popularCategories = Object.entries(categoryData)
      .map(([category, data]) => ({ 
        category, 
        count: data.count, 
        revenue: Math.round(data.revenue) 
      }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 5);

    // Top products
    const productData: { [key: string]: { ordered: number; revenue: number } } = {};
    rentals.forEach(rental => {
      rental.items.forEach(item => {
        const productName = item.product.name;
        if (!productData[productName]) {
          productData[productName] = { ordered: 0, revenue: 0 };
        }
        productData[productName].ordered += item.quantity;
        productData[productName].revenue += item.product.pricePerDay * item.duration * item.quantity;
      });
    });
    
    const topProducts = Object.entries(productData)
      .map(([product, data]) => ({ 
        product, 
        ordered: data.ordered, 
        revenue: Math.round(data.revenue) 
      }))
      .sort((a, b) => b.revenue - a.revenue)
      .slice(0, 5);

    // Top customers
    const customerData: { [key: string]: { ordered: number; revenue: number } } = {};
    rentals.forEach(rental => {
      const customerName = rental.customerName;
      if (!customerData[customerName]) {
        customerData[customerName] = { ordered: 0, revenue: 0 };
      }
      customerData[customerName].ordered += 1;
      customerData[customerName].revenue += rental.total;
    });
    
    const topCustomers = Object.entries(customerData)
      .map(([customer, data]) => ({ 
        customer, 
        ordered: data.ordered, 
        revenue: Math.round(data.revenue) 
      }))
      .sort((a, b) => b.revenue - a.revenue)
      .slice(0, 5);

    return {
      totalRentals,
      totalRevenue,
      activeRentals,
      totalCustomers,
      monthlyRevenue,
      popularCategories,
      topProducts,
      topCustomers,
      totalQuotations
    };
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
    addProduct,
    updateProduct,
    deleteProduct,
    toggleProductAvailability,
    rentals,
    placeOrder,
    updateRentalStatus,
    quotations,
    createQuotation,
    updateQuotationStatus,
    users,
    addUser,
    updateUser,
    deleteUser,
    getAdminStats,
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