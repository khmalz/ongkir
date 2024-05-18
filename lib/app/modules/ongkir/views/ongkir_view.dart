import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:ongkos_kirim/app/data/models/ongkir_model.dart';

import '../controllers/ongkir_controller.dart';

class OngkirView extends GetView<OngkirController> {
  const OngkirView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cek Ongkir'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: controller.postOngkir(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  color: Colors.white,
                  child: Text(
                    controller.getErrorMessage(snapshot.error.toString()),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }

          if (snapshot.data == null) {
            return const Text('No Data');
          }

          return Column(
            children: [
              Card(
                color: Colors.white,
                elevation: 6,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.cityAsal.value!['type']!,
                              style: const TextStyle(fontSize: 14)),
                          Text(
                            controller.cityAsal.value!['city']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        'assets/svg/arrow_right.svg',
                        height: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.cityTujuan.value!['type']!,
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            controller.cityTujuan.value!['city']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'Berat: ${controller.weight} gram',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Ongkir ongkir = snapshot.data![index];
                    return Column(
                      children: [
                        Card(
                          color: Colors.white,
                          elevation: 6,
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.courier.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                Text(
                                  'Rp. ${ongkir.cost![0].value}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${ongkir.description}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  '${ongkir.cost![0].etd} ${controller.courier == 'pos' ? '' : 'Hari'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
