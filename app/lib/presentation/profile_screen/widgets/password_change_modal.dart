import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PasswordChangeModal extends StatefulWidget {
  const PasswordChangeModal({Key? key}) : super(key: key);

  @override
  State<PasswordChangeModal> createState() => _PasswordChangeModalState();
}

class _PasswordChangeModalState extends State<PasswordChangeModal> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  int _passwordStrength = 0;
  String _strengthText = '';
  Color _strengthColor = AppTheme.errorColor;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    final password = _newPasswordController.text;
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    setState(() {
      _passwordStrength = strength;
      switch (strength) {
        case 0:
        case 1:
          _strengthText = 'Weak';
          _strengthColor = AppTheme.errorColor;
          break;
        case 2:
        case 3:
          _strengthText = 'Medium';
          _strengthColor = AppTheme.warningColor;
          break;
        case 4:
        case 5:
          _strengthText = 'Strong';
          _strengthColor = AppTheme.successColor;
          break;
      }
    });
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password changed successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.darkTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 80.h),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.accentColor,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Change Password',
                    style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 5.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: !_isCurrentPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'lock_outline',
                          color: AppTheme.textSecondary,
                          size: 5.w,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() =>
                            _isCurrentPasswordVisible =
                                !_isCurrentPasswordVisible),
                        icon: CustomIconWidget(
                          iconName: _isCurrentPasswordVisible
                              ? 'visibility_off'
                              : 'visibility',
                          color: AppTheme.textSecondary,
                          size: 5.w,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      // Mock validation - in real app, verify with backend
                      if (value != 'admin123') {
                        return 'Current password is incorrect';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 2.h),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: !_isNewPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'lock',
                          color: AppTheme.textSecondary,
                          size: 5.w,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() =>
                            _isNewPasswordVisible = !_isNewPasswordVisible),
                        icon: CustomIconWidget(
                          iconName: _isNewPasswordVisible
                              ? 'visibility_off'
                              : 'visibility',
                          color: AppTheme.textSecondary,
                          size: 5.w,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (_passwordStrength < 3) {
                        return 'Password is too weak';
                      }
                      return null;
                    },
                  ),
                  if (_newPasswordController.text.isNotEmpty) ...[
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: _passwordStrength / 5,
                            backgroundColor: AppTheme.dividerSubtle,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(_strengthColor),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          _strengthText,
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: _strengthColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 2.h),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm New Password',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'lock',
                          color: AppTheme.textSecondary,
                          size: 5.w,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() =>
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible),
                        icon: CustomIconWidget(
                          iconName: _isConfirmPasswordVisible
                              ? 'visibility_off'
                              : 'visibility',
                          color: AppTheme.textSecondary,
                          size: 5.w,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _isLoading ? null : () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    child: _isLoading
                        ? SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.darkTheme.colorScheme.onPrimary),
                            ),
                          )
                        : Text('Change Password'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
