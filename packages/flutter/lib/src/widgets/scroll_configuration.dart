// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'framework.dart';
import 'overscroll_indicator.dart';
import 'scroll_physics.dart';
import 'scrollable.dart';
import 'scrollbar.dart';

const Color _kDefaultGlowColor = Color(0xFFFFFFFF);

/// Device types that scrollables should accept drag gestures from by default.
const Set<PointerDeviceKind> _kTouchLikeDeviceTypes = <PointerDeviceKind>{
  PointerDeviceKind.touch,
  PointerDeviceKind.stylus,
  PointerDeviceKind.invertedStylus,
  PointerDeviceKind.trackpad,
  // The VoiceAccess sends pointer events with unknown type when scrolling
  // scrollables.
  PointerDeviceKind.unknown,
};

/// The default overscroll indicator applied on [TargetPlatform.android].
// TODO(Piinks): Complete migration to stretch by default.
const AndroidOverscrollIndicator _kDefaultAndroidOverscrollIndicator = AndroidOverscrollIndicator.glow;

/// Types of overscroll indicators supported by [TargetPlatform.android].
enum AndroidOverscrollIndicator {
  /// Utilizes a [StretchingOverscrollIndicator], which transforms the contents
  /// of a [ScrollView] when overscrolled.
  stretch,

  /// Utilizes a [GlowingOverscrollIndicator], painting a glowing semi circle on
  /// top of the [ScrollView] in response to overscrolling.
  glow,
}

/// Describes how [Scrollable] widgets should behave.
///
/// {@template flutter.widgets.scrollBehavior}
/// Used by [ScrollConfiguration] to configure the [Scrollable] widgets in a
/// subtree.
///
/// This class can be extended to further customize a [ScrollBehavior] for a
/// subtree. For example, overriding [ScrollBehavior.getScrollPhysics] sets the
/// default [ScrollPhysics] for [Scrollable]s that inherit this [ScrollConfiguration].
/// Overriding [ScrollBehavior.buildOverscrollIndicator] can be used to add or change
/// the default [GlowingOverscrollIndicator] decoration, while
/// [ScrollBehavior.buildScrollbar] can be changed to modify the default [Scrollbar].
///
/// When looking to easily toggle the default decorations, you can use
/// [ScrollBehavior.copyWith] instead of creating your own [ScrollBehavior] class.
/// The `scrollbar` and `overscrollIndicator` flags can turn these decorations off.
/// {@endtemplate}
///
/// See also:
///
///   * [ScrollConfiguration], the inherited widget that controls how
///     [Scrollable] widgets behave in a subtree.
@immutable
class ScrollBehavior {
  /// Creates a description of how [Scrollable] widgets should behave.
  const ScrollBehavior({
    @Deprecated(
      'Use ThemeData.useMaterial3 or override ScrollBehavior.buildOverscrollIndicator. '
      'This feature was deprecated after v2.13.0-0.0.pre.'
    )
    AndroidOverscrollIndicator? androidOverscrollIndicator,
  }): _androidOverscrollIndicator = androidOverscrollIndicator;

  /// Specifies which overscroll indicator to use on [TargetPlatform.android].
  ///
  /// Cannot be null. Defaults to [AndroidOverscrollIndicator.glow].
  ///
  /// See also:
  ///
  ///   * [MaterialScrollBehavior], which supports setting this property
  ///     using [ThemeData].
  @Deprecated(
    'Use ThemeData.useMaterial3 or override ScrollBehavior.buildOverscrollIndicator. '
    'This feature was deprecated after v2.13.0-0.0.pre.'
  )
  AndroidOverscrollIndicator get androidOverscrollIndicator => _androidOverscrollIndicator ?? _kDefaultAndroidOverscrollIndicator;
  final AndroidOverscrollIndicator? _androidOverscrollIndicator;

  /// Creates a copy of this ScrollBehavior, making it possible to
  /// easily toggle `scrollbar` and `overscrollIndicator` effects.
  ///
  /// This is used by widgets like [PageView] and [ListWheelScrollView] to
  /// override the current [ScrollBehavior] and manage how they are decorated.
  /// Widgets such as these have the option to provide a [ScrollBehavior] on
  /// the widget level, like [PageView.scrollBehavior], in order to change the
  /// default.
  ScrollBehavior copyWith({
    bool? scrollbars,
    bool? overscroll,
    Set<PointerDeviceKind>? dragDevices,
    ScrollPhysics? physics,
    TargetPlatform? platform,
    @Deprecated(
      'Use ThemeData.useMaterial3 or override ScrollBehavior.buildOverscrollIndicator. '
      'This feature was deprecated after v2.13.0-0.0.pre.'
    )
    AndroidOverscrollIndicator? androidOverscrollIndicator,
  }) {
    return _WrappedScrollBehavior(
      delegate: this,
      scrollbars: scrollbars ?? true,
      overscroll: overscroll ?? true,
      physics: physics,
      platform: platform,
      dragDevices: dragDevices,
      androidOverscrollIndicator: androidOverscrollIndicator
    );
  }

