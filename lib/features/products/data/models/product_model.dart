import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    String? description,
    required String category,
    required List<VariantModel> variants,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

@freezed
abstract class VariantModel with _$VariantModel {
  const factory VariantModel({
    required String id,
    required String name,
    required double price,
    required int stock,
    String? sku,
  }) = _VariantModel;

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);
}

extension ProductModelX on ProductModel {
  ProductEntity toEntity() => ProductEntity(
    id: id,
    name: name,
    description: description,
    category: category,
    variants: variants.map((v) => v.toEntity()).toList(),
    createdAt: createdAt,
  );
}

extension VariantModelX on VariantModel {
  VariantEntity toEntity() =>
      VariantEntity(id: id, name: name, price: price, stock: stock, sku: sku);
}
