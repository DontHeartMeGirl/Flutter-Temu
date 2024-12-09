import 'package:flutter/material.dart';

class AnimationHelper {
  //圆点动画的逻辑
  static void startCartAnimation({
    required BuildContext context,
    required Offset startPosition, //动画开始位置
    required VoidCallback onComplete, //动画完成后的回调
    required Function(Offset) onPositionUpdate, //动画过程中的位置更新
    Duration duration = const Duration(milliseconds: 1800),
    Curve curve = Curves.easeOutBack,//动画效果
  }) {
    final mediaQuery = MediaQuery.of(context);
    final cartPosition = Offset(
      mediaQuery.size.width - 30, //标 X 坐标
      mediaQuery.size.height - 60, //目标 Y 坐标
    );

    //动画延迟执行，模拟跳跃效果
    Future.delayed(Duration(milliseconds: 100), () {
      onPositionUpdate(cartPosition); //更新动画目标位置
    });

    //动画完成后的逻辑
    Future.delayed(duration, onComplete);
  }
}
