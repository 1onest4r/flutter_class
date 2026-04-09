import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class NetworkingManager {
  final catNotifier = ValueNotifier("");

  Future<void> getRequest() async {
    try {
      final uri = Uri.parse(
        "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/eur.json",
      );
      final response = await get(uri);

      final jsonString = response.body;
      final map = jsonDecode(jsonString);
      final mntValue = map["eur"]["mnt"];

      catNotifier.value = "Euro to mnt is: $mntValue";
    } on ClientException catch (err) {
      catNotifier.value = "Your internet has a problem";
    }
  }

  Future<void> postRequest() async {}
}
