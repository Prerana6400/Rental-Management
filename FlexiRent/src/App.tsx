import React from 'react';
import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { AppProvider, useAppContext } from './context/AppContext';
import Navigation from './components/Navigation';
import Login from './pages/Login';
import Marketplace from './pages/Marketplace';
import ProductDetail from './pages/ProductDetail';
import Cart from './pages/Cart';
import Checkout from './pages/Checkout';
import OrderConfirmation from './pages/OrderConfirmation';
import Signup from './pages/Signup';
import CustomerPortal from './pages/CustomerPortal';
import AdminDashboard from './pages/AdminDashboard';

const queryClient = new QueryClient();

const AppContent: React.FC = () => {
  const { currentPage } = useAppContext();
  
  const renderPage = () => {
    if (currentPage.startsWith('product-')) {
      const productId = currentPage.split('-')[1];
      return <ProductDetail productId={productId} />;
    }
    
    switch (currentPage) {
      case 'login':
        return <Login />;
      case 'signup':
        return <Signup />;
      case 'marketplace':
        return <Marketplace />;
      case 'cart':
        return <Cart />;
      case 'checkout':
        return <Checkout />;
      case 'order-confirmation':
        return <OrderConfirmation />;
      case 'customer-portal':
        return <CustomerPortal />;
      case 'admin-dashboard':
        return <AdminDashboard />;
      default:
        return <Login />;
    }
  };

  return (
    <div className="min-h-screen">
      {currentPage !== 'login' && currentPage !== 'signup' && <Navigation />}
      {renderPage()}
    </div>
  );
};

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <AppProvider>
        <AppContent />
      </AppProvider>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
