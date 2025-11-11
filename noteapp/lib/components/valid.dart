import 'package:noteapp/constant/message.dart';

validInput(String val, int min, int max) {
  if (val.length > max) {
    return "$messageInputMax $max";
  } else if (val.isEmpty) {
    return "$messageInputEmpty ";
  } else if (val.length < min) {
    return "$messageInputMin $min";
  }
  return null;
}
