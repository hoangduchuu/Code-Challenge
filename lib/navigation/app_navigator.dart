import 'package:code_challenge/navigation/route_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigators {
  static void gotoPhotos({required BuildContext context}) => context.go(RoutesPaths.photo);

  static void gotoBluetooth({required BuildContext context}) => context.go(RoutesPaths.bluetooth);
}
