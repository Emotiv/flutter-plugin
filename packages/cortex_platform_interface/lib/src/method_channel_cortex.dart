import 'dart:async';

import 'package:flutter/services.dart';
import 'package:cortex_platform_interface/cortex_platform_interface.dart';

// A method channel based implementation of the CortexPlatform interface.
class MethodChannelCortex extends CortexPlatform {
  static const EventChannel _responseEventChannel =   EventChannel('dev.emotiv.cortex/response');
  static const EventChannel _warningEventChannel  =   EventChannel('dev.emotiv.cortex/warning');
  static const EventChannel _dataStreamEventChannel = EventChannel('dev.emotiv.cortex/dataStream') ;

  Stream<ResponseEvent>?   _responseEvent;
  Stream<WarningEvent>?    _warningEvent;
  Stream<DataStreamEvent>? _dataStreamEvent;

  /// A broadcast stream of events from the ResponseEvent.
  @override
  Stream<ResponseEvent> get responseEvents {
    _responseEvent ??= _responseEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
      return ResponseEvent(event);
    });
    return _responseEvent!;
  }

  /// A broadcast stream of events from the WarningEvent.
  @override
  Stream<WarningEvent> get warningEvents {
    _warningEvent ??= _warningEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
      return WarningEvent(event);
    });
    return _warningEvent!;
  }

  /// A broadcast stream of events from the DataStreamEvent.
  @override
  Stream<DataStreamEvent> get dataStreamEvents {
    _dataStreamEvent ??= _dataStreamEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
      return DataStreamEvent(event);
    });
    return _dataStreamEvent!;
  }
}