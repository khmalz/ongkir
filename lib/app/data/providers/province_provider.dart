import 'package:get/get.dart';

import '../models/province_model.dart';

class ProvinceProvider extends GetConnect {
  Future<List<Province>> getProvinces() async {
    final response =
        await get('https://api.rajaongkir.com/starter/province', headers: {
      'key': 'dda1790b2f6cb1426e9e84b4ba6c92ac',
    });

    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      var result = response.body['rajaongkir']['results'] as List<dynamic>;

      return Province.fromJsonList(result);
    }
  }
}
