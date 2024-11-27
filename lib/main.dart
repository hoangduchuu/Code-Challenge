import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/app_client.dart';
import 'features/photos/data/datasources/photo_remote_data_source.dart';
import 'features/photos/data/repositories/photo_repository_impl.dart';
import 'features/photos/presentation/pages/photos_page.dart';
import 'features/photos/presentation/providers/photo_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PhotoProvider(
            repository: PhotoRepositoryImpl(
              remoteDataSource: PhotoRemoteDataSourceImpl(
                apiClient: ApiClient(),
              ),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PhotosPage(),
    );
  }
}

