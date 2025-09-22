import 'package:flutter/material.dart';
import 'package:thirdeye/sharable_widget/index.dart';
import 'package:thirdeye/config/app_theme.dart';

class EnhancedDemoScreen extends StatefulWidget {
  const EnhancedDemoScreen({super.key});

  @override
  State<EnhancedDemoScreen> createState() => _EnhancedDemoScreenState();
}

class _EnhancedDemoScreenState extends State<EnhancedDemoScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Widgets Demo'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Cards Demo
            Text(
              'Enhanced Cards',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Info Card
            InfoCard(
              title: 'User Profile',
              subtitle: 'John Doe • john@example.com',
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showSnackBar('Info card tapped'),
            ),

            // Stats Card
            StatsCard(
              title: 'Total Sessions',
              value: '24',
              subtitle: '+12% from last month',
              icon: Icons.trending_up,
              iconColor: AppTheme.successColor,
              onTap: () => _showSnackBar('Stats card tapped'),
            ),

            // Action Card
            ActionCard(
              title: 'Start Quiz',
              subtitle: 'Begin your wellness journey',
              icon: Icons.quiz,
              iconColor: AppTheme.secondaryColor,
              onTap: () => _showSnackBar('Action card tapped'),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Enhanced Input Fields Demo
            Text(
              'Enhanced Input Fields',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Email Input
            EmailInputField(
              controller: _emailController,
              onChanged: (value) => print('Email: $value'),
            ),

            const SizedBox(height: AppTheme.spacingM),

            // Password Input
            PasswordInputField(
              controller: _passwordController,
              onChanged: (value) => print('Password: $value'),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Enhanced Buttons Demo
            Text(
              'Enhanced Buttons',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Primary Button
            PrimaryButton(
              text: 'Primary Action',
              icon: Icons.check,
              onPressed: () => _showSnackBar('Primary button pressed'),
            ),

            const SizedBox(height: AppTheme.spacingM),

            // Secondary Button
            SecondaryButton(
              text: 'Secondary Action',
              onPressed: () => _showSnackBar('Secondary button pressed'),
            ),

            const SizedBox(height: AppTheme.spacingM),

            // Outline Button
            OutlineButton(
              text: 'Outline Action',
              onPressed: () => _showSnackBar('Outline button pressed'),
            ),

            const SizedBox(height: AppTheme.spacingM),

            // Gradient Button
            GradientButton(
              text: 'Gradient Action',
              icon: Icons.star,
              onPressed: () => _showSnackBar('Gradient button pressed'),
            ),

            const SizedBox(height: AppTheme.spacingM),

            // Loading Button
            PrimaryButton(
              text: 'Loading Button',
              isLoading: _isLoading,
              onPressed: () => _toggleLoading(),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Empty State Demo
            Text(
              'Empty States',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            // No Data Empty State
            NoDataEmptyState(
              message: 'No wellness data available yet.',
              actionText: 'Start Assessment',
              onActionPressed: () =>
                  _showSnackBar('Empty state action pressed'),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Feedback System Demo
            Text(
              'Feedback System',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            Wrap(
              spacing: AppTheme.spacingS,
              runSpacing: AppTheme.spacingS,
              children: [
                ElevatedButton(
                  onPressed: () => FeedbackSystem.showSuccessSnackBar(
                    context,
                    message: 'Operation completed successfully!',
                  ),
                  child: const Text('Success'),
                ),
                ElevatedButton(
                  onPressed: () => FeedbackSystem.showErrorSnackBar(
                    context,
                    message: 'Something went wrong!',
                  ),
                  child: const Text('Error'),
                ),
                ElevatedButton(
                  onPressed: () => FeedbackSystem.showInfoSnackBar(
                    context,
                    message: 'Here is some information.',
                  ),
                  child: const Text('Info'),
                ),
                ElevatedButton(
                  onPressed: () => FeedbackSystem.showWarningSnackBar(
                    context,
                    message: 'Please be careful!',
                  ),
                  child: const Text('Warning'),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Loading States Demo
            Text(
              'Loading States',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Skeleton List
            SkeletonListItem(),
            SkeletonListItem(),
            SkeletonListItem(),

            const SizedBox(height: AppTheme.spacingXL),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    FeedbackSystem.showInfoSnackBar(context, message: message);
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });

    // Auto stop loading after 3 seconds
    if (_isLoading) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showSnackBar('Loading completed!');
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
