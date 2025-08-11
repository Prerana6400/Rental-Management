import React, { useState } from 'react';
import { 
  BarChart3, 
  Users, 
  Package, 
  DollarSign, 
  TrendingUp, 
  Calendar,
  Edit,
  Trash2,
  Plus,
  Eye,
  Search,
  Filter,
  Home,
  FileText,
  Settings,
  User
} from 'lucide-react';
import { useAppContext } from '../context/AppContext';
import { Button } from '../components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
import { Badge } from '../components/ui/badge';
import { Separator } from '../components/ui/separator';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '../components/ui/tabs';
import { Input } from '../components/ui/input';
import { toast } from '../hooks/use-toast';
import ProductForm from '../components/ProductForm';
import { Product } from '../context/AppContext';

const AdminDashboard: React.FC = () => {
  const { 
    rentals, 
    products, 
    users, 
    quotations,
    getAdminStats, 
    updateRentalStatus, 
    toggleProductAvailability,
    deleteProduct,
    deleteUser,
    addProduct,
    updateProduct,
    setCurrentPage 
  } = useAppContext();
  
  const [activeTab, setActiveTab] = useState('dashboard');
  const [showProductForm, setShowProductForm] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | undefined>();
  const [searchTerm, setSearchTerm] = useState('');
  const [timeFilter, setTimeFilter] = useState('30');
  const stats = getAdminStats();

  const handleRentalStatusUpdate = (rentalId: string, newStatus: string) => {
    updateRentalStatus(rentalId, newStatus as any);
    toast({
      title: "Status Updated",
      description: `Rental status changed to ${newStatus}`,
    });
  };

  const handleProductAvailabilityToggle = (productId: string) => {
    toggleProductAvailability(productId);
    toast({
      title: "Availability Updated",
      description: "Product availability toggled",
    });
  };

  const handleDeleteProduct = (productId: string) => {
    if (confirm('Are you sure you want to delete this product?')) {
      deleteProduct(productId);
      toast({
        title: "Product Deleted",
        description: "Product has been removed from inventory",
      });
    }
  };

  const handleDeleteUser = (userId: string) => {
    if (confirm('Are you sure you want to delete this user?')) {
      deleteUser(userId);
      toast({
        title: "User Deleted",
        description: "User account has been removed",
      });
    }
  };

  const handleAddProduct = () => {
    setEditingProduct(undefined);
    setShowProductForm(true);
  };

  const handleEditProduct = (product: Product) => {
    setEditingProduct(product);
    setShowProductForm(true);
  };

  const handleSaveProduct = (productData: Omit<Product, 'id'>) => {
    if (editingProduct) {
      updateProduct(editingProduct.id, productData);
      toast({
        title: "Product Updated",
        description: "Product has been updated successfully",
      });
    } else {
      addProduct(productData);
      toast({
        title: "Product Added",
        description: "New product has been added to inventory",
      });
    }
    setShowProductForm(false);
    setEditingProduct(undefined);
  };

  const handleCancelProductForm = () => {
    setShowProductForm(false);
    setEditingProduct(undefined);
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'upcoming': return 'bg-blue-100 text-blue-800';
      case 'active': return 'bg-green-100 text-green-800';
      case 'completed': return 'bg-gray-100 text-gray-800';
      case 'cancelled': return 'bg-red-100 text-red-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  const getQuotationStatusColor = (status: string) => {
    switch (status) {
      case 'pending': return 'bg-yellow-100 text-yellow-800';
      case 'accepted': return 'bg-green-100 text-green-800';
      case 'rejected': return 'bg-red-100 text-red-800';
      case 'expired': return 'bg-gray-100 text-gray-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  const navigationItems = [
    { id: 'dashboard', label: 'Dashboard', icon: Home },
    { id: 'rental', label: 'Rental', icon: Package },
    { id: 'order', label: 'Order', icon: FileText },
    { id: 'products', label: 'Products', icon: Package },
    { id: 'reporting', label: 'Reporting', icon: BarChart3 },
    { id: 'setting', label: 'Setting', icon: Settings },
  ];

  return (
    <div className="min-h-screen bg-gradient-hero">
      {/* Top Navigation Bar */}
      <nav className="glass border-b border-glass-border sticky top-0 z-50">
        <div className="container mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-8">
              <h1 className="text-2xl font-bold">1 Dashboard</h1>
              <div className="flex items-center space-x-2">
                {navigationItems.map(item => {
                  const Icon = item.icon;
                  return (
                    <button
                      key={item.id}
                      onClick={() => setActiveTab(item.id)}
                      className={`flex items-center space-x-2 px-4 py-2 rounded-lg transition-all duration-300 ${
                        activeTab === item.id
                          ? 'bg-primary text-primary-foreground shadow-elegant'
                          : 'text-muted-foreground hover:text-foreground hover:bg-muted'
                      }`}
                    >
                      <Icon className="w-4 h-4" />
                      <span className="font-medium">{item.label}</span>
                    </button>
                  );
                })}
              </div>
            </div>
            
            {/* User Profile */}
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-gradient-primary rounded-full flex items-center justify-center">
                <User className="w-4 h-4 text-white" />
              </div>
              <span className="font-medium">Adam</span>
            </div>
          </div>
        </div>
      </nav>

      <div className="container mx-auto px-6 py-8">
        {/* Search and Filter Section */}
        <div className="flex items-center justify-between mb-8">
          <div className="flex items-center space-x-4 flex-1 max-w-2xl">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-muted-foreground" />
              <Input
                type="text"
                placeholder="Search..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="pl-10 glass border-glass-border"
              />
            </div>
            <select
              value={timeFilter}
              onChange={(e) => setTimeFilter(e.target.value)}
              className="px-4 py-2 border border-glass-border rounded-lg bg-transparent"
            >
              <option value="7">Last 7 days</option>
              <option value="30">Last 30 days</option>
              <option value="90">Last 90 days</option>
            </select>
          </div>
          
          <Button 
            onClick={() => setCurrentPage('marketplace')}
            variant="outline"
            className="btn-glass border-glass-border"
          >
            <Eye className="w-4 h-4 mr-2" />
            View Marketplace
          </Button>
        </div>

        {/* KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <Card className="glass border-glass-border">
            <CardContent className="p-6">
              <div className="flex items-center space-x-4">
                <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                  <FileText className="w-6 h-6 text-blue-600" />
                </div>
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Quotations</p>
                  <p className="text-2xl font-bold">{stats.totalQuotations}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="glass border-glass-border">
            <CardContent className="p-6">
              <div className="flex items-center space-x-4">
                <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                  <Package className="w-6 h-6 text-green-600" />
                </div>
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Rentals</p>
                  <p className="text-2xl font-bold">{stats.totalRentals}</p>
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="glass border-glass-border">
            <CardContent className="p-6">
              <div className="flex items-center space-x-4">
                <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                  <DollarSign className="w-6 h-6 text-purple-600" />
                </div>
                <div>
                  <p className="text-sm font-medium text-muted-foreground">Revenue</p>
                  <p className="text-2xl font-bold">{stats.totalRevenue.toLocaleString()}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Data Tables Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Top Product Categories */}
          <Card className="glass border-glass-border">
            <CardHeader>
              <CardTitle>Top Product Categories</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div className="grid grid-cols-3 gap-4 text-sm font-medium text-muted-foreground pb-2 border-b">
                  <span>Category</span>
                  <span>Ordered</span>
                  <span>Revenue</span>
                </div>
                {stats.popularCategories.map((category, index) => (
                  <div key={index} className="grid grid-cols-3 gap-4 text-sm">
                    <span className="font-medium">{category.category}</span>
                    <span>{category.count}</span>
                    <span className="font-medium">${category.revenue.toLocaleString()}</span>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          {/* Top Products */}
          <Card className="glass border-glass-border">
            <CardHeader>
              <CardTitle>Top Products</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div className="grid grid-cols-3 gap-4 text-sm font-medium text-muted-foreground pb-2 border-b">
                  <span>Product</span>
                  <span>Ordered</span>
                  <span>Revenue</span>
                </div>
                {stats.topProducts.map((product, index) => (
                  <div key={index} className="grid grid-cols-3 gap-4 text-sm">
                    <span className="font-medium">{product.product}</span>
                    <span>{product.ordered}</span>
                    <span className="font-medium">${product.revenue.toLocaleString()}</span>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          {/* Recent Rentals */}
          <Card className="glass border-glass-border">
            <CardHeader>
              <CardTitle>Recent Rentals</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div className="grid grid-cols-3 gap-4 text-sm font-medium text-muted-foreground pb-2 border-b">
                  <span>Order</span>
                  <span>Ordered</span>
                  <span>Revenue</span>
                </div>
                {rentals.slice(0, 3).map(rental => (
                  <div key={rental.id} className="grid grid-cols-3 gap-4 text-sm">
                    <span className="font-medium">#{rental.id}</span>
                    <span>{rental.items.length}</span>
                    <span className="font-medium">${rental.total.toLocaleString()}</span>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          {/* Top Customers */}
          <Card className="glass border-glass-border">
            <CardHeader>
              <CardTitle>Top Customers</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                <div className="grid grid-cols-3 gap-4 text-sm font-medium text-muted-foreground pb-2 border-b">
                  <span>Customer</span>
                  <span>Ordered</span>
                  <span>Revenue</span>
                </div>
                {stats.topCustomers.map((customer, index) => (
                  <div key={index} className="grid grid-cols-3 gap-4 text-sm">
                    <span className="font-medium">{customer.customer}</span>
                    <span>{customer.ordered}</span>
                    <span className="font-medium">${customer.revenue.toLocaleString()}</span>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Additional Tabs for Detailed Management */}
        <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6 mt-8">
          <TabsContent value="rental" className="space-y-6">
            <Card className="glass border-glass-border">
              <CardHeader>
                <CardTitle>Rental Management</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {rentals.slice(0, 10).map(rental => (
                    <div key={rental.id} className="flex items-center justify-between p-4 border border-glass-border rounded-lg">
                      <div className="flex-1">
                        <div className="flex items-center space-x-4">
                          <div>
                            <p className="font-medium">#{rental.id}</p>
                            <p className="text-sm text-muted-foreground">{rental.customerName}</p>
                          </div>
                          <div>
                            <p className="text-sm">{rental.items.length} items</p>
                            <p className="text-sm text-muted-foreground">
                              {new Date(rental.createdAt).toLocaleDateString()}
                            </p>
                          </div>
                          <div>
                            <p className="font-medium">${rental.total}</p>
                            <p className="text-sm text-muted-foreground capitalize">{rental.paymentMode}</p>
                          </div>
                        </div>
                      </div>
                      <div className="flex items-center space-x-2">
                        <Badge className={getStatusColor(rental.status)}>
                          {rental.status}
                        </Badge>
                        <select
                          value={rental.status}
                          onChange={(e) => handleRentalStatusUpdate(rental.id, e.target.value)}
                          className="text-sm border border-glass-border rounded px-2 py-1 bg-transparent"
                        >
                          <option value="upcoming">Upcoming</option>
                          <option value="active">Active</option>
                          <option value="completed">Completed</option>
                          <option value="cancelled">Cancelled</option>
                        </select>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="order" className="space-y-6">
            <Card className="glass border-glass-border">
              <CardHeader>
                <CardTitle>Quotation Management</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {quotations.map(quotation => (
                    <div key={quotation.id} className="flex items-center justify-between p-4 border border-glass-border rounded-lg">
                      <div className="flex-1">
                        <div className="flex items-center space-x-4">
                          <div>
                            <p className="font-medium">#{quotation.id}</p>
                            <p className="text-sm text-muted-foreground">{quotation.customerName}</p>
                          </div>
                          <div>
                            <p className="text-sm">{quotation.items.length} items</p>
                            <p className="text-sm text-muted-foreground">
                              {new Date(quotation.createdAt).toLocaleDateString()}
                            </p>
                          </div>
                          <div>
                            <p className="font-medium">${quotation.total}</p>
                            <p className="text-sm text-muted-foreground">
                              Valid until {new Date(quotation.validUntil).toLocaleDateString()}
                            </p>
                          </div>
                        </div>
                      </div>
                      <Badge className={getQuotationStatusColor(quotation.status)}>
                        {quotation.status}
                      </Badge>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="products" className="space-y-6">
            <div className="flex justify-between items-center">
              <h2 className="text-2xl font-bold">Product Management</h2>
              <Button onClick={handleAddProduct} className="btn-premium text-primary-foreground">
                <Plus className="w-4 h-4 mr-2" />
                Add Product
              </Button>
            </div>

            <Card className="glass border-glass-border">
              <CardContent className="p-6">
                <div className="space-y-4">
                  {products.map(product => (
                    <div key={product.id} className="flex items-center justify-between p-4 border border-glass-border rounded-lg">
                      <div className="flex items-center space-x-4">
                        <div className="w-16 h-16 bg-gradient-accent opacity-20 rounded-lg flex items-center justify-center">
                          <span className="text-2xl">📦</span>
                        </div>
                        <div>
                          <h3 className="font-medium">{product.name}</h3>
                          <p className="text-sm text-muted-foreground">{product.category}</p>
                          <div className="flex space-x-2 mt-1">
                            <Badge variant="outline">${product.pricePerHour}/hr</Badge>
                            <Badge variant="outline">${product.pricePerDay}/day</Badge>
                            <Badge variant="outline">${product.pricePerWeek}/week</Badge>
                          </div>
                        </div>
                      </div>
                      <div className="flex items-center space-x-2">
                        <Badge className={product.availability === 'available' ? 'badge-available' : 'badge-booked'}>
                          {product.availability}
                        </Badge>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleEditProduct(product)}
                          className="btn-glass"
                        >
                          <Edit className="w-4 h-4" />
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleProductAvailabilityToggle(product.id)}
                          className="btn-glass"
                        >
                          Toggle
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleDeleteProduct(product.id)}
                          className="btn-glass text-destructive hover:bg-destructive hover:text-destructive-foreground"
                        >
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="reporting" className="space-y-6">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              <Card className="glass border-glass-border">
                <CardHeader>
                  <CardTitle className="flex items-center space-x-2">
                    <TrendingUp className="w-5 h-5" />
                    <span>Monthly Revenue</span>
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="text-3xl font-bold text-primary mb-2">
                    ${stats.monthlyRevenue.toLocaleString()}
                  </div>
                  <p className="text-sm text-muted-foreground">
                    Last {timeFilter} days
                  </p>
                </CardContent>
              </Card>

              <Card className="glass border-glass-border">
                <CardHeader>
                  <CardTitle>Customer Growth</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="text-3xl font-bold text-primary mb-2">
                    {stats.totalCustomers}
                  </div>
                  <p className="text-sm text-muted-foreground">
                    Total registered customers
                  </p>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          <TabsContent value="setting" className="space-y-6">
            <div className="flex justify-between items-center">
              <h2 className="text-2xl font-bold">User Management</h2>
              <Button className="btn-premium text-primary-foreground">
                <Plus className="w-4 h-4 mr-2" />
                Add User
              </Button>
            </div>

            <Card className="glass border-glass-border">
              <CardContent className="p-6">
                <div className="space-y-4">
                  {users.map(user => (
                    <div key={user.id} className="flex items-center justify-between p-4 border border-glass-border rounded-lg">
                      <div className="flex items-center space-x-4">
                        <div className="w-12 h-12 bg-gradient-primary rounded-full flex items-center justify-center text-white font-bold">
                          {user.name.charAt(0)}
                        </div>
                        <div>
                          <h3 className="font-medium">{user.name}</h3>
                          <p className="text-sm text-muted-foreground">{user.email}</p>
                          <div className="flex space-x-2 mt-1">
                            <Badge variant={user.role === 'admin' ? 'default' : 'secondary'}>
                              {user.role}
                            </Badge>
                            <Badge variant="outline">
                              Joined {new Date(user.createdAt).toLocaleDateString()}
                            </Badge>
                          </div>
                        </div>
                      </div>
                      <div className="flex items-center space-x-2">
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleDeleteUser(user.id)}
                          disabled={user.role === 'admin'}
                          className="btn-glass text-destructive hover:bg-destructive hover:text-destructive-foreground"
                        >
                          <Trash2 className="w-4 h-4" />
                        </Button>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>

        {/* Product Form Modal */}
        {showProductForm && (
          <ProductForm
            product={editingProduct}
            onSave={handleSaveProduct}
            onCancel={handleCancelProductForm}
          />
        )}
      </div>
    </div>
  );
};

export default AdminDashboard; 