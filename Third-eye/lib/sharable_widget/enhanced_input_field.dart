import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../config/app_theme.dart';

class EnhancedInputField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? maxLength;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final Color? fillColor;
  final bool showLabel;
  final bool isRequired;
  final Duration animationDuration;

  const EnhancedInputField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.contentPadding,
    this.borderRadius = 16.0,
    this.fillColor,
    this.showLabel = true,
    this.isRequired = false,
    this.animationDuration = AppTheme.animationMedium,
  });

  @override
  State<EnhancedInputField> createState() => _EnhancedInputFieldState();
}

class _EnhancedInputFieldState extends State<EnhancedInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusController;
  late Animation<double> _focusAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _focusAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        if (_isFocused) {
          _focusController.forward();
        } else {
          _focusController.reverse();
        }
      });
    });

    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    _focusController.dispose();
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: widget.animationDuration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showLabel && widget.label != null) ...[
            Row(
              children: [
                Text(
                  widget.label!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _isFocused
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (widget.isRequired) ...[
                  const SizedBox(width: 4),
                  Text(
                    '*',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.errorColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppTheme.spacingS),
          ],
          AnimatedBuilder(
            animation: _focusAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: _isFocused ? AppTheme.lightShadow : null,
                ),
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: widget.keyboardType,
                  obscureText: _obscureText,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  onTap: widget.onTap,
                  onChanged: widget.onChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  validator: widget.validator,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: widget.enabled
                            ? AppTheme.textPrimary
                            : AppTheme.textTertiary,
                      ),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: _buildSuffixIcon(),
                    filled: true,
                    fillColor: widget.fillColor ?? AppTheme.cardColor,
                    contentPadding: widget.contentPadding ??
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: _isFocused
                            ? AppTheme.primaryColor
                            : AppTheme.dividerColor,
                        width: _isFocused ? 2.0 : 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide:
                          const BorderSide(color: AppTheme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: const BorderSide(
                          color: AppTheme.primaryColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: const BorderSide(color: AppTheme.errorColor),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: const BorderSide(
                          color: AppTheme.errorColor, width: 2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                          color: AppTheme.dividerColor.withOpacity(0.5)),
                    ),
                    errorText: widget.errorText,
                    errorStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.errorColor,
                        ),
                    counterText: '',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppTheme.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }
}

// Specialized input field variants
class EmailInputField extends EnhancedInputField {
  const EmailInputField({
    super.key,
    super.label = 'Email',
    super.hint = 'Enter your email',
    super.controller,
    super.onChanged,
    super.validator,
    super.isRequired = true,
  }) : super(
          keyboardType: TextInputType.emailAddress,
          prefixIcon:
              const Icon(Icons.email_outlined, color: AppTheme.textSecondary),
        );
}

class PasswordInputField extends EnhancedInputField {
  const PasswordInputField({
    super.key,
    super.label = 'Password',
    super.hint = 'Enter your password',
    super.controller,
    super.onChanged,
    super.validator,
    super.isRequired = true,
  }) : super(
          obscureText: true,
          prefixIcon:
              const Icon(Icons.lock_outline, color: AppTheme.textSecondary),
        );
}

class PhoneInputField extends EnhancedInputField {
  const PhoneInputField({
    super.key,
    super.label = 'Phone Number',
    super.hint = 'Enter your phone number',
    super.controller,
    super.onChanged,
    super.validator,
    super.isRequired = true,
  }) : super(
          keyboardType: TextInputType.phone,
          prefixIcon:
              const Icon(Icons.phone_outlined, color: AppTheme.textSecondary),
        );
}

class SearchInputField extends EnhancedInputField {
  const SearchInputField({
    super.key,
    super.hint = 'Search...',
    super.controller,
    super.onChanged,
    super.onSubmitted,
  }) : super(
          prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
          suffixIcon:
              const Icon(Icons.filter_list, color: AppTheme.textSecondary),
        );
}
