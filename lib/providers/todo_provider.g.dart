// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoNotifierHash() => r'19b55842bc98912e3cdcfed9edcd3765bef227ee';

/// TODOアイテムの状態を管理するプロバイダー（リアルタイム更新対応）
///
/// Copied from [TodoNotifier].
@ProviderFor(TodoNotifier)
final todoNotifierProvider =
    AutoDisposeStreamNotifierProvider<TodoNotifier, List<Item>>.internal(
      TodoNotifier.new,
      name: r'todoNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todoNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodoNotifier = AutoDisposeStreamNotifier<List<Item>>;
String _$todoNotifierWithOptimisticHash() =>
    r'74626d207510a45993f1ecdb5cb4a587db15cab5';

/// 楽観的更新が必要な場合のためのプロバイダー
///
/// Copied from [TodoNotifierWithOptimistic].
@ProviderFor(TodoNotifierWithOptimistic)
final todoNotifierWithOptimisticProvider =
    AutoDisposeAsyncNotifierProvider<
      TodoNotifierWithOptimistic,
      List<Item>
    >.internal(
      TodoNotifierWithOptimistic.new,
      name: r'todoNotifierWithOptimisticProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todoNotifierWithOptimisticHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodoNotifierWithOptimistic = AutoDisposeAsyncNotifier<List<Item>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
