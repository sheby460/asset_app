import 'dart:io';

import 'package:asset_app/view/create_unit_cost.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'asset_screen.dart';

class UnitCostsPage extends StatefulWidget {
  final String costCenterId;

  const UnitCostsPage({required this.costCenterId, Key? key}) : super(key: key);

  @override
  _UnitCostsPageState createState() => _UnitCostsPageState();
}

class _UnitCostsPageState extends State<UnitCostsPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _unitCostsStream;

  @override
  void initState() {
    super.initState();
    _unitCostsStream = FirebaseFirestore.instance
        .collection('unit_costs')
        .where('cost_center_id', isEqualTo: widget.costCenterId)
        .snapshots();
  }

  Future<String?> getCostCenterName(String costCenterId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('cost_centers')
        .doc(costCenterId)
        .get();
    return snapshot.exists ? snapshot.data()!['costName'] : null;
  }

  String _buildCostCenterSubtitle(Map<String, dynamic> data) {
    final location = data['location'];
    return location != null ? 'Location: $location' : 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Costs for ${widget.costCenterId}'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _unitCostsStream,
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
                  const Text('No unit costs found.'),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateUnitCostPage(
                            costCenterId: widget.costCenterId,
                          ),
                        ),
                      );
                    },
                    child: const Text('Create Unit Cost'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot<Map<String, dynamic>> doc =
                  snapshot.data!.docs[index];
              Map<String, dynamic> data = doc.data()!;
              print(data);

              return FutureBuilder<String?>(
                future: getCostCenterName(data['cost_center_id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox.shrink();
                  }

                  final costCenterName =
                      snapshot.data ?? 'Cost center not found';

                  return Card(
                    child: GestureDetector(
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AssetScreenPage(
        costCenterId: data['cost_center_id'],
        unitCostId: doc.id,
      ),
    ),
  );
},
                      child: ListTile(
                        leading: data['imageUrl'] != null
                            ? Image.file(File(data['imageUrl']))
                            : Placeholder(),
                        title: Text(data['name'] ?? 'N/A'),
                        subtitle: Text(
                            'Cost Center: $costCenterName\n${_buildCostCenterSubtitle(data)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
// Handle edit button tap event here
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateUnitCostPage(
                costCenterId: widget.costCenterId,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
