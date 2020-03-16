import 'package:flutter/material.dart';

//code inspired: https://github.com/shianpoon/flutter_beaches_app/blob/master/lib/fade_page_route.dart

class FancyPageRoute<T> extends PageRoute<T>{
  FancyPageRoute({
    @required this.builder,
    RouteSettings settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  }) :  assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        assert(opaque),
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final Widget result = builder(context);
    assert(() {
      if (result == null) {
        throw FlutterError(
            'The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.');
      }
      return true;
    }());
     return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return _FadeInPageTransition(routeAnimation: animation, child: child);
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}



class _FadeInPageTransition extends StatelessWidget {
  _FadeInPageTransition({Key key, @required Animation<double> routeAnimation, // The route's linear 0.0 - 1.0 animation.
    @required this.child, })  : _opacityAnimation = routeAnimation.drive(_customTween), super(key: key);

  static final Animatable<double> _customTween = CurveTween(curve: Curves.fastOutSlowIn);

  final Animation<double> _opacityAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: child,
    );
  }
}