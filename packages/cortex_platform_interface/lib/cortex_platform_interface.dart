import 'dart:async';

import 'package:cortex_platform_interface/src/data_stream_event.dart';
import 'package:cortex_platform_interface/src/method_channel_cortex.dart';
import 'package:cortex_platform_interface/src/response_event.dart';
import 'package:cortex_platform_interface/src/warning_event.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

export 'src/response_event.dart';
export 'src/warning_event.dart';
export 'src/data_stream_event.dart';
// the common platform interface for Cortex
// each platform supported by Cortex should base on this interface
abstract class CortexPlatform extends PlatformInterface {
  /// Constructs a CortexPlatform.
  CortexPlatform() : super(token: _token);

  static final Object _token = Object();

  static CortexPlatform _instance = MethodChannelCortex();

  /// The default instance of [MethodChannelCortex] to use.
  ///
  /// Defaults to [MethodChannelCortex].
  static CortexPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [CortexPlatform] when they register themselves.
  static set instance(CortexPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// A broadcast stream of events from the response event.
  Stream<ResponseEvent> get responseEvents {
    throw UnimplementedError('responseEvents has not been implemented.');
  }

  /// A broadcast stream of events from the warning event.
  Stream<WarningEvent> get warningEvents {
    throw UnimplementedError('responseEvents has not been implemented.');
  }

  /// A broadcast stream of events from the data stream event.
  Stream<DataStreamEvent> get dataStreamEvents {
    throw UnimplementedError('responseEvents has not been implemented.');
  }

  Future<bool> startCortex() {
    throw UnimplementedError('startCortex() has not been implemented.');
  }

  Future<String> authenticateWithCortex(String clientId) {
    throw UnimplementedError('authenticateWithCortex() has not been implemented.');
  }

  Future<void> sendRequestToCortex(String command) {
    throw UnimplementedError('sendRequestToCortex() has not been implemented.');
  }
}