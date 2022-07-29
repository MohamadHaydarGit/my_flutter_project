
import 'dart:convert';

class PayLoad{
  late String action;
  late String value;
  late String data;

  PayLoad({required this.action, required this.value, required this.data});

  factory PayLoad.fromJson(Map<String, dynamic> jsonData) {
    return PayLoad(
      action: jsonData['action'],
      value:  jsonData['value'],
      data: jsonData['data'],
    );
  }

  static Map<String, dynamic> toMap(PayLoad payLoad) => {
    'action': payLoad.action,
    'value': payLoad.value,
    'data': payLoad.data,
  };

  static String encode(PayLoad payLoad) => json.encode(
    PayLoad.toMap(payLoad),
  );

  static PayLoad decode(String payLoad) {
    Map<String, dynamic> m= json.decode(payLoad);
    return PayLoad.fromJson(m);
  }
}