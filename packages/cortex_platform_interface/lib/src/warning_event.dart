import 'dart:convert';

class WarningEvent {
  final Map<String, dynamic> _value;
  final String jsonString;
  WarningEvent(this.jsonString): _value = jsonDecode(jsonString);

  int getWarningCode() {
    var warningBody = _value['warning'];
    if(warningBody == null){
      throw UnsupportedError('Invalid data: $jsonString -> "warning" is missing');
    }
    return warningBody['code'] as int;
  }

  dynamic getWarningMessage() {
    var warningBody = _value['warning'];
    if(warningBody == null){
      throw UnsupportedError('Invalid data: $jsonString -> "warning" is missing');
    }
    return warningBody['message'];
  }

  @override
  String toString() => '[WarningEvent: $_value]';
}