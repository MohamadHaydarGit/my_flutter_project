import 'package:hive/hive.dart';
part 'clicked_button.g.dart';

@HiveType(typeId: 5)
class ClickedButton extends HiveObject{
  @HiveField(0)
  late bool clicked;

  ClickedButton({required this.clicked});

}