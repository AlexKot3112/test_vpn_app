import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:vpn_test_app/user_config.dart';

import 'package:vpn_test_app/utils.dart';
import 'package:vpn_test_app/widgets/connect_country.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isConnected = false;
  late OpenVPN engine;
  VpnStatus? status;
  VPNStage? stage;
  bool _granted = false;

  @override
  void initState() {
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        setState(
          () {
            status = data;
          },
        );
      },
      onVpnStageChanged: (data, raw) {
        setState(
          () {
            stage = data;
          },
        );
      },
    );

    engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
          "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "VPN by Nizwar",
      lastStage: (stage) {
        setState(() {
          this.stage = stage;
        });
      },
      lastStatus: (status) {
        setState(() {
          this.status = status;
        });
      },
    );
    super.initState();
  }

  Future<void> initPlatformState() async {
    engine.connect(config, "Russia",
        username: defaultVpnUsername,
        password: defaultVpnPassword,
        certIsRequired: true);
    if (!mounted) return;
  }

  final String defaultVpnUsername = userName;
  final String defaultVpnPassword = password;

  String config = uConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'MarIst VPN',
          style: TextStyle(
            color: textColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          button(),
          const SizedBox(
            height: 30,
          ),
          connectInfo(),
          const SizedBox(
            height: 30,
          ),
          const SelectConnectCountry(),
          const SizedBox(
            height: 30,
          ),
          networkSpeed(),
        ],
      ),
    );
  }

  Widget button() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            initPlatformState();
          },
          child: Image.asset(
            'assets/green-button.png',
            width: 100,
          ),
        ),
        const SizedBox(
          height: 40,
          child: Text(
            'Start',
            style: textStyle,
          ),
        ),
        GestureDetector(
          onTap: () {
            engine.disconnect();
          },
          child: Image.asset(
            'assets/red-button.png',
            width: 100,
          ),
        ),
        const SizedBox(
          height: 40,
          child: Text(
            'Stop',
            style: textStyle,
          ),
        ),
        if (Platform.isAndroid)
          TextButton(
            child: Text(
              _granted ? "Granted" : "Request Permission",
            ),
            onPressed: () {
              engine.requestPermissionAndroid().then(
                (value) {
                  setState(
                    () {
                      _granted = value;
                    },
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget connectInfo() {
    return Row(
      children: [
        Text(
          '$stage',
          style: connectStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget networkSpeed() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  const Text(
                    'Bytes In:  ',
                    style: textStyle,
                  ),
                  Text(
                    '${status?.byteIn}',
                    style: connectStyle,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
                  const Text(
                    'Bytes Out:  ',
                    style: textStyle,
                  ),
                  Text(
                    '${status?.byteOut}',
                    style: connectStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
