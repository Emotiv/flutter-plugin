import 'package:cortex_platform_interface/cortex_platform_interface.dart';
import 'src/cortex_plugin.dart';

export 'src/cortex_plugin.dart';
export 'package:cortex_platform_interface/cortex_platform_interface.dart';

final _cortex = Cortex();

Stream<ResponseEvent> get responseEvents {
  return _cortex.responseEvents;
}

Stream<WarningEvent> get warningEvents {
  return _cortex.warningEvents;
}

Stream<DataStreamEvent> get dataStreamEvents {
  return _cortex.dataStreamEvents;
}

Future<bool> startCortex() async {
  return _cortex.startCortex();
}

void sendRequestToCortex(String command) {
  _cortex.sendRequestToCortex(command);
}

Future<String> authenticateWithCortex(String clientId) async {
  return _cortex.authenticateWithCortex(clientId);
}
