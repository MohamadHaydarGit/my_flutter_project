
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

class TurtleGame extends FlameGame{
  late SpriteAnimationComponent turtle;
  late var width;
  TurtleGame({this.width});


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    Image turtleImage = await images.load('turtle.png');
   var turtleAnimation = SpriteAnimation.fromFrameData(turtleImage, SpriteAnimationData.sequenced(amount: 12, stepTime: 0.1, textureSize: Vector2(32,34)));
   turtle = SpriteAnimationComponent()..animation=turtleAnimation..size = Vector2(32, 34)*2.0
     ..position=Vector2(width/2-60,0);
   add(turtle);
  }

}