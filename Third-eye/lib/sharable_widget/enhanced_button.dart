import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../config/app_theme.dart';

enum ButtonType { primary, secondary, outline, text, gradient }

class EnhancedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final List<BoxShadow>? shadow;
  final Duration animationDuration;

  const EnhancedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 16.0,
    this.shadow,
    this.animationDuration = AppTheme.animationMedium,
  });

  @override
  State<EnhancedButton> createState() => _EnhancedButtonState();
}

class _EnhancedButtonState extends State<EnhancedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null ? _onTapDown : null,
      onTapUp: widget.onPressed != null ? _onTapUp : null,
      onTapCancel: widget.onPressed != null ? _onTapCancel : null,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: FadeInUp(
              duration: widget.animationDuration,
              child: Container(
                width: widget.isFullWidth ? double.infinity : widget.width,
                height: widget.height ?? 56,
                decoration: BoxDecoration(
                  gradient: _getGradient(),
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: widget.shadow ?? AppTheme.mediumShadow,
                  border: _getBorder(),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    onTap: widget.onPressed,
                    child: Container(
                      padding: widget.padding ??
                          const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: widget.isLoading
                          ? _buildLoadingIndicator()
                          : _buildButtonContent(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtonContent() {
    if (widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: _getTextColor(),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            widget.text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _getTextColor(),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Center(
      child: Text(
        widget.text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: _getTextColor(),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    
    switch (widget.type) {
      case ButtonType.primary:
        return AppTheme.primaryColor;
      case ButtonType.secondary:
        return AppTheme.secondaryColor;
      case ButtonType.outline:
        return Colors.transparent;
      case ButtonType.text:
        return Colors.transparent;
      case ButtonType.gradient:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (widget.textColor != null) return widget.textColor!;
    
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.gradient:
        return Colors.white;
      case ButtonType.outline:
      case ButtonType.text:
        return AppTheme.primaryColor;
    }
  }

  Gradient? _getGradient() {
    if (widget.type == ButtonType.gradient) {
      return AppTheme.primaryGradient;
    }
    return null;
  }

  Border? _getBorder() {
    if (widget.type == ButtonType.outline) {
      return Border.all(color: AppTheme.primaryColor, width: 1.5);
    }
    return null;
  }
}

// Specialized button variants
class PrimaryButton extends EnhancedButton {
  const PrimaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
    super.isLoading,
    super.isFullWidth,
  }) : super(type: ButtonType.primary);
}

class SecondaryButton extends EnhancedButton {
  const SecondaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
    super.isLoading,
    super.isFullWidth,
  }) : super(type: ButtonType.secondary);
}

class OutlineButton extends EnhancedButton {
  const OutlineButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
    super.isLoading,
    super.isFullWidth,
  }) : super(type: ButtonType.outline);
}

class GradientButton extends EnhancedButton {
  const GradientButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
    super.isLoading,
    super.isFullWidth,
  }) : super(type: ButtonType.gradient);
}