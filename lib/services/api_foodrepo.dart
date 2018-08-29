import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

main() async {
  print(get("d"));
}

Future<dynamic> get(String url) async =>
    http.get("https://www.foodrepo.org/api/v3/products?barcodes=7610848337010",
        headers: {
          "Authorization": "Token token=dad55df826e17576d60de556feba3d99"
        }).then((response) {
      print(jsonDecode(response.body));
    });
