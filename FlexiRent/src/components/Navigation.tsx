import React from 'react';
import { ShoppingCart, User, LogOut, Package, BarChart3 } from 'lucide-react';
import { useAppContext } from '../context/AppContext';
import { Button } from './ui/button';

const Navigation: React.FC = () => {
  const { user, setUser, cart, currentPage, setCurrentPage } = useAppContext();

  const handleLogout = () => {
    setUser(null);
    setCurrentPage('login');
  };

  const navigationItems = user?.role === 'admin' 
    ? [
        { id: 'marketplace', label: 'Marketplace', icon: Package },
        { id: 'admin-dashboard', label: 'Dashboard', icon: BarChart3 },
      ]
    : [
        { id: 'marketplace', label: 'Marketplace', icon: Package },
        { id: 'customer-portal', label: 'My Rentals', icon: User },
      ];

  return (
    <nav className="glass border-b border-glass-border sticky top-0 z-50">
      <div className="container mx-auto px-6 py-4">
        <div className="flex items-center justify-between">
          {/* Logo */}
          <div 
            className="flex items-center space-x-3 cursor-pointer"
            onClick={() => setCurrentPage('marketplace')}
          >
            <div className="w-10 h-10 bg-gradient-primary rounded-xl flex items-center justify-center">
              <Package className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-2xl font-bold bg-gradient-primary bg-clip-text text-transparent">
                FlexiRent
              </h1>
              <p className="text-xs text-muted-foreground">Premium Rentals</p>
            </div>
          </div>

          {/* Navigation Links */}
          {user && (
            <div className="hidden md:flex items-center space-x-6">
              {navigationItems.map(item => {
                const Icon = item.icon;
                return (
                  <button
                    key={item.id}
                    onClick={() => setCurrentPage(item.id)}
                    className={`flex items-center space-x-2 px-4 py-2 rounded-lg transition-all duration-300 ${
                      currentPage === item.id
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
          )}

          {/* Right Side Actions */}
          <div className="flex items-center space-x-4">
            {user ? (
              <>
                {/* Cart Button */}
                {user.role === 'customer' && (
                  <button
                    onClick={() => setCurrentPage('cart')}
                    className="relative btn-glass p-3 rounded-xl"
                  >
                    <ShoppingCart className="w-5 h-5" />
                    {cart.length > 0 && (
                      <span className="absolute -top-2 -right-2 bg-accent text-accent-foreground rounded-full w-6 h-6 text-xs flex items-center justify-center font-bold animate-bounce">
                        {cart.length}
                      </span>
                    )}
                  </button>
                )}

                {/* User Menu */}
                <div className="flex items-center space-x-3">
                  <div className="text-right hidden sm:block">
                    <p className="font-medium text-sm">{user.name}</p>
                    <p className="text-xs text-muted-foreground capitalize">{user.role}</p>
                  </div>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={handleLogout}
                    className="btn-glass border-glass-border"
                  >
                    <LogOut className="w-4 h-4 mr-2" />
                    Logout
                  </Button>
                </div>
              </>
            ) : (
              <div className="flex items-center gap-2">
                <Button
                  onClick={() => setCurrentPage('login')}
                  variant="outline"
                  className="btn-glass text-foreground border-glass-border"
                >
                  <User className="w-4 h-4 mr-2" />
                  Login
                </Button>
                <Button
                  onClick={() => setCurrentPage('signup')}
                  className="btn-premium text-primary-foreground"
                >
                  Create account
                </Button>
              </div>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
};

export default Navigation;