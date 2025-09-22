import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../config/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? illustration;
  final String? illustrationPath;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;
  final bool showAction;
  final EdgeInsetsGeometry? padding;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.illustration,
    this.illustrationPath,
    this.actionText,
    this.onActionPressed,
    this.actionIcon,
    this.showAction = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: AppTheme.animationMedium,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            _buildIllustration(),
            
            const SizedBox(height: AppTheme.spacingXL),
            
            // Title
            FadeInUp(
              duration: AppTheme.animationMedium,
              delay: const Duration(milliseconds: 200),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            if (subtitle != null) ...[
              const SizedBox(height: AppTheme.spacingM),
              FadeInUp(
                duration: AppTheme.animationMedium,
                delay: const Duration(milliseconds: 400),
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            
            if (showAction && actionText != null) ...[
              const SizedBox(height: AppTheme.spacingXL),
              FadeInUp(
                duration: AppTheme.animationMedium,
                delay: const Duration(milliseconds: 600),
                child: ElevatedButton.icon(
                  onPressed: onActionPressed,
                  icon: Icon(actionIcon ?? Icons.add),
                  label: Text(actionText!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingL,
                      vertical: AppTheme.spacingM,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    if (illustration != null) {
      return illustration!;
    }
    
    if (illustrationPath != null) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        ),
        child: Image.asset(
          illustrationPath!,
          fit: BoxFit.contain,
        ),
      );
    }
    
    // Default illustration
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
      ),
      child: Icon(
        Icons.inbox_outlined,
        size: 64,
        color: AppTheme.primaryColor.withOpacity(0.6),
      ),
    );
  }
}

// Predefined empty states
class NoDataEmptyState extends StatelessWidget {
  final String? message;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const NoDataEmptyState({
    super.key,
    this.message,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Data Available',
      subtitle: message ?? 'There\'s nothing to show here yet.',
      illustrationPath: 'assets/illustration.svg',
      actionText: actionText,
      onActionPressed: onActionPressed,
      actionIcon: Icons.refresh,
      showAction: actionText != null,
    );
  }
}

class ErrorEmptyState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorEmptyState({
    super.key,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'Something went wrong',
      subtitle: message ?? 'We encountered an error. Please try again.',
      illustration: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        ),
        child: Icon(
          Icons.error_outline,
          size: 64,
          color: AppTheme.errorColor,
        ),
      ),
      actionText: 'Try Again',
      onActionPressed: onRetry,
      actionIcon: Icons.refresh,
      showAction: true,
    );
  }
}

class NoInternetEmptyState extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetEmptyState({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Internet Connection',
      subtitle: 'Please check your internet connection and try again.',
      illustration: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: AppTheme.warningColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        ),
        child: Icon(
          Icons.wifi_off,
          size: 64,
          color: AppTheme.warningColor,
        ),
      ),
      actionText: 'Retry',
      onActionPressed: onRetry,
      actionIcon: Icons.refresh,
      showAction: true,
    );
  }
}

class SearchEmptyState extends StatelessWidget {
  final String? query;

  const SearchEmptyState({
    super.key,
    this.query,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No Results Found',
      subtitle: query != null 
          ? 'No results found for "$query". Try different keywords.'
          : 'No results found. Try different search terms.',
      illustration: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: AppTheme.textTertiary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        ),
        child: Icon(
          Icons.search_off,
          size: 64,
          color: AppTheme.textTertiary,
        ),
      ),
      showAction: false,
    );
  }
}

class LoadingEmptyState extends StatelessWidget {
  final String? message;

  const LoadingEmptyState({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: AppTheme.animationMedium,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusXL),
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingXL),
            
            Text(
              message ?? 'Loading...',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}