import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/cat.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late Animation<double> catAnimation;
  late AnimationController catController;
  late Animation<double> boxAnimation;
  late AnimationController boxController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(begin: -20.0, end: -80.0)
        .animate(CurvedAnimation(parent: catController, curve: Curves.easeIn));

    boxController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    boxAnimation = Tween(begin: pi * .6, end: pi * .65).animate(
      CurvedAnimation(parent: boxController, curve: Curves.easeInOut),
    );

    boxController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
    boxController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child!,
          top: catAnimation.value,
          left: 0,
          right: 0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      width: 200.0,
      height: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          width: 125,
          height: 10,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Positioned(
            left: 7,
            top: 3,
            child: Transform.rotate(
              angle: boxAnimation.value,
              alignment: Alignment.topLeft,
              child: child,
            ),
          );
        });
  }

  Widget buildRightFlap() {
    return AnimatedBuilder(
        animation: boxAnimation,
        child: Container(
          width: 125,
          height: 10,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Positioned(
            right: 7,
            top: 3,
            child: Transform.rotate(
              angle: -boxAnimation.value,
              alignment: Alignment.topRight,
              child: child,
            ),
          );
        });
  }

  void onTap() {
    if (catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      boxController.stop();
      catController.forward();
    }
  }
}
