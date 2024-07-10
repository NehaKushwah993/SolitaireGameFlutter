import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:solitaire_game/main.dart';

class FullScreenClickableView extends PositionComponent with TapCallbacks, DragCallbacks{

  Function? onTap;

  @override
  bool get debugMode => kDebugMode;

  @override
  void onTapUp(TapUpEvent event) {
    onTap?.call();
    super.onTapUp(event);
  }
}