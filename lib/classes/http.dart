import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestResult {
  bool ok;
  dynamic data;
  RequestResult(this.ok, this.data);
}

String protocolo = "http";
// CON LOCALHOST 127.0.0.1 no ha funcionado, he tenido que poner la IP asignada del dispitivo */
//const DOMAIN = "192.168.123.78:8000";
//const dominio = "10.207.4.52:8001";
String? dominio = "192.168.123.203:8001";
//String dominio = "192.168.1.83:8001";

Future<RequestResult> httpGet(String route, [dynamic data]) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dominio = prefs.getString('APIServer');
  var dataStr = jsonEncode(data);
  var url = "$protocolo://$dominio/$route?data=$dataStr";
  var result = await http.get(Uri.parse(url), headers: {
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials":
        "true", // Required for cookies, authorization headers with HTTPS
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "POST, OPTIONS"
  });
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> httpPost(String route, [dynamic data]) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dominio = prefs.getString('APIServer');
  var dataStr = jsonEncode(data);
  var url = "$protocolo://$dominio/$route";
  var result = await http.post(Uri.parse(url),
      body: dataStr,
      headers: {"Content-Type": "application/json; charset=UTF-8"});
  return RequestResult(true, jsonDecode(result.body));
}
