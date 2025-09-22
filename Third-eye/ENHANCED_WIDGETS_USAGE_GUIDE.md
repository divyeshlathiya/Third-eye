# Enhanced Widgets Usage Guide

## 🎨 How to Use Enhanced Widgets in Your ThirdEye App

### 1. **Import the Enhanced Widgets**

```dart
// Import all enhanced widgets at once
import 'package:thirdeye/sharable_widget/index.dart';

// Or import specific widgets
import 'package:thirdeye/sharable_widget/enhanced_button.dart';
import 'package:thirdeye/sharable_widget/enhanced_input_field.dart';
import 'package:thirdeye/sharable_widget/enhanced_card.dart';
import 'package:thirdeye/sharable_widget/loading_widgets.dart';
import 'package:thirdeye/sharable_widget/empty_state_widget.dart';
import 'package:thirdeye/sharable_widget/feedback_system.dart';

// Import the theme
import 'package:thirdeye/config/app_theme.dart';
```

### 2. **Enhanced Buttons**

Replace your existing buttons with enhanced versions:

```dart
// Instead of ElevatedButton
ElevatedButton(
  onPressed: () {},
  child: Text('Click me'),
)

// Use Enhanced Buttons
PrimaryButton(
  text: 'Click me',
  icon: Icons.check,
  onPressed: () {},
)

// Different button types
SecondaryButton(text: 'Secondary', onPressed: () {})
OutlineButton(text: 'Outline', onPressed: () {})
GradientButton(text: 'Gradient', onPressed: () {})

// With loading state
PrimaryButton(
  text: 'Loading...',
  isLoading: true,
  onPressed: () {},
)
```

### 3. **Enhanced Input Fields**

Replace your existing TextFormField:

```dart
// Instead of TextFormField
TextFormField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your email',
  ),
)

// Use Enhanced Input Fields
EmailInputField(
  controller: emailController,
  onChanged: (value) => print(value),
)

// Different input types
PasswordInputField(controller: passwordController)
PhoneInputField(controller: phoneController)
SearchInputField(controller: searchController)

// Custom input field
EnhancedInputField(
  label: 'Custom Field',
  hint: 'Enter custom text',
  prefixIcon: Icon(Icons.person),
  controller: customController,
)
```

### 4. **Enhanced Cards**

Replace your existing Card widgets:

```dart
// Instead of Card
Card(
  child: ListTile(
    title: Text('Title'),
    subtitle: Text('Subtitle'),
  ),
)

// Use Enhanced Cards
InfoCard(
  title: 'User Profile',
  subtitle: 'john@example.com',
  leading: CircleAvatar(child: Icon(Icons.person)),
  trailing: Icon(Icons.arrow_forward_ios),
  onTap: () => print('Card tapped'),
)

// Stats Card
StatsCard(
  title: 'Total Sessions',
  value: '24',
  subtitle: '+12% from last month',
  icon: Icons.trending_up,
  onTap: () => print('Stats tapped'),
)

// Action Card
ActionCard(
  title: 'Start Quiz',
  subtitle: 'Begin your journey',
  icon: Icons.quiz,
  onTap: () => print('Action tapped'),
)

// Custom Enhanced Card
EnhancedCard(
  child: Column(
    children: [
      Text('Custom Content'),
      // Your custom content here
    ],
  ),
  onTap: () => print('Custom card tapped'),
)
```

### 5. **Loading States**

Add loading states to improve user experience:

```dart
// Shimmer loading for cards
ShimmerLoader(
  child: Container(
    height: 120,
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)

// Skeleton loading for lists
SkeletonListItem()

// Loading spinner
LoadingSpinner(size: 32, strokeWidth: 3)

// Loading dots
LoadingDots()

// Loading overlay
LoadingOverlay(
  isLoading: isLoading,
  loadingText: 'Processing...',
  child: YourMainContent(),
)
```

### 6. **Empty States**

Show helpful empty states:

```dart
// No data empty state
NoDataEmptyState(
  message: 'No wellness data available yet.',
  actionText: 'Start Assessment',
  onActionPressed: () => startAssessment(),
)

// Error empty state
ErrorEmptyState(
  message: 'Failed to load data.',
  onRetry: () => retryLoading(),
)

// No internet empty state
NoInternetEmptyState(
  onRetry: () => checkConnection(),
)

// Search empty state
SearchEmptyState(
  query: searchQuery,
)
```

### 7. **Feedback System**

