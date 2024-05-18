import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ongkos_kirim/app/data/models/city_model.dart';
import 'package:ongkos_kirim/app/data/models/province_model.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Ongkir'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Card(
            elevation: 8,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    if (controller.provAsalId.value == 0) {
                      const SizedBox();
                    }

                    return DropdownSearch<Province>(
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                      ),
                      clearButtonProps: const ClearButtonProps(isVisible: true),
                      itemAsString: (Province u) => u.asString(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Provinsi Asal",
                          hintText: "Pilih Provinsi",
                          errorText: controller.errorProvAsal.value,
                        ),
                      ),
                      asyncItems: controller.getProvinces,
                      onChanged: (Province? data) {
                        if (data != null) {
                          controller.provAsalId.value =
                              int.parse(data.provinceId!);
                        } else {
                          controller.provAsalId.value = 0;
                          controller.cityAsalId.value = 0;
                        }

                        controller.validateProvAsal();
                      },
                    );
                  }),
                  Obx(() {
                    if (controller.provAsalId.value == 0) {
                      return const SizedBox();
                    }

                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        DropdownSearch<City>(
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                          ),
                          clearButtonProps:
                              const ClearButtonProps(isVisible: true),
                          itemAsString: (City u) => u.asString(),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Kota Asal",
                              hintText: "Pilih Kota/Kabupaten",
                              errorText: controller.errorCityAsal.value,
                            ),
                          ),
                          asyncItems: (String? search) => controller.getCities(
                            {
                              'province':
                                  controller.provAsalId.value.toString(),
                            },
                          ),
                          onChanged: (City? data) {
                            data != null
                                ? controller.cityAsalId.value =
                                    int.parse(data.cityId!)
                                : controller.cityAsalId.value = 0;

                            controller.validateCityAsal();
                          },
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  Obx(() => DropdownSearch<Province>(
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          disabledItemFn: (Province s) =>
                              s.provinceId ==
                              controller.provAsalId.value.toString(),
                        ),
                        clearButtonProps:
                            const ClearButtonProps(isVisible: true),
                        itemAsString: (Province u) => u.asString(),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Provinsi Tujuan",
                            hintText: "Pilih Provinsi",
                            errorText: controller.errorProvTujuan.value,
                          ),
                        ),
                        asyncItems: controller.getProvinces,
                        onChanged: (Province? data) {
                          if (data != null) {
                            controller.provTujuanId.value =
                                int.parse(data.provinceId!);
                          } else {
                            controller.provTujuanId.value = 0;
                            controller.cityTujuanId.value = 0;
                          }

                          controller.validateProvTujuan();
                        },
                      )),
                  Obx(() {
                    if (controller.provTujuanId.value == 0) {
                      return const SizedBox();
                    }

                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        DropdownSearch<City>(
                          popupProps: const PopupProps.menu(
                            showSearchBox: true,
                          ),
                          clearButtonProps:
                              const ClearButtonProps(isVisible: true),
                          itemAsString: (City u) => u.asString(),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Kota Tujuan",
                              hintText: "Pilih Kota/Kabupaten",
                              errorText: controller.errorCityTujuan.value,
                            ),
                          ),
                          asyncItems: (String? search) => controller.getCities(
                            {
                              'province':
                                  controller.provTujuanId.value.toString(),
                            },
                          ),
                          onChanged: (City? data) {
                            data != null
                                ? controller.cityTujuanId.value =
                                    int.parse(data.cityId!)
                                : controller.cityTujuanId.value = 0;

                            controller.validateCityTujuan();
                          },
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  Obx(
                    () => TextField(
                      controller: controller.weightInput,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: 'Berat (gram)',
                        errorText: controller.errorWeight.value,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => controller.validateWeight(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => DropdownSearch<Map<String, dynamic>>(
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                      ),
                      itemAsString: (item) => item['label'],
                      clearButtonProps: const ClearButtonProps(isVisible: true),
                      items: const [
                        {
                          "label": "JNE",
                          "code": "jne",
                        },
                        {
                          "label": "POS Indonesia",
                          "code": "pos",
                        },
                        {
                          "label": "TIKI",
                          "code": "tiki",
                        },
                      ],
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Kurir",
                          hintText: "Pilih Kurir",
                          errorText: controller.errorKurir.value,
                        ),
                      ),
                      onChanged: (value) {
                        value != null
                            ? controller.kurir.value = value['code']
                            : controller.kurir.value = '';

                        controller.validateKurir();
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.cekOngkir();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text('Cek Ongkir'),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
