import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'AR',
      home: EarthAR(),
    );
  }
}

class EarthAR extends StatefulWidget {
  const EarthAR({Key? key}) : super(key: key);

  @override
  State<EarthAR> createState() => _EarthARState();
}

class _EarthARState extends State<EarthAR> {
  ArCoreController? arCoreController;

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  void onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;

    arCoreController!.onNodeTap = (name) => _onNodeTapped(name);
    arCoreController!.onPlaneTap = _onPlaneTapped;
  }

  void _onNodeTapped(String name) {}

  void _onPlaneTapped(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    final earthNode = ArCoreReferenceNode(
      name: "Earth",
      objectUrl: "https://laurusedelbacher.com/rainbow/model/kohle.glb",
      position: hit.pose.translation + vector.Vector3(0, 0, -1),
      scale: vector.Vector3.all(0.5),
    );

    arCoreController!.addArCoreNodeWithAnchor(earthNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArCoreView(
        onArCoreViewCreated: onArCoreViewCreated,
        enableTapRecognizer: true,
      ),
    );
  }
}
