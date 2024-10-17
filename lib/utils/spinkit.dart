import 'package:appfront/constant/color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

const spinkit = SpinKitFadingCircle(
  color: Colors.white,
  size: 50.0,
);

final fadingCircle = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? mainColor : inversColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  },
);

const threeBounce = SpinKitThreeBounce(
  color: mainColor,
  size: 50.0,
);
