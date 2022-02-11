import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cortex/cortex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'src/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class Headset {
  String headsetId;
  bool isVirtual;
  String status;

  Headset(this.headsetId, this.isVirtual, this.status);

  void setHeadsetStatus(String status) {
    this.status = status;
  }
}

class _MyAppState extends State<MyApp> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  late final String _cortexToken;
  late String _sessionId;
  late String _activeHeadset;

  @override
  void initState() {
    super.initState();
    callCortexStart();
    _streamSubscriptions.add(
      responseEvents.listen(
        (event) {
          print(event);
          switch (event.getRequestId()) {
            case Constant.authorizeRequestId:
              // get cortex token and save to variable
              var data = event.getResponseBody() as Map<String, dynamic>;
              _cortexToken = data["cortexToken"];
              print("cortex token: $_cortexToken");
              break;
            case Constant.queryHeadsetRequestId:
              var data = event.getResponseBody();
              List<Headset> headset = <Headset>[];
              for (var element in data) {
                Headset h = Headset(
                    element["id"], element["isVirtual"], element["status"]);
                headset.add(h);
              }
              setState(() {
                _headsetList = headset;
              });
              break;
            case Constant.createSessionRequestId:
              var data = event.getResponseBody();
              _sessionId = data["id"];
              break;
            default:
              break;
          }
        },
      ),
    );
    _streamSubscriptions.add(warningEvents.listen((event) {
      if (event.getWarningCode() == Constant.headsetIsConnected) {
        // query headset again to update status
        var data = event.getWarningMessage();
        _activeHeadset = data["headsetId"];
        _queryHeadset();
      }
    }));
    _streamSubscriptions.add(dataStreamEvents.listen((event) {
      print("Data Stream Event: ${event.getDataStreamBody()}");
    }));
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  Future<void> callCortexStart() async {
    bool result;
    try {
      if (Platform.isAndroid) {
        Map<Permission, PermissionStatus> statuses =
            await [Permission.location].request();
        print(statuses[Permission.location]);
      }
      result = await startCortex();
      print("call cortex start: $result");
    } on Exception {
      print("Something wrong");
    }
  }

  void _queryHeadset() {
    sendRequestToCortex(
        '{ "id": ${Constant.queryHeadsetRequestId}, "jsonrpc": "2.0", "method": "queryHeadsets"}');
  }

  void _login() async {
    String code = await authenticateWithCortex(Constant.clientId);
    print("AuthenCode: $code");
    if (code.isNotEmpty) {
      String json = ''' { 
        "jsonrpc": "2.0",
        "id": ${Constant.loginRequestId},
        "method": "loginWithAuthenticationCode",
        "params": {
          "clientId": "${Constant.clientId}",
          "clientSecret": "${Constant.clientSecret}",
          "code": "$code"
          } 
        } ''';
      sendRequestToCortex(json);
    }
  }

  void _authorize() {
    String json = ''' { 
        "jsonrpc": "2.0",
        "id": ${Constant.authorizeRequestId},
        "method": "authorize",
        "params": {
          "clientId": "${Constant.clientId}",
          "clientSecret": "${Constant.clientSecret}",
          "debit": ${Constant.debitNumber},
          "license": "${Constant.licenseId}"
          } 
        } ''';
    sendRequestToCortex(json);
  }

  void _getUserInfo() {
    String json = ''' { 
        "jsonrpc": "2.0",
        "id": ${Constant.getUserInfoRequestId},
        "method": "getUserInformation",
        "params": {
          "cortexToken": "$_cortexToken"
          } 
        } ''';
    sendRequestToCortex(json);
  }

  void _getLicenseInfo() {
    String json = ''' { 
        "jsonrpc": "2.0",
        "id": ${Constant.getLicenseInfoRequestId},
        "method": "getLicenseInfo",
        "params": {
          "cortexToken": "$_cortexToken"
          } 
        } ''';
    sendRequestToCortex(json);
  }

  void _createSession() {
    String json = ''' { 
        "jsonrpc": "2.0",
        "id": ${Constant.createSessionRequestId},
        "method": "createSession",
        "params": {
          "cortexToken": "$_cortexToken",
          "headset": "$_activeHeadset",
          "status": "active"
          } 
        } ''';
    sendRequestToCortex(json);
  }

  void _subscribeData() {
    String json = ''' { 
        "jsonrpc": "2.0",
        "id": ${Constant.subscribeDataRequestId},
        "method": "subscribe",
        "params": {
          "cortexToken": "$_cortexToken",
          "session": "$_sessionId",
          "streams": ["eeg"]
          } 
        } ''';
    sendRequestToCortex(json);
  }

  void _unsubscribeData() {
    String json = ''' { 
        "jsonrpc": "2.0",
        "id": ${Constant.subscribeDataRequestId},
        "method": "unsubscribe",
        "params": {
          "cortexToken": "$_cortexToken",
          "session": "$_sessionId",
          "streams": ["eeg"]
          } 
        } ''';
    sendRequestToCortex(json);
  }

  List<Headset> _headsetList = <Headset>[];

  DataRow _getDataRow(Headset result) {
    return DataRow(
        cells: <DataCell>[
          DataCell(Text(result.headsetId)),
          DataCell(Text(result.isVirtual.toString())),
          DataCell(Text(result.status)),
        ],
        onSelectChanged: (bool? selected) {
          if (selected != null && selected) {
            sendRequestToCortex('''
              { "id": ${Constant.controlDeviceRequestId}, 
              "jsonrpc": "2.0", 
              "method": "controlDevice",
              "params": {
                "command": "connect",
                "headset": "${result.headsetId}"
              }
              }
              ''');
          }
        },
        onLongPress: () {
          sendRequestToCortex('''
              { "id": ${Constant.controlDeviceRequestId}, 
              "jsonrpc": "2.0", 
              "method": "controlDevice",
              "params": {
                "command": "disconnect",
                "headset": "${result.headsetId}"
              }
              }
              ''');
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DataTable(
              showCheckboxColumn: false,
              horizontalMargin: 5,
              dataTextStyle: const TextStyle(fontSize: 12, color: Colors.black),
              columns: const [
                DataColumn(label: Text('HeadsetId')),
                DataColumn(label: Text('isVirtualHeadset')),
                DataColumn(label: Text('Status')),
              ],
              rows: List.generate(_headsetList.length,
                  (index) => _getDataRow(_headsetList[index])),
            ),
            const SizedBox(height: 100.0),
            TextButton(
                onPressed: () => sendRequestToCortex(
                    '{ "id": ${Constant.getUserLoggedInRequestId}, "jsonrpc": "2.0", "method": "getUserLogin"}'),
                child: const Text("Get User Login")),
            const SizedBox(height: 8.0),
            TextButton(
              onPressed: _login,
              child: const Text("Login"),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextButton(
              onPressed: _authorize,
              child: const Text("Authorize"),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextButton(
              onPressed: _getUserInfo,
              child: const Text("Get User Information"),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextButton(
              onPressed: _getLicenseInfo,
              child: const Text("Get License Information"),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextButton(
              onPressed: _queryHeadset,
              child: const Text("QueryHeadset"),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextButton(
              onPressed: _createSession,
              child: const Text("Create Session"),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextButton(
              onPressed: _subscribeData,
              child: const Text("Subscribe Data"),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextButton(
              onPressed: _unsubscribeData,
              child: const Text("Unsubscribe Data"),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextButton(
              onPressed: _getLicenseInfo,
              child: const Text("close session"),
            )
          ],
        )),
      ),
    );
  }
}
