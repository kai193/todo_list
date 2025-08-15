// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseServiceHash() => r'69f9529d080a41ddc3966226d3baac49a226f645';

/// FirebaseServiceのプロバイダー
///
/// Copied from [firebaseService].
@ProviderFor(firebaseService)
final firebaseServiceProvider = AutoDisposeProvider<FirebaseService>.internal(
  firebaseService,
  name: r'firebaseServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseServiceRef = AutoDisposeProviderRef<FirebaseService>;
String _$todoItemsStreamHash() => r'fdfc8f7db407e2a4533642be6f1275af407b7eab';

/// リアルタイムでTODOアイテムを監視するプロバイダー
///
/// Copied from [todoItemsStream].
@ProviderFor(todoItemsStream)
final todoItemsStreamProvider = AutoDisposeStreamProvider<List<Item>>.internal(
  todoItemsStream,
  name: r'todoItemsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoItemsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodoItemsStreamRef = AutoDisposeStreamProviderRef<List<Item>>;
String _$latestItemsHash() => r'a2b706ae6245c3ad89f85c6d7bcd873eb6158f13';

/// 最新10件を取得するプロバイダー（一回限り）
///
/// Copied from [latestItems].
@ProviderFor(latestItems)
final latestItemsProvider = AutoDisposeFutureProvider<List<Item>>.internal(
  latestItems,
  name: r'latestItemsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$latestItemsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LatestItemsRef = AutoDisposeFutureProviderRef<List<Item>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
