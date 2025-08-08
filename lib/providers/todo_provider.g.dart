// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseServiceHash() => r'70342238cf61992552fcea00d551eec41cdd16b4';

/// See also [firebaseService].
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
String _$todoNotifierHash() => r'9e6ae1bad695e815072eac9f44190a112d78ae6d';

/// See also [TodoNotifier].
@ProviderFor(TodoNotifier)
final todoNotifierProvider =
    AutoDisposeAsyncNotifierProvider<TodoNotifier, List<Item>>.internal(
      TodoNotifier.new,
      name: r'todoNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todoNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodoNotifier = AutoDisposeAsyncNotifier<List<Item>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
