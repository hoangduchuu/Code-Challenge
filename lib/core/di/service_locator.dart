import 'package:code_challenge/core/network/app_client.dart';
import 'package:code_challenge/data/photo_remote_data_source.dart';
import 'package:code_challenge/data/repository/bluetooth_repository_impl.dart';
import 'package:code_challenge/data/repository/photo_repository_impl.dart';
import 'package:code_challenge/domain/bluetooth_repository.dart';
import 'package:code_challenge/presentation/screen/bluethooth/provider/bluetooth_provider.dart';
import 'package:code_challenge/presentation/screen/photos/provider/photo_provider.dart';
import 'package:code_challenge/service/bluetooth/bluetooth_interface.dart';
import 'package:code_challenge/service/bluetooth/flutter_reactive_ble/bluethooth_reactive_ble_impl.dart';
// ignore: depend_on_referenced_packages
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Register API Client
  locator.registerLazySingleton<ApiClient>(() => ApiClient());

  // Register Data Sources
  locator.registerLazySingleton<PhotoRemoteDataSource>(() => PhotoRemoteDataSourceImpl(apiClient: locator()));

  // Register Bluetooth Interface
  locator.registerLazySingleton<IBluetoothInterface>(() => BluetoothReactiveBleImpl());
  // locator.registerLazySingleton<IBluetoothInterface>(() => BluetoothBluePlusImpl());

  // Register Repositories
  locator.registerLazySingleton<PhotoRepositoryImpl>(() => PhotoRepositoryImpl(remoteDataSource: locator()));
  locator.registerLazySingleton<BluetoothRepository>(() => BluetoothRepositoryImpl(locator()));

  // Register Providers
  locator.registerFactory<PhotoProvider>(() => PhotoProvider(repository: locator()));

  locator.registerFactory<BluetoothProvider>(() => BluetoothProvider(locator()));
}
