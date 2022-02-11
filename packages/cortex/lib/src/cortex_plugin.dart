import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cortex_platform_interface/cortex_platform_interface.dart';

class Cortex extends CortexPlatform {
  /// Constructs a singleton instance of [Cortex].
  ///
  /// [Cortex] is designed to work as a singleton.
  static const MethodChannel _channel =
      MethodChannel('dev.emotiv.cortex/methods');

  factory Cortex() => _singleton ??= Cortex._();
  Cortex._();
  static Cortex? _singleton;
  static CortexPlatform get _platform => CortexPlatform.instance;

  @override
  Future<bool> startCortex() async {
    final result = await _channel.invokeMethod('startCortex');
    return result;
  }

  @override
  Future<void> sendRequestToCortex(String command) async {
    try {
      return _channel
          .invokeMethod('sendRequest', <String, dynamic>{'command': command});
    } on PlatformException catch (e) {
      throw 'Unable to execute command $command, $e';
    }
  }

  @override
  Future<String> authenticateWithCortex(String clientId) async {
    try {
      return await _channel.invokeMethod(
          'authenticate', <String, dynamic>{'clientId': clientId});
    } on PlatformException catch (e) {
      throw 'Unable to execute command $clientId, $e';
    }
  }

  @override
  Stream<ResponseEvent> get responseEvents {
    return _platform.responseEvents;
  }

  @override
  Stream<WarningEvent> get warningEvents {
    return _platform.warningEvents;
  }

  @override
  Stream<DataStreamEvent> get dataStreamEvents {
    return _platform.dataStreamEvents;
  }
}
