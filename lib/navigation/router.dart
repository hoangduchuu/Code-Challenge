import 'package:code_challenge/navigation/route_path.dart';
import 'package:code_challenge/presentation/screen/bluethooth/bluetooth_screen.dart';
import 'package:code_challenge/presentation/screen/home/home_screen.dart';
import 'package:code_challenge/presentation/screen/photos/photos_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: RoutesPaths.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: [
        GoRoute(
          path: RoutesPaths.photo,
          builder: (BuildContext context, GoRouterState state) {
            return const PhotoScreen();
          },
        ),
        GoRoute(
          path: RoutesPaths.bluetooth,
          builder: (BuildContext context, GoRouterState state) {
            return const BluetoothScreen();
          },
        ),
      ]
    ),

  ],
);