Replace your existing snackbars:

```dart
// Instead of ScaffoldMessenger
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Success!')),
)

// Use Enhanced Feedback System
FeedbackSystem.showSuccessSnackBar(
  context,
  message: 'Operation completed successfully!',
)

// Different feedback types
FeedbackSystem.showErrorSnackBar(context, message: 'Error occurred!')
FeedbackSystem.showInfoSnackBar(context, message: 'Information')
FeedbackSystem.showWarningSnackBar(context, message: 'Warning!')

// With action
FeedbackSystem.showSuccessSnackBar(
  context,
  message: 'File saved successfully!',
  actionLabel: 'Undo',
  onAction: () => undoAction(),
)

// Modern dialogs
FeedbackSystem.showModernDialog(
  context: context,
  title: 'Confirm Action',
  message: 'Are you sure you want to proceed?',
  confirmText: 'Yes',
  cancelText: 'No',
  onConfirm: () => proceed(),
)
```

### 8. **Theme Usage**

Use the app theme constants:

```dart
// Colors
Container(
  color: AppTheme.primaryColor,
  child: Text(
    'Hello',
    style: TextStyle(color: AppTheme.textPrimary),
  ),
)

// Spacing
Padding(
  padding: EdgeInsets.all(AppTheme.spacingM),
  child: Column(
    children: [
      Text('Item 1'),
      SizedBox(height: AppTheme.spacingL),
      Text('Item 2'),
    ],
  ),
)

// Border radius
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(AppTheme.radiusL),
  ),
)

// Shadows
Container(
  decoration: BoxDecoration(
    boxShadow: AppTheme.mediumShadow,
  ),
)

// Animations
AnimatedContainer(
  duration: AppTheme.animationMedium,
  // Your animation properties
)
```

### 9. **Integration Examples**

#### Login Form Enhancement:
```dart
class EnhancedLoginForm extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          children: [
            // Enhanced input fields
            EmailInputField(
              controller: emailController,
              validator: (value) => value?.isEmpty == true ? 'Required' : null,
            ),
            SizedBox(height: AppTheme.spacingM),
            PasswordInputField(
              controller: passwordController,
              validator: (value) => value?.isEmpty == true ? 'Required' : null,
            ),
            SizedBox(height: AppTheme.spacingXL),
            
            // Enhanced button with loading
            PrimaryButton(
              text: 'Sign In',
              isLoading: isLoading,
              onPressed: login,
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Dashboard Enhancement:
```dart
class EnhancedDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Stats cards
          StatsCard(
            title: 'Total Sessions',
            value: '24',
            subtitle: '+12% from last month',
            icon: Icons.trending_up,
          ),
          
          // Info cards
          InfoCard(
            title: 'Last Assessment',
            subtitle: 'Completed 2 days ago',
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => viewAssessment(),
          ),
          
          // Action cards
          ActionCard(
            title: 'Start New Quiz',
            subtitle: 'Begin your wellness journey',
            icon: Icons.quiz,
            onTap: () => startQuiz(),
          ),
        ],
      ),
    );
  }
}
```

### 10. **Best Practices**

1. **Consistent Imports**: Always import from the index file for consistency
2. **Theme Usage**: Use `AppTheme` constants instead of hardcoded values
3. **Loading States**: Always show loading states for async operations
4. **Empty States**: Provide helpful empty states with actionable buttons
5. **Feedback**: Use the feedback system for all user interactions
6. **Animations**: Leverage the built-in animations for smooth UX
7. **Responsive**: Use theme spacing constants for consistent layouts

### 11. **Migration Guide**

To migrate your existing screens:

1. **Add imports**: Import the enhanced widgets
2. **Replace buttons**: Change `ElevatedButton` to `PrimaryButton`
3. **Replace inputs**: Change `TextFormField` to `EmailInputField`/`PasswordInputField`
4. **Replace cards**: Change `Card` to `InfoCard`/`StatsCard`/`ActionCard`
5. **Add loading states**: Wrap async operations with loading indicators
6. **Add empty states**: Replace empty lists with `NoDataEmptyState`
7. **Update feedback**: Replace `SnackBar` with `FeedbackSystem`

### 12. **Demo Screen**

Check out `lib/screen/enhanced_demo_screen.dart` for a complete example of all enhanced widgets in action!

---

**Ready to enhance your app?** Start by replacing your existing widgets with the enhanced versions and watch your app transform into a modern, professional experience! 🚀