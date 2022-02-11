A Flutter plugin to work with Cortex library

## Platform Support

| Android |  iOS  | MacOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|   ✔️    |      |      |     |       |         |

## Usage

To use this plugin, add `cortex` as a [dependency in your pubspec.yaml
file](https://plus.fluttercommunity.dev/docs/overview).

This will expose three classes of Cortex events through 3 different
streams:

- `ResponseEvent` describes the response from Cortex for each request.
- `WarningEvent` describes the warning message from Cortex.
- `DataStreamEvent` describes the data stream event when subscribing data (eeg, motion, ...) from Cortex.

Each of these is exposed through `BroadcastStream`:`responseEvents`, `warningEvents`, and `dataStreamEvents`,
respectively.

It also provides 4 functions to work with Cortex:

- `startCortex` will launch Cortex.
- `authenticateWithCortex(clientId)` will open a webview for user login and get authentication code from Emotiv backend server.
- `sendRequestToCortex` will send request to Cortex with [json format](https://emotiv.gitbook.io/cortex-api/).
- `stopCortex` is implemented in Java layer when application terminates, we don't export it to dart layer.

### Example

```dart
import 'package:cortex/cortex.dart';

responseEvents.listen((event) {
  print(event);
});

warningEvents.listen((event) {
  print(event);
});

dataStreamEvents.listen((event) {
  print(event);
});


sendRequestToCortex('{ "id": 1, "jsonrpc": "2.0", "method": "queryHeadsets"}');

```

Also see the `example` subdirectory for the example application that uses to work with real device.
Remember to add `EmotivCortexLib.aar` to your main project.

### Attention

The embedded Cortex library (`EmotivCortexLib.aar` on Android) is in private beta only, and will be published in the future.
