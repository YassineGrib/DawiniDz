import 'package:flutter/material.dart';

enum PageTransitionType {
  fade,
  slide,
  scale,
  rotation,
  slideFromBottom,
  slideFromTop,
  slideFromLeft,
  slideFromRight,
}

class AnimatedPageTransition extends PageRouteBuilder {
  final Widget child;
  final PageTransitionType type;
  final Duration duration;
  final Curve curve;

  AnimatedPageTransition({
    required this.child,
    this.type = PageTransitionType.slide,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(
              child,
              animation,
              secondaryAnimation,
              type,
              curve,
            );
          },
        );

  static Widget _buildTransition(
    Widget child,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    PageTransitionType type,
    Curve curve,
  ) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    switch (type) {
      case PageTransitionType.fade:
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );

      case PageTransitionType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.slideFromTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          child: child,
        );

      case PageTransitionType.rotation:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          child: child,
        );
    }
  }
}

// Helper class for creating animated page routes
class PageTransitions {
  static Route<T> fade<T>(Widget page, {Duration? duration}) {
    return AnimatedPageTransition(
      child: page,
      type: PageTransitionType.fade,
      duration: duration ?? const Duration(milliseconds: 300),
    );
  }

  static Route<T> slide<T>(Widget page, {Duration? duration}) {
    return AnimatedPageTransition(
      child: page,
      type: PageTransitionType.slide,
      duration: duration ?? const Duration(milliseconds: 300),
    );
  }

  static Route<T> slideFromBottom<T>(Widget page, {Duration? duration}) {
    return AnimatedPageTransition(
      child: page,
      type: PageTransitionType.slideFromBottom,
      duration: duration ?? const Duration(milliseconds: 300),
    );
  }

  static Route<T> slideFromTop<T>(Widget page, {Duration? duration}) {
    return AnimatedPageTransition(
      child: page,
      type: PageTransitionType.slideFromTop,
      duration: duration ?? const Duration(milliseconds: 300),
    );
  }

  static Route<T> slideFromLeft<T>(Widget page, {Duration? duration}) {
    return AnimatedPageTransition(
      child: page,
      type: PageTransitionType.slideFromLeft,
      duration: duration ?? const Duration(milliseconds: 300),
    );
  }

  static Route<T> slideFromRight<T>(Widget page, {Duration? duration}) {
    return AnimatedPageTransition(
      child: page,
      type: PageTransitionType.slideFromRight,
      duration: duration ?? const Duration(milliseconds: 300),
    );
  }

  static Route<T> scale<T>(Widget page, {Duration? duration}) {
    return AnimatedPageTransition(
      child: page,
      type: PageTransitionType.scale,
      duration: duration ?? const Duration(milliseconds: 300),
    );
  }

  static Route<T> rotation<T>(Widget page, {Duration? duration}) {
    return AnimatedPageTransition(
      child: page,
      type: PageTransitionType.rotation,
      duration: duration ?? const Duration(milliseconds: 600),
    );
  }
}

// Animated list item widget
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutBack,
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start animation with delay based on index
    Future.delayed(
      Duration(milliseconds: widget.index * widget.delay.inMilliseconds),
      () {
        if (mounted) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}

// Staggered animation helper
class StaggeredAnimations {
  static List<Widget> createStaggeredList({
    required List<Widget> children,
    Duration delay = const Duration(milliseconds: 100),
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeOutBack,
  }) {
    return children.asMap().entries.map((entry) {
      return AnimatedListItem(
        index: entry.key,
        delay: delay,
        duration: duration,
        curve: curve,
        child: entry.value,
      );
    }).toList();
  }
}

// Loading animation widget
class LoadingAnimation extends StatefulWidget {
  final String? message;
  final Color? color;
  final double size;

  const LoadingAnimation({
    super.key,
    this.message,
    this.color,
    this.size = 50.0,
  });

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value * 2 * 3.14159,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.color ?? Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: TextStyle(
              fontSize: 14,
              color: widget.color ?? Theme.of(context).primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
