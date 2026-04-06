import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';

@freezed
abstract class ProductEntity with _$ProductEntity {
  const factory ProductEntity({
    required String id,
    required String name,
    required String description,
    required String category,
    required List<VariantEntity> variants,
  }) = _ProductEntity;
}

@freezed
abstract class VariantEntity with _$VariantEntity {
  const factory VariantEntity({
    required String id,
    required String name,
    required double price,
    required int stock,
    required String sku,
  }) = _VariantEntity;
}