  /// The platform whose scroll physics should be implemented.
  ///
  /// Defaults to the current platform.
  TargetPlatform getPlatform(BuildContext context) => defaultTargetPlatform;

  /// The device kinds that the scrollable will accept drag gestures from.
  ///
  /// By default only [PointerDeviceKind.touch], [PointerDeviceKind.stylus], and
  /// [PointerDeviceKind.invertedStylus] are configured to create drag gestures.
  /// Enabling this for [PointerDeviceKind.mouse] will make it difficult or
  /// impossible to select text in scrollable containers and is not recommended.
  Set<PointerDeviceKind> get dragDevices => _kTouchLikeDeviceTypes;

  /// Applies a [RawScrollbar] to the child widget on desktop platforms.
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    // When modifying this function, consider modifying the implementation in
    // the Material and Cupertino subclasses as well.
    switch (getPlatform(context)) {
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return RawScrollbar(
          controller: details.controller,
          child: child,
        );
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.ohos:
        return child;
    }
  }

  /// Applies a [GlowingOverscrollIndicator] to the child widget on
  /// [TargetPlatform.android] and [TargetPlatform.fuchsia].
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    // When modifying this function, consider modifying the implementation in
    // the Material and Cupertino subclasses as well.
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.ohos:
        return child;
      case TargetPlatform.android:
        switch (androidOverscrollIndicator) {
          case AndroidOverscrollIndicator.stretch:
            return StretchingOverscrollIndicator(
              axisDirection: details.direction,
              child: child,
            );
          case AndroidOverscrollIndicator.glow:
            continue glow;
        }
      glow:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          axisDirection: details.direction,
          color: _kDefaultGlowColor,
          child: child,
        );
    }
  }

  /// Specifies the type of velocity tracker to use in the descendant
  /// [Scrollable]s' drag gesture recognizers, for estimating the velocity of a
  /// drag gesture.
  ///
  /// This can be used to, for example, apply different fling velocity
  /// estimation methods on different platforms, in order to match the
  /// platform's native behavior.
  ///
  /// Typically, the provided [GestureVelocityTrackerBuilder] should return a
  /// fresh velocity tracker. If null is returned, [Scrollable] creates a new
  /// [VelocityTracker] to track the newly added pointer that may develop into
  /// a drag gesture.
  ///
  /// The default implementation provides a new
  /// [IOSScrollViewFlingVelocityTracker] on iOS and macOS for each new pointer,
  /// and a new [VelocityTracker] on other platforms for each new pointer.
  GestureVelocityTrackerBuilder velocityTrackerBuilder(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return (PointerEvent event) => IOSScrollViewFlingVelocityTracker(event.kind);
      case TargetPlatform.macOS:
        return (PointerEvent event) => MacOSScrollViewFlingVelocityTracker(event.kind);
      case TargetPlatform.android:
      case TargetPlatform.ohos:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return (PointerEvent event) => VelocityTracker.withKind(event.kind);
    }
  }

  static const ScrollPhysics _bouncingPhysics = BouncingScrollPhysics(parent: RangeMaintainingScrollPhysics());
  static const ScrollPhysics _bouncingDesktopPhysics = BouncingScrollPhysics(
    decelerationRate: ScrollDecelerationRate.fast,
    parent: RangeMaintainingScrollPhysics()
  );
  static const ScrollPhysics _clampingPhysics = ClampingScrollPhysics(parent: RangeMaintainingScrollPhysics());

  /// The scroll physics to use for the platform given by [getPlatform].
  ///
  /// Defaults to [RangeMaintainingScrollPhysics] mixed with
  /// [BouncingScrollPhysics] on iOS and [ClampingScrollPhysics] on
  /// Android.
  ScrollPhysics getScrollPhysics(BuildContext context) {
    // When modifying this function, consider modifying the implementation in
    // the Material and Cupertino subclasses as well.
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return _bouncingPhysics;
      case TargetPlatform.macOS:
        return _bouncingDesktopPhysics;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.ohos:
        return _clampingPhysics;
    }
  }

  /// Called whenever a [ScrollConfiguration] is rebuilt with a new
  /// [ScrollBehavior] of the same [runtimeType].
  ///
  /// If the new instance represents different information than the old
  /// instance, then the method should return true, otherwise it should return
  /// false.
  ///
  /// If this method returns true, all the widgets that inherit from the
  /// [ScrollConfiguration] will rebuild using the new [ScrollBehavior]. If this
  /// method returns false, the rebuilds might be optimized away.
  bool shouldNotify(covariant ScrollBehavior oldDelegate) => false;

  @override
  String toString() => objectRuntimeType(this, 'ScrollBehavior');
}

