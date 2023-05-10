import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AssetScreenPage extends StatefulWidget {
  const AssetScreenPage({super.key});

  @override
  State<AssetScreenPage> createState() => _AssetScreenPageState();
}

class _AssetScreenPageState extends State<AssetScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Asset List')),
    );
  }
}