import 'package:dio/dio.dart';
import 'package:get/get.dart';

class OngkirProvider extends GetConnect {
  Future<Map<String, dynamic>> postOngkir(Map<String, dynamic> data) async {
    var response = await Dio().post(
      'https://api.rajaongkir.com/starter/cost',
      data: data,
      options: Options(
        headers: {
          'key': 'dda1790b2f6cb1426e9e84b4ba6c92ac',
        },
      ),
    );

    if (response.statusCode == 400) {
      throw Exception(response.data['rajaongkir']['status']['description']);
    }

    var result = response.data['rajaongkir'] as Map<String, dynamic>;
    return result;
  }
}
