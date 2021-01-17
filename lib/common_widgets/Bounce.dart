import 'package:flutter/material.dart';

class Bounce extends StatefulWidget {

  Widget child;
  Duration duration;
  VoidCallback onPress;

  Bounce({
    @required this.child,
    @required this.onPress,
    this.duration

  });

  @override
  _BounceState createState() => _BounceState();

}

class _BounceState extends State<Bounce> with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;


  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration??Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTap: _tap,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  void _tap() {
    _controller.forward().then((value) => _controller.reverse());
  }


  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPress();
  }
}