class _WrappedScrollBehavior implements ScrollBehavior {
  const _WrappedScrollBehavior({
    required this.delegate,
    this.scrollbars = true,
    this.overscroll = true,
    this.physics,
    this.platform,
    Set<PointerDeviceKind>? dragDevices,
    AndroidOverscrollIndicator? androidOverscrollIndicator,
  }) : _androidOverscrollIndicator = androidOverscrollIndicator,
       _dragDevices = dragDevices;

  final ScrollBehavior delegate;
  final bool scrollbars;
  final bool overscroll;
  final ScrollPhysics? physics;
  final TargetPlatform? platform;
  final Set<PointerDeviceKind>? _dragDevices;
  @override
  final AndroidOverscrollIndicator? _androidOverscrollIndicator;

  @override
  Set<PointerDeviceKind> get dragDevices => _dragDevices ?? delegate.dragDevices;

  @override
  AndroidOverscrollIndicator get androidOverscrollIndicator => _androidOverscrollIndicator ?? delegate.androidOverscrollIndicator;

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    if (overscroll) {
      return delegate.buildOverscrollIndicator(context, child, details);
    }
    return child;
  }

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    if (scrollbars) {
      return delegate.buildScrollbar(context, child, details);
    }
    return child;
  }

  @override
  ScrollBehavior copyWith({
    bool? scrollbars,
    bool? overscroll,
    ScrollPhysics? physics,
    TargetPlatform? platform,
    Set<PointerDeviceKind>? dragDevices,
    AndroidOverscrollIndicator? androidOverscrollIndicator
  }) {
    return delegate.copyWith(
      scrollbars: scrollbars ?? this.scrollbars,
      overscroll: overscroll ?? this.overscroll,
      physics: physics ?? this.physics,
      platform: platform ?? this.platform,
      dragDevices: dragDevices ?? this.dragDevices,
      androidOverscrollIndicator: androidOverscrollIndicator ?? this.androidOverscrollIndicator,
    );
  }

  @override
  TargetPlatform getPlatform(BuildContext context) {
    return platform ?? delegate.getPlatform(context);
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return physics ?? delegate.getScrollPhysics(context);
  }

  @override
  bool shouldNotify(_WrappedScrollBehavior oldDelegate) {
    return oldDelegate.delegate.runtimeType != delegate.runtimeType
        || oldDelegate.scrollbars != scrollbars
        || oldDelegate.overscroll != overscroll
        || oldDelegate.physics != physics
        || oldDelegate.platform != platform
        || !setEquals<PointerDeviceKind>(oldDelegate.dragDevices, dragDevices)
        || delegate.shouldNotify(oldDelegate.delegate);
  }

  @override
  GestureVelocityTrackerBuilder velocityTrackerBuilder(BuildContext context) {
    return delegate.velocityTrackerBuilder(context);
  }

  @override
  String toString() => objectRuntimeType(this, '_WrappedScrollBehavior');
}

/// Controls how [Scrollable] widgets behave in a subtree.
///
/// The scroll configuration determines the [ScrollPhysics] and viewport
/// decorations used by descendants of [child].
class ScrollConfiguration extends InheritedWidget {
  /// Creates a widget that controls how [Scrollable] widgets behave in a subtree.
  ///
  /// The [behavior] and [child] arguments must not be null.
  const ScrollConfiguration({
    super.key,
    required this.behavior,
    required super.child,
  });

  /// How [Scrollable] widgets that are descendants of [child] should behave.
  final ScrollBehavior behavior;

  /// The [ScrollBehavior] for [Scrollable] widgets in the given [BuildContext].
  ///
  /// If no [ScrollConfiguration] widget is in scope of the given `context`,
  /// a default [ScrollBehavior] instance is returned.
  static ScrollBehavior of(BuildContext context) {
    final ScrollConfiguration? configuration = context.dependOnInheritedWidgetOfExactType<ScrollConfiguration>();
    return configuration?.behavior ?? const ScrollBehavior();
  }

  @override
  bool updateShouldNotify(ScrollConfiguration oldWidget) {
    assert(behavior != null);
    return behavior.runtimeType != oldWidget.behavior.runtimeType
        || (behavior != oldWidget.behavior && behavior.shouldNotify(oldWidget.behavior));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ScrollBehavior>('behavior', behavior));
  }
}
