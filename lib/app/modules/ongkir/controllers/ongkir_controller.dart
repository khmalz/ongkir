import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:ongkos_kirim/app/data/models/ongkir_model.dart';
import 'package:ongkos_kirim/app/data/providers/ongkir_provider.dart';

class OngkirController extends GetxController {
  String origin = Get.parameters['cityAsalId'].toString();
  String destination = Get.parameters['cityTujuanId'].toString();
  String weight = Get.parameters['weight'].toString();
  String courier = Get.parameters['kurir'].toString();

  Rxn<Map<String, String>> cityAsal = Rxn<Map<String, String>>(null);
  Rxn<Map<String, String>> cityTujuan = Rxn<Map<String, String>>(null);

  OngkirProvider ongkirProvider = OngkirProvider();

  Future<List<Ongkir>> postOngkir() async {
    cityAsal.value = null;
    cityTujuan.value = null;

    Map<String, String> data = {
      'origin': origin.toString(),
      'destination': destination.toString(),
      'weight': weight.toString(),
      'courier': courier.toString(),
    };

    try {
      var response = await ongkirProvider.postOngkir(data);

      cityAsal.value = {
        'type': response['origin_details']['type'],
        'city': response['origin_details']['city_name'],
      };

      cityTujuan.value = {
        'type': response['destination_details']['type'],
        'city': response['destination_details']['city_name'],
      };

      List<Ongkir> models =
          Ongkir.fromJsonList(response['results'][0]['costs']);

      if (models.isNotEmpty) {
        return models;
      }

      return [];
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        final errorMessage =
            e.response!.data['rajaongkir']['status']['description'];
        throw Exception(errorMessage);
      } else {
        throw Exception('Failed to load: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to load: $e}');
    }
  }

  String getErrorMessage(String error) {
    int startIndex = error.indexOf("Bad request.");
    if (startIndex != -1) {
      return error.substring(startIndex + "Bad request.".length).trim();
    }
    return error;
  }
}
