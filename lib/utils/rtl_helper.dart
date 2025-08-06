import 'package:flutter/material.dart';

/// Helper class for RTL (Right-to-Left) language support
class RTLHelper {
  /// Check if the current locale is RTL
  static bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }

  /// Get the appropriate text direction for the current locale
  static TextDirection getTextDirection(BuildContext context) {
    return Directionality.of(context);
  }

  /// Get the appropriate text align for the current locale
  static TextAlign getTextAlign(BuildContext context, {TextAlign? fallback}) {
    if (isRTL(context)) {
      return TextAlign.right;
    }
    return fallback ?? TextAlign.left;
  }

  /// Get the appropriate main axis alignment for RTL
  static MainAxisAlignment getMainAxisAlignment(BuildContext context) {
    if (isRTL(context)) {
      return MainAxisAlignment.end;
    }
    return MainAxisAlignment.start;
  }

  /// Get the appropriate cross axis alignment for RTL
  static CrossAxisAlignment getCrossAxisAlignment(BuildContext context) {
    if (isRTL(context)) {
      return CrossAxisAlignment.end;
    }
    return CrossAxisAlignment.start;
  }

  /// Get the appropriate edge insets for RTL
  static EdgeInsets getEdgeInsets(
    BuildContext context, {
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    if (isRTL(context)) {
      return EdgeInsets.fromLTRB(right, top, left, bottom);
    }
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  /// Get the appropriate border radius for RTL
  static BorderRadius getBorderRadius(
    BuildContext context, {
    double topLeft = 0.0,
    double topRight = 0.0,
    double bottomLeft = 0.0,
    double bottomRight = 0.0,
  }) {
    if (isRTL(context)) {
      return BorderRadius.only(
        topLeft: Radius.circular(topRight),
        topRight: Radius.circular(topLeft),
        bottomLeft: Radius.circular(bottomRight),
        bottomRight: Radius.circular(bottomLeft),
      );
    }
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }

  /// Get the appropriate icon for navigation based on RTL
  static IconData getNavigationIcon(BuildContext context, {
    required IconData ltrIcon,
    required IconData rtlIcon,
  }) {
    if (isRTL(context)) {
      return rtlIcon;
    }
    return ltrIcon;
  }

  /// Get the appropriate back icon for RTL
  static IconData getBackIcon(BuildContext context) {
    return getNavigationIcon(
      context,
      ltrIcon: Icons.arrow_back,
      rtlIcon: Icons.arrow_forward,
    );
  }

  /// Get the appropriate forward icon for RTL
  static IconData getForwardIcon(BuildContext context) {
    return getNavigationIcon(
      context,
      ltrIcon: Icons.arrow_forward,
      rtlIcon: Icons.arrow_back,
    );
  }

  /// Get the appropriate chevron left icon for RTL
  static IconData getChevronLeftIcon(BuildContext context) {
    return getNavigationIcon(
      context,
      ltrIcon: Icons.chevron_left,
      rtlIcon: Icons.chevron_right,
    );
  }

  /// Get the appropriate chevron right icon for RTL
  static IconData getChevronRightIcon(BuildContext context) {
    return getNavigationIcon(
      context,
      ltrIcon: Icons.chevron_right,
      rtlIcon: Icons.chevron_left,
    );
  }

  /// Get the appropriate arrow forward iOS icon for RTL
  static IconData getArrowForwardIosIcon(BuildContext context) {
    return getNavigationIcon(
      context,
      ltrIcon: Icons.arrow_forward_ios,
      rtlIcon: Icons.arrow_back_ios,
    );
  }

  /// Get the appropriate arrow back iOS icon for RTL
  static IconData getArrowBackIosIcon(BuildContext context) {
    return getNavigationIcon(
      context,
      ltrIcon: Icons.arrow_back_ios,
      rtlIcon: Icons.arrow_forward_ios,
    );
  }

  /// Wrap widget with proper directionality
  static Widget wrapWithDirectionality({
    required BuildContext context,
    required Widget child,
    TextDirection? textDirection,
  }) {
    return Directionality(
      textDirection: textDirection ?? getTextDirection(context),
      child: child,
    );
  }

  /// Create a properly aligned row for RTL
  static Widget createAlignedRow({
    required BuildContext context,
    required List<Widget> children,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
  }) {
    return Row(
      textDirection: getTextDirection(context),
      mainAxisAlignment: mainAxisAlignment ?? getMainAxisAlignment(context),
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      children: children,
    );
  }

  /// Create a properly aligned column for RTL
  static Widget createAlignedColumn({
    required BuildContext context,
    required List<Widget> children,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisSize? mainAxisSize,
  }) {
    return Column(
      textDirection: getTextDirection(context),
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? getCrossAxisAlignment(context),
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      children: children,
    );
  }

  /// Get appropriate slide transition offset for RTL
  static Offset getSlideOffset(BuildContext context, {
    required double dx,
    required double dy,
  }) {
    if (isRTL(context)) {
      return Offset(-dx, dy);
    }
    return Offset(dx, dy);
  }

  /// Get appropriate alignment for RTL
  static Alignment getAlignment(BuildContext context, {
    required Alignment ltrAlignment,
    required Alignment rtlAlignment,
  }) {
    if (isRTL(context)) {
      return rtlAlignment;
    }
    return ltrAlignment;
  }

  /// Get appropriate alignment for center left/right
  static Alignment getCenterAlignment(BuildContext context) {
    return getAlignment(
      context,
      ltrAlignment: Alignment.centerLeft,
      rtlAlignment: Alignment.centerRight,
    );
  }

  /// Get appropriate alignment for top left/right
  static Alignment getTopAlignment(BuildContext context) {
    return getAlignment(
      context,
      ltrAlignment: Alignment.topLeft,
      rtlAlignment: Alignment.topRight,
    );
  }

  /// Get appropriate alignment for bottom left/right
  static Alignment getBottomAlignment(BuildContext context) {
    return getAlignment(
      context,
      ltrAlignment: Alignment.bottomLeft,
      rtlAlignment: Alignment.bottomRight,
    );
  }

  /// Format number for RTL display
  static String formatNumber(BuildContext context, num number) {
    // For Arabic, we might want to use Arabic-Indic digits
    // For now, we'll use regular digits
    return number.toString();
  }

  /// Get appropriate text style for RTL
  static TextStyle getTextStyle(BuildContext context, TextStyle baseStyle) {
    // You can modify text style based on RTL requirements
    // For example, adjust letter spacing, font family, etc.
    return baseStyle;
  }

  /// Check if a string contains RTL characters
  static bool containsRTLCharacters(String text) {
    final rtlRegex = RegExp(r'[\u0590-\u05FF\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
    return rtlRegex.hasMatch(text);
  }

  /// Get appropriate text direction for a specific text
  static TextDirection getTextDirectionForText(String text) {
    if (containsRTLCharacters(text)) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  /// Create a text widget with proper direction
  static Widget createDirectionalText({
    required String text,
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    final textDirection = getTextDirectionForText(text);
    
    return Directionality(
      textDirection: textDirection,
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        textDirection: textDirection,
      ),
    );
  }

  /// Get appropriate padding for RTL
  static EdgeInsets getPadding(BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) {
      return EdgeInsets.all(all);
    }
    
    if (horizontal != null || vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: horizontal ?? 0.0,
        vertical: vertical ?? 0.0,
      );
    }

    return getEdgeInsets(
      context,
      left: left ?? 0.0,
      top: top ?? 0.0,
      right: right ?? 0.0,
      bottom: bottom ?? 0.0,
    );
  }

  /// Get appropriate margin for RTL
  static EdgeInsets getMargin(BuildContext context, {
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return getPadding(
      context,
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
}
