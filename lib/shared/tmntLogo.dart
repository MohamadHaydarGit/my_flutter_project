import 'package:flutter/material.dart';

class Logo extends StatefulWidget {
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _colorAnimation;
  late Animation _sizeAnimation;
  late Animation<double> _curve;
  late bool isFav = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _colorAnimation = ColorTween(begin: Colors.grey[400], end: Colors.red)
        .animate(_curve);
    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 55, end: 60),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 60, end: 55),
        weight: 50,
      ),
    ]).animate(_curve);

    _controller.addListener(() {
    });
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
        setState(() {

          isFav = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isFav = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) {
        return Image.asset(
          'assets/tmnt.png',
          height: _sizeAnimation.value,
        );
      },
    );
  }
}
