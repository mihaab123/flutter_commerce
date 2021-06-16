import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'common.dart';
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: white,
        child: SpinKitCubeGrid(
          color: black,
          size: 30,
        )
    );
  }
}