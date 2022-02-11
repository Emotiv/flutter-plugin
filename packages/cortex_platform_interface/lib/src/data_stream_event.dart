import 'dart:convert';

enum Event {
  unknown,
  eeg,
  motion,
  deviceInfo,
  eegQuality,
  performanceMetrics,
  facialExpression,
  mentalCommand,
  training,
  bandPower
}

class DataStreamEvent {
  final Map<String, dynamic> _value;
  final String jsonString;
  MapEntry<String, Event> _streamType = MapEntry('', Event.unknown);
  static const Map<String, Event> _acceptedEventsString = {
    'eeg':Event.eeg, 'mot':Event.motion, 'dev':Event.deviceInfo,
    'eq':Event.eegQuality, 'met':Event.performanceMetrics,
    'fac':Event.facialExpression, 'com':Event.mentalCommand,
    'sys':Event.training, 'pow':Event.bandPower
  };
  DataStreamEvent(this.jsonString): _value = jsonDecode(jsonString);

  double getTimeEvent() {
    var time = _value['time'];
    if(time == null){
      throw UnsupportedError('Invalid data: $jsonString -> "time" is missing');
    }
    return time as double;
  }

  String getStreamId() {
    var streamId = _value['sid'];
    if(streamId == null){
      throw UnsupportedError('Invalid data: $jsonString -> "sid" is missing');
    }
    return streamId as String;
  }

  Event getStreamType() {
    if(_streamType.value == Event.unknown) {
      var keys = _value.keys;
      assert(keys.length == 3);
      try {
        String element = keys.firstWhere((element) => _acceptedEventsString.containsKey(element));
        _streamType = MapEntry(element, _acceptedEventsString[element] as Event);
      } catch (e) {
        print('Something really unknown: $e');
        return Event.unknown;
      }
    }
    return _streamType.value;
  }

  dynamic getDataStreamBody()
  {
    getStreamType();
    String key = _streamType.key;
    var body = _value[key];
    if(body == null){
      throw UnsupportedError('Invalid data: $jsonString -> $key is missing');
    }
    return body;
  }

  @override
  String toString() => '[DataStreamEvent: $_value]';
}