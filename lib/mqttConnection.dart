import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:tailor_user_application/crypto_service.dart';

class mqttConnection {
  static final MqttServerClient client = MqttServerClient('43.201.126.212', '');
  static late final String clientToServerTopic;
  static late final String serverToClientTopic;
  static late StreamController<bool> _initialSubscribeStream;
  static late StreamController<bool> _loginCheckStream;
  static late StreamController<bool> _registarCheckStream;
  static late StreamController<dynamic> _placeDataStream;
  static late StreamController<dynamic> _playlistDataStream;
  static late String deviceId;
  static bool _deviceIdMaked = false;
  cryptoService _crypto = cryptoService();

  mqttConnection() {
    client.setProtocolV311();
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
  }

  void onDisconnected() {
    print(
        'MQTT:: OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');

    } else {
      print(
          'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
      exit(-1);
    }
  }

  void onConnected() {
    print(
        'MQTT:: OnConnected client callback - Client connection was successful.'
    );
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  Future<void> requestToServer(String msg) async {
    print('request to server called!!! : $msg');
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void registarRequest(String msg, StreamController<bool> check) async {
    _registarCheckStream = check;
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void loginRequest(String msg, StreamController<bool> check) async {
    _loginCheckStream = check;
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    client.publishMessage(clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void placeRequest(String msg, StreamController<dynamic> data) async {
    final builder = MqttClientPayloadBuilder();
    _placeDataStream = data;
    builder.addString(msg);
    client.publishMessage(clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void playlistRequest(String msg, StreamController<dynamic> data) async {
    print('playlist request called!! : $msg');
    final builder = MqttClientPayloadBuilder();
    _playlistDataStream = data;
    builder.addString(msg);
    client.publishMessage(clientToServerTopic, MqttQos.exactlyOnce, builder.payload!);
  }

  void initialConnectionHandler(dynamic json) async {
    String jsonTopicName = _crypto.my_decrypt(convert.base64Decode(json['topic_name']));
    serverToClientTopic = '$jsonTopicName';
    clientToServerTopic = '$jsonTopicName/user_command';

    client.subscribe('${serverToClientTopic}/reply', MqttQos.atMostOnce);
    client.subscribe('${serverToClientTopic}/sw_configs', MqttQos.atMostOnce);
    client.subscribe('${serverToClientTopic}/gps_configs', MqttQos.atMostOnce);
    _initialSubscribeStream.add(true);
    return;
  }

  void replyHandler(dynamic json) {
    int request_type = json['request_type'];
    if(request_type == 1) {
      bool isSucceed = json['succeed'];
      print(isSucceed);
      _loginCheckStream.add(isSucceed);
    }
    else if(request_type == 9) {
      bool isSucceed = json['succeed'];
      print(isSucceed);
      _registarCheckStream.add(isSucceed);
    }
    return;
  }
  void swHandler(dynamic json) {
    print(json);
    _playlistDataStream.add(json);
  }
  void gpsHandler(dynamic json) {
    print(json);
    _placeDataStream.add(json);
  }

  void messageHandler(String topic, String msg) {
    dynamic json = convert.jsonDecode(msg);
    print('MQTT messageHandler : $msg');
    if(topic == 'connect/reply') {
      if(json['device_id'] == deviceId!) {
        initialConnectionHandler(json);
      }
      return;
    }
    if(topic == '${serverToClientTopic}/reply') {
      replyHandler(json);
      return;
    }
    if(topic == '${serverToClientTopic}/sw_configs') {
      swHandler(json);
      return;
    }
    if(topic == '${serverToClientTopic}/gps_configs') {
      gpsHandler(json);
    }
  }

  void connect(StreamController<bool> check) async {
    WidgetsFlutterBinding.ensureInitialized();
    if(!_deviceIdMaked) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
      deviceId = deviceInfo.id;
      print('deviceId: $deviceId');
      _deviceIdMaked = true;
    }
    _initialSubscribeStream = check;
    print('crypto intialize start');
    await _crypto.initialize(); // only one time!
    print('crypto intialize end');

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }
    client.published!.listen((MqttPublishMessage message) {
      print(
          'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
      print('published message : ${MqttPublishPayload.bytesToStringAsString(message.payload.message)}');

    });

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload =
      MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message:$payload from topic: ${c[0].topic}>');
      messageHandler(c[0].topic, payload);
    });


    const topic1 = 'connect/reply';
    client.subscribe(topic1, MqttQos.atMostOnce);

    const topic2 = 'connect/request';
    final builder = MqttClientPayloadBuilder();

    Map<String, Object> jsonObj = {
      "dev_type":1,
      "device_id":deviceId,
      "timestamp":DateTime.now().millisecondsSinceEpoch,
      "public_key":_crypto.getMyPublicKey(),
    };
    final json = convert.jsonEncode(jsonObj);
    Uint8List list = _crypto.server_encrypt(json);
    String msg = convert.base64Encode(list);
    builder.addString(msg);
    client.publishMessage(topic2, MqttQos.exactlyOnce, builder.payload!);
    return;
  }
}