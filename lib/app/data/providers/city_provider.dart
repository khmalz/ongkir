import 'package:get/get.dart';

import '../models/city_model.dart';

class CityProvider extends GetConnect {
  Future<List<City>> getCities(Map<String, dynamic> query) async {
    final response = await get(
      "https://api.rajaongkir.com/starter/city",
      headers: {
        'key': 'dda1790b2f6cb1426e9e84b4ba6c92ac',
      },
      query: query,
    );

    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      var result = response.body['rajaongkir']['results'] as List<dynamic>;

      return City.fromJsonList(result);
    }
  }
}
