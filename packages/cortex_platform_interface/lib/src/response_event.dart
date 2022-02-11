import 'dart:convert';

class ResponseEvent {
  final Map<String, dynamic> _value;
  final String jsonString;
  ResponseEvent(this.jsonString): _value = jsonDecode(jsonString);

  dynamic getRequestId() {
    return _value['id'];
  }

  bool isResponseError() {
    var error = _value['error'];
    if(error != null) {
      return true;
    }
    return false;
  }

  bool isReponseResult() {
    return !isResponseError();
  }

  dynamic getResponseBody() {
    if(isResponseError()) {
      return _value['error'];
    }
    return _value['result'];
  }

  @override
  String toString() => '[ResponseEvent: $_value]';
}