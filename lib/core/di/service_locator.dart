import 'package:code_challenge/core/network/app_client.dart';
import 'package:code_challenge/data/photo_remote_data_source.dart';
import 'package:code_challenge/data/repository/photo_repository_impl.dart';
import 'package:code_challenge/presentation/screen/photos/provider/photo_provider.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Register API Client
  locator.registerLazySingleton<ApiClient>(() => ApiClient());

  // Register Data Sources
  locator.registerLazySingleton<PhotoRemoteDataSource>(() => PhotoRemoteDataSourceImpl(apiClient: locator()));

  // Register Repositories
  locator.registerLazySingleton<PhotoRepositoryImpl>(() => PhotoRepositoryImpl(remoteDataSource: locator()));

  // Register Providers
  locator.registerFactory<PhotoProvider>(() => PhotoProvider(repository: locator()));
}
