import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/avatar_selection_modal.dart';
import './widgets/logout_confirmation_dialog.dart';
import './widgets/password_change_modal.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 3; // Profile tab active
  bool _isDarkMode = true;
  bool _biometricEnabled = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  String _sessionTimeout = '30 minutes';
  String _textSize = 'Medium';

  // Mock admin data
  final Map<String, dynamic> adminData = {
    "name": "Sarah Johnson",
    "email": "sarah.johnson@flexirent.com",
    "role": "Super Admin",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
    "company": "FlexiRent Solutions",
    "permissions": [
      "Full Access",
      "User Management",
      "Analytics",
      "System Settings"
    ],
    "joinDate": "January 2022",
    "lastLogin": "Today at 9:30 AM",
    "activeDevices": 3,
  };

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard-screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/orders-management-screen');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/products-management-screen');
        break;
      case 3:
        // Already on profile screen
        break;
    }
  }

  void _showPasswordChangeModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PasswordChangeModal(),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => LogoutConfirmationDialog(
        onConfirm: _performLogout,
      ),
    );
  }

  void _performLogout() {
    // Clear user session and navigate to login
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login-screen',
      (route) => false,
    );
  }

  void _showAvatarSelection() {
    showDialog(
      context: context,
      builder: (context) => AvatarSelectionModal(
        onImageSelected: (imagePath) {
          setState(() {
            // Update avatar URL with new image path
            adminData["avatar"] = imagePath;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile photo updated successfully'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        },
      ),
    );
  }

  void _showSessionTimeoutOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Session Timeout',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 3.h),
              ...['15 minutes', '30 minutes', '1 hour', '2 hours', 'Never'].map(
                (timeout) => ListTile(
                  title: Text(
                    timeout,
                    style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  trailing: _sessionTimeout == timeout
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.accentColor,
                          size: 5.w,
                        )
                      : null,
                  onTap: () {
                    setState(() => _sessionTimeout = timeout);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTextSizeOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Text Size',
                style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 3.h),
              ...['Small', 'Medium', 'Large', 'Extra Large'].map(
                (size) => ListTile(
                  title: Text(
                    size,
                    style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  trailing: _textSize == size
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.accentColor,
                          size: 5.w,
                        )
                      : null,
                  onTap: () {
                    setState(() => _textSize = size);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Export Data',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Select the data you want to export for compliance purposes.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Data export initiated. You will receive an email when ready.'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeaderWidget(
                adminName: adminData["name"] as String,
                adminEmail: adminData["email"] as String,
                adminRole: adminData["role"] as String,
                avatarUrl: adminData["avatar"] as String,
                onAvatarTap: _showAvatarSelection,
              ),
              SizedBox(height: 2.h),

              // Account Section
              SettingsSectionWidget(
                title: 'Account',
                children: [
                  SettingsItemWidget(
                    iconName: 'person',
                    title: 'Personal Information',
                    subtitle: 'Update your profile details',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Personal information editing coming soon')),
                      );
                    },
                  ),
                  SettingsItemWidget(
                    iconName: 'lock',
                    title: 'Change Password',
                    subtitle: 'Update your account password',
                    onTap: _showPasswordChangeModal,
                  ),
                  SettingsItemWidget(
                    iconName: 'notifications',
                    title: 'Email Notifications',
                    trailing: Switch(
                      value: _emailNotifications,
                      onChanged: (value) =>
                          setState(() => _emailNotifications = value),
                      activeColor: AppTheme.accentColor,
                    ),
                  ),
                  SettingsItemWidget(
                    iconName: 'notifications_active',
                    title: 'Push Notifications',
                    trailing: Switch(
                      value: _pushNotifications,
                      onChanged: (value) =>
                          setState(() => _pushNotifications = value),
                      activeColor: AppTheme.accentColor,
                    ),
                  ),
                ],
              ),

              // Security Section
              SettingsSectionWidget(
                title: 'Security',
                children: [
                  SettingsItemWidget(
                    iconName: 'fingerprint',
                    title: 'Biometric Authentication',
                    subtitle: 'Use Face ID or Fingerprint',
                    trailing: Switch(
                      value: _biometricEnabled,
                      onChanged: (value) =>
                          setState(() => _biometricEnabled = value),
                      activeColor: AppTheme.accentColor,
                    ),
                  ),
                  SettingsItemWidget(
                    iconName: 'timer',
                    title: 'Session Timeout',
                    subtitle: _sessionTimeout,
                    onTap: _showSessionTimeoutOptions,
                  ),
                  SettingsItemWidget(
                    iconName: 'devices',
                    title: 'Active Devices',
                    subtitle: '${adminData["activeDevices"]} devices logged in',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Device management coming soon')),
                      );
                    },
                  ),
                ],
              ),

              // Appearance Section
              SettingsSectionWidget(
                title: 'Appearance',
                children: [
                  SettingsItemWidget(
                    iconName: 'dark_mode',
                    title: 'Dark Mode',
                    subtitle: 'Use dark theme',
                    trailing: Switch(
                      value: _isDarkMode,
                      onChanged: (value) => setState(() => _isDarkMode = value),
                      activeColor: AppTheme.accentColor,
                    ),
                  ),
                  SettingsItemWidget(
                    iconName: 'text_fields',
                    title: 'Text Size',
                    subtitle: _textSize,
                    onTap: _showTextSizeOptions,
                  ),
                  SettingsItemWidget(
                    iconName: 'accessibility',
                    title: 'Accessibility',
                    subtitle: 'High contrast, screen reader',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Accessibility settings coming soon')),
                      );
                    },
                  ),
                ],
              ),

              // Business Section
              SettingsSectionWidget(
                title: 'Business',
                children: [
                  SettingsItemWidget(
                    iconName: 'business',
                    title: 'Company Information',
                    subtitle: adminData["company"] as String,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Company information is read-only')),
                      );
                    },
                  ),
                  SettingsItemWidget(
                    iconName: 'admin_panel_settings',
                    title: 'Admin Permissions',
                    subtitle:
                        '${(adminData["permissions"] as List).length} permissions active',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Permission details coming soon')),
                      );
                    },
                  ),
                  SettingsItemWidget(
                    iconName: 'download',
                    title: 'Export Data',
                    subtitle: 'Download your data for compliance',
                    onTap: _exportData,
                  ),
                ],
              ),

              // Support Section
              SettingsSectionWidget(
                title: 'Support',
                children: [
                  SettingsItemWidget(
                    iconName: 'help',
                    title: 'Help & Documentation',
                    subtitle: 'User guides and FAQs',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Help documentation coming soon')),
                      );
                    },
                  ),
                  SettingsItemWidget(
                    iconName: 'contact_support',
                    title: 'Contact Support',
                    subtitle: 'Get help from our team',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Support contact coming soon')),
                      );
                    },
                  ),
                  SettingsItemWidget(
                    iconName: 'info',
                    title: 'App Version',
                    subtitle: 'FlexiRent Admin v1.0.0',
                  ),
                ],
              ),

              // Logout Section
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showLogoutConfirmation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      foregroundColor: AppTheme.textPrimary,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: CustomIconWidget(
                      iconName: 'logout',
                      color: AppTheme.textPrimary,
                      size: 5.w,
                    ),
                    label: Text(
                      'Logout',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.darkTheme.colorScheme.surface,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: AppTheme.textSecondary,
        selectedLabelStyle: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.darkTheme.textTheme.labelSmall,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentIndex == 0
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 6.w,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'shopping_cart',
              color: _currentIndex == 1
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 6.w,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'inventory',
              color: _currentIndex == 2
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 6.w,
            ),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.accentColor
                  : AppTheme.textSecondary,
              size: 6.w,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
