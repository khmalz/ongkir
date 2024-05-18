import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ongkos_kirim/app/data/models/city_model.dart';
import 'package:ongkos_kirim/app/data/models/province_model.dart';
import 'package:ongkos_kirim/app/data/providers/city_provider.dart';
import 'package:ongkos_kirim/app/data/providers/province_provider.dart';
import 'package:ongkos_kirim/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final box = GetStorage();
  var provincesCache = <Province>[].obs;
  var citiesCache = <City>[].obs;

  ProvinceProvider provinceProvider = ProvinceProvider();
  CityProvider cityProvider = CityProvider();

  final TextEditingController weightInput = TextEditingController();
  final apiKey = 'dda1790b2f6cb1426e9e84b4ba6c92ac';
  final cacheDuration = const Duration(minutes: 30);

  Rx<int> provAsalId = 0.obs;
  Rx<int> provTujuanId = 0.obs;
  Rx<int> cityAsalId = 0.obs;
  Rx<int> cityTujuanId = 0.obs;
  Rx<String> kurir = ''.obs;

  Rxn<String> errorProvAsal = Rxn<String>(null);
  Rxn<String> errorProvTujuan = Rxn<String>(null);
  Rxn<String> errorCityAsal = Rxn<String>(null);
  Rxn<String> errorCityTujuan = Rxn<String>(null);
  Rxn<String> errorWeight = Rxn<String>(null);
  Rxn<String> errorKurir = Rxn<String>(null);

  Future<List<Province>> getProvinces(String filter) async {
    const cacheKey = 'provinces';
    const cacheExpiryKey = 'provinces_expiry';
    final now = DateTime.now();

    final cachedData = _getCachedData(
        cacheKey, cacheExpiryKey, (data) => Province.fromJsonList(data));
    if (cachedData != null) {
      provincesCache.assignAll(cachedData);
      return cachedData;
    }

    try {
      var models = await ProvinceProvider().getProvinces();
      if (models.isNotEmpty) {
        final expiryTime = now.add(cacheDuration);

        box.write(cacheKey, json.encode(models));
        box.write(cacheExpiryKey, expiryTime.toIso8601String());

        provincesCache.addAll(models);
        return models;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<City>> getCities(Map<String, String> query) async {
    final cacheKey = 'cities_${query['province']}';
    final cacheExpiryKey = 'cities_expiry_${query['province']}';
    final now = DateTime.now();

    final cachedData = _getCachedData(
        cacheKey, cacheExpiryKey, (data) => City.fromJsonList(data));
    if (cachedData != null) {
      citiesCache.value = cachedData;
      return citiesCache;
    }

    try {
      var models = await cityProvider.getCities(query);
      if (models.isNotEmpty) {
        final expiryTime = now.add(cacheDuration);

        box.write(cacheKey, json.encode(models));
        box.write(cacheExpiryKey, expiryTime.toIso8601String());

        citiesCache.addAll(models);
        return models;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  List<T>? _getCachedData<T>(String cacheKey, String cacheExpiryKey,
      List<T> Function(dynamic) fromJson) {
    final now = DateTime.now();

    if (box.hasData(cacheKey) && box.hasData(cacheExpiryKey)) {
      final expiry = DateTime.parse(box.read(cacheExpiryKey));
      if (now.isBefore(expiry)) {
        final cachedData = box.read(cacheKey);
        return fromJson(json.decode(cachedData));
      }
    }

    return null;
  }

  Future<dynamic>? cekOngkir() {
    if (validateForm()) {
      final data = {
        'cityAsalId': cityAsalId.value.toString(),
        'cityTujuanId': cityTujuanId.value.toString(),
        'weight': weightInput.text,
        'kurir': kurir.value
      };

      return Get.toNamed(Routes.ONGKIR, parameters: data);
    }

    if (int.parse(weightInput.text) > 30000) {
      Get.rawSnackbar(
        message: 'Berat maksimal 30 Kg',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        borderRadius: 8,
      );
      return null;
    }

    Get.rawSnackbar(
      message: 'Pastikan semua kolom terisi',
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      borderRadius: 8,
    );
    return null;
  }

  bool validateForm() {
    errorProvAsal.value = null;
    errorProvTujuan.value = null;
    errorCityAsal.value = null;
    errorCityTujuan.value = null;
    errorWeight.value = null;
    errorKurir.value = null;

    bool isValid = true;
    isValid &= validateProvAsal();
    isValid &= validateCityAsal();
    isValid &= validateProvTujuan();
    isValid &= validateCityTujuan();
    isValid &= validateWeight();
    isValid &= validateKurir();

    return isValid;
  }

  bool validateProvAsal() {
    if (provAsalId.value == 0) {
      errorProvAsal.value = 'Provinsi asal harus dipilih';
      return false;
    }
    errorProvAsal.value = null;
    return true;
  }

  bool validateProvTujuan() {
    if (provTujuanId.value == 0) {
      errorProvTujuan.value = 'Provinsi tujuan harus dipilih';
      return false;
    }
    errorProvTujuan.value = null;
    return true;
  }

  bool validateCityAsal() {
    if (cityAsalId.value == 0) {
      errorCityAsal.value = 'Kota/Kabupaten asal harus dipilih';
      return false;
    }
    errorCityAsal.value = null;
    return true;
  }

  bool validateCityTujuan() {
    if (cityTujuanId.value == 0) {
      errorCityTujuan.value = 'Kota/Kabupaten tujuan harus dipilih';
      return false;
    }
    errorCityTujuan.value = null;
    return true;
  }

  bool validateWeight() {
    if (weightInput.text.isEmpty) {
      errorWeight.value = 'Berat harus diisi';
      return false;
    }

    if (int.parse(weightInput.text) > 30000) {
      errorWeight.value = 'Berat tidak boleh lebih dari 30.000 gram atau 30 Kg';
      return false;
    }

    errorWeight.value = null;
    return true;
  }

  bool validateKurir() {
    if (kurir.value.isEmpty) {
      errorKurir.value = 'Kurir harus dipilih';
      return false;
    }
    errorKurir.value = null;
    return true;
  }
}

// Future<List<Province>> getProvinces(String filter) async {
  //   const cacheKey = 'provinces';
  //   const cacheExpiryKey = 'provinces_expiry';

  //   final now = DateTime.now();

  //   test();

  //   final cachedData = _getCachedData(
  //       cacheKey, cacheExpiryKey, (data) => Province.fromJsonList(data));
  //   if (cachedData != null) {
  //     provincesCache.value = cachedData;
  //     return provincesCache;
  //   }

  //   var response = await Dio().get(
  //     "https://api.rajaongkir.com/starter/province",
  //     options: Options(headers: {'key': apiKey}),
  //   );
  //   var models = Province.fromJsonList(response.data['rajaongkir']['results']);

  //   final expiryTime = now.add(cacheDuration);

  //   box.write(cacheKey, json.encode(models));
  //   box.write(cacheExpiryKey, expiryTime.toIso8601String());
  //   provincesCache.value = models;

  //   return models;
  // }

  // Future<List<City>> getCities(Map<String, dynamic> query) async {
  //   final cacheKey = 'cities_${query['province']}';
  //   final cacheExpiryKey = 'cities_expiry_${query['province']}';

  //   final now = DateTime.now();

  //   final cachedData = _getCachedData(
  //       cacheKey, cacheExpiryKey, (data) => City.fromJsonList(data));
  //   if (cachedData != null) {
  //     citiesCache.value = cachedData;
  //     return citiesCache;
  //   }

  //   var response = await Dio().get(
  //     "https://api.rajaongkir.com/starter/city",
  //     queryParameters: query,
  //     options: Options(headers: {
  //       'key': apiKey,
  //     }),
  //   );
  //   var models = City.fromJsonList(response.data['rajaongkir']['results']);

  //   final expiryTime = now.add(cacheDuration);

  //   box.write(cacheKey, json.encode(models));
  //   box.write(cacheExpiryKey, expiryTime.toIso8601String());
  //   citiesCache.value = models;

  //   return models;
  // }
