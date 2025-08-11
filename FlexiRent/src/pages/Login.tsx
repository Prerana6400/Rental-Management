import React, { useState } from 'react';
import { User, Lock, UserCheck, AlertCircle } from 'lucide-react';
import { useAppContext } from '../context/AppContext';
import { Button } from '../components/ui/button';
import { Input } from '../components/ui/input';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '../components/ui/tabs';
import { Alert, AlertDescription } from '../components/ui/alert';
import apiService from '../services/api';

const Login: React.FC = () => {
  const { setUser, setCurrentPage } = useAppContext();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = async (email: string, password: string) => {
    if (!email || !password) {
      setError('Please enter both email and password');
      return;
    }

    setIsLoading(true);
    setError('');

    try {
      const response = await apiService.login({ email, password });
      
      if (response.success) {
        setUser(response.data.user);
        setCurrentPage('marketplace');
      } else {
        setError(response.message || 'Login failed');
      }
    } catch (error: any) {
      setError(error.message || 'Login failed. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-hero flex items-center justify-center p-6">
      <div className="w-full max-w-md animate-fade-up">
        <Card className="glass border-glass-border shadow-elegant">
          <CardHeader className="text-center space-y-4">
            <div className="w-16 h-16 bg-gradient-primary rounded-2xl flex items-center justify-center mx-auto animate-glow">
              <User className="w-8 h-8 text-white" />
            </div>
            <div>
              <CardTitle className="text-2xl font-bold">Welcome to FlexiRent</CardTitle>
              <CardDescription>Choose your login type to continue</CardDescription>
            </div>
          </CardHeader>

          <CardContent>
            <Tabs defaultValue="user" className="space-y-6">
              <TabsList className="grid w-full grid-cols-2 glass">
                <TabsTrigger value="user" className="flex items-center space-x-2">
                  <User className="w-4 h-4" />
                  <span>User</span>
                </TabsTrigger>
                <TabsTrigger value="admin" className="flex items-center space-x-2">
                  <UserCheck className="w-4 h-4" />
                  <span>Admin</span>
                </TabsTrigger>
              </TabsList>

              <TabsContent value="user" className="space-y-4">
                <div className="space-y-4">
                  <div className="space-y-2">
                    <label className="text-sm font-medium">Email</label>
                    <div className="relative">
                      <User className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                      <Input
                        type="email"
                        placeholder="user@flexirent.com"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        className="pl-10 glass border-glass-border"
                      />
                    </div>
                  </div>

                  <div className="space-y-2">
                    <label className="text-sm font-medium">Password</label>
                    <div className="relative">
                      <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                      <Input
                        type="password"
                        placeholder="••••••••"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        className="pl-10 glass border-glass-border"
                      />
                    </div>
                  </div>

                  <Button 
                    onClick={() => handleLogin(email, password)}
                    disabled={isLoading}
                    className="w-full btn-premium text-primary-foreground"
                  >
                    {isLoading ? 'Logging in...' : 'Login as User'}
                  </Button>
                </div>
              </TabsContent>

              <TabsContent value="admin" className="space-y-4">
                <div className="space-y-4">
                  <div className="space-y-2">
                    <label className="text-sm font-medium">Admin Email</label>
                    <div className="relative">
                      <UserCheck className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                      <Input
                        type="email"
                        placeholder="admin@flexirent.com"
                        value={email}
                        onChange={(e) => setEmail(e.target.value)}
                        className="pl-10 glass border-glass-border"
                      />
                    </div>
                  </div>

                  <div className="space-y-2">
                    <label className="text-sm font-medium">Admin Password</label>
                    <div className="relative">
                      <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                      <Input
                        type="password"
                        placeholder="••••••••"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        className="pl-10 glass border-glass-border"
                      />
                    </div>
                  </div>

                  <Button 
                    onClick={() => handleLogin(email, password)}
                    disabled={isLoading}
                    className="w-full bg-gradient-accent text-accent-foreground hover:shadow-hover"
                  >
                    {isLoading ? 'Logging in...' : 'Login as Admin'}
                  </Button>
                </div>
              </TabsContent>
            </Tabs>

            {error && (
              <Alert className="mt-4 border-red-200 bg-red-50">
                <AlertCircle className="h-4 w-4 text-red-600" />
                <AlertDescription className="text-red-800">
                  {error}
                </AlertDescription>
              </Alert>
            )}

            <div className="mt-6 text-center space-y-2">
              <p className="text-sm text-muted-foreground">
                Use the test credentials below to login
              </p>
              <div className="text-xs text-muted-foreground space-y-1">
                <p><strong>Admin:</strong> admin@flexirent.com / admin123</p>
                <p><strong>User:</strong> user@flexirent.com / password123</p>
              </div>
              <p className="text-sm text-muted-foreground">
                Don't have an account?{' '}
                <button
                  type="button"
                  onClick={() => setCurrentPage('signup')}
                  className="underline underline-offset-4 hover:text-foreground"
                >
                  Sign up
                </button>
              </p>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default Login;