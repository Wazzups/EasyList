import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class APIFoodrepo {
  String apiKey = "dad55df826e17576d60de556feba3d99";
  String urlFoodrepo = "https://www.foodrepo.org/api/v3/products?barcodes=";

  Future<dynamic> getFoodInfo(String barcode) async {
    http.Response response = await http.get("https://www.foodrepo.org/api/v3/products?barcodes=$barcode",
        headers: {"Authorization": "Token token=$apiKey"});
      
    return json.decode(response.body);
  }
}
