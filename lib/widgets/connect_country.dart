import 'package:flutter/material.dart';
import 'package:vpn_test_app/utils.dart';

class SelectConnectCountry extends StatefulWidget {
  const SelectConnectCountry({super.key});

  @override
  State<SelectConnectCountry> createState() => _SelectConnectCountryState();
}

class _SelectConnectCountryState extends State<SelectConnectCountry> {
  String dropdownValue = 'Canada';
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      items: <String>['Canada', 'USA'].map<DropdownMenuItem<String>>(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: SizedBox(
              width: 250,
              child: Text(
                value,
                style: textStyle,
              ),
            ),
          );
        },
      ).toList(),
      onChanged: (String? newValue) {
        setState(
          () {
            dropdownValue = newValue!;
          },
        );
      },
    );
  }
}
