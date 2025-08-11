import React, { useState } from 'react';
import { User, Mail, Lock } from 'lucide-react';
import { useAppContext } from '../context/AppContext';
import { Button } from '../components/ui/button';
import { Input } from '../components/ui/input';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import { toast } from '../hooks/use-toast';

const Signup: React.FC = () => {
  const { setUser, setCurrentPage } = useAppContext();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!name.trim()) {
      toast({ title: 'Please enter your name' });
      return;
    }
    if (!email.trim()) {
      toast({ title: 'Please enter your email' });
      return;
    }
    if (password.length < 6) {
      toast({ title: 'Password must be at least 6 characters' });
      return;
    }
    if (password !== confirmPassword) {
      toast({ title: 'Passwords do not match' });
      return;
    }

    setIsSubmitting(true);
    try {
      // Mock signup: immediately create a user and log in
      const newUser = {
        id: Date.now().toString(),
        name: name.trim(),
        email: email.trim(),
        role: 'customer' as const,
      };

      setUser(newUser);
      toast({ title: 'Account created', description: 'Welcome to FlexiRent!' });
      setCurrentPage('marketplace');
    } finally {
      setIsSubmitting(false);
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
              <CardTitle className="text-2xl font-bold">Create your account</CardTitle>
              <CardDescription>Join FlexiRent to start renting premium items</CardDescription>
            </div>
          </CardHeader>

          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="space-y-2">
                <label className="text-sm font-medium">Full Name</label>
                <div className="relative">
                  <User className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <Input
                    required
                    placeholder="John Doe"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    className="pl-10 glass border-glass-border"
                  />
                </div>
              </div>

              <div className="space-y-2">
                <label className="text-sm font-medium">Email</label>
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <Input
                    type="email"
                    required
                    placeholder="you@example.com"
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
                    required
                    placeholder="••••••••"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="pl-10 glass border-glass-border"
                  />
                </div>
              </div>

              <div className="space-y-2">
                <label className="text-sm font-medium">Confirm Password</label>
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <Input
                    type="password"
                    required
                    placeholder="••••••••"
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    className="pl-10 glass border-glass-border"
                  />
                </div>
              </div>

              <Button type="submit" disabled={isSubmitting} className="w-full btn-premium text-primary-foreground">
                {isSubmitting ? 'Creating account...' : 'Create Account'}
              </Button>
            </form>

            <div className="mt-6 text-center text-sm text-muted-foreground">
              Already have an account?{' '}
              <button
                type="button"
                onClick={() => setCurrentPage('login')}
                className="underline underline-offset-4 hover:text-foreground"
              >
                Log in
              </button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default Signup; 