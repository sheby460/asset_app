import 'package:asset_app/controller/data_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import 'asset_add_screen.dart';

class AssetScreenPage extends StatefulWidget {
  final String costCenterId;
  final String unitCostId;
  const AssetScreenPage({super.key, required this.costCenterId, required this.unitCostId});

  @override
  State<AssetScreenPage> createState() => _AssetScreenPageState();
}

class _AssetScreenPageState extends State<AssetScreenPage> {
 late Stream<QuerySnapshot<Map<String, dynamic>>> _assetStream;

  @override
  void initState(){
    super.initState();
    _assetStream = FirebaseFirestore.instance.collection('assets').where('cost_center_id',isEqualTo:widget.costCenterId)
    .where('unitId',isEqualTo:widget.unitCostId).snapshots();
    
  }
    Future<String?> getCostCenterName(String costCenterId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('cost_centers')
            .doc(costCenterId)
            .get();
    return snapshot.exists ? snapshot.data()!['costName'] : null;
  }
  Future<String?> getUnitCostName(String unitCostId) async{
    DocumentSnapshot<Map<String, dynamic>> snapshot = await 
    FirebaseFirestore.instance.collection('unit_costs').doc(unitCostId).get();
  }
  DataController dataController = Get.put(DataController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assets for ${widget.unitCostId}'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _assetStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No assets found.'),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAssetPage(
                            costCenterId: widget.costCenterId,
                            unitCostId: widget.unitCostId,
                          ),
                        ),
                      );
                    },
                    child: const Text('Add Asset'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cost Center: ${getCostCenterName(widget.costCenterId)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Unit Cost: ${getUnitCostName(widget.unitCostId)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final asset = snapshot.data!.docs[index].data();

                    return ListTile(
                      title: Text(asset['name']),
                      subtitle: Text('null'),
                      trailing: Text('Cost: ${asset['cost']}'),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateAssetPage(
                        costCenterId: widget.costCenterId,
                        unitCostId: widget.unitCostId,
                      ),
                    ),
                  );
                },
                child: const Text('Add Asset'),
              ),
            ],
          );
        },
      ),
    );
  }


}