// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_item_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionItemEntity {

 String get id; int get quantity; String get productName; String get variantName; double get price; double get subtotal;
/// Create a copy of TransactionItemEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionItemEntityCopyWith<TransactionItemEntity> get copyWith => _$TransactionItemEntityCopyWithImpl<TransactionItemEntity>(this as TransactionItemEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variantName, variantName) || other.variantName == variantName)&&(identical(other.price, price) || other.price == price)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}


@override
int get hashCode => Object.hash(runtimeType,id,quantity,productName,variantName,price,subtotal);

@override
String toString() {
  return 'TransactionItemEntity(id: $id, quantity: $quantity, productName: $productName, variantName: $variantName, price: $price, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class $TransactionItemEntityCopyWith<$Res>  {
  factory $TransactionItemEntityCopyWith(TransactionItemEntity value, $Res Function(TransactionItemEntity) _then) = _$TransactionItemEntityCopyWithImpl;
@useResult
$Res call({
 String id, int quantity, String productName, String variantName, double price, double subtotal
});




}
/// @nodoc
class _$TransactionItemEntityCopyWithImpl<$Res>
    implements $TransactionItemEntityCopyWith<$Res> {
  _$TransactionItemEntityCopyWithImpl(this._self, this._then);

  final TransactionItemEntity _self;
  final $Res Function(TransactionItemEntity) _then;

/// Create a copy of TransactionItemEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? quantity = null,Object? productName = null,Object? variantName = null,Object? price = null,Object? subtotal = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variantName: null == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionItemEntity].
extension TransactionItemEntityPatterns on TransactionItemEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionItemEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionItemEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionItemEntity value)  $default,){
final _that = this;
switch (_that) {
case _TransactionItemEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionItemEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionItemEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int quantity,  String productName,  String variantName,  double price,  double subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionItemEntity() when $default != null:
return $default(_that.id,_that.quantity,_that.productName,_that.variantName,_that.price,_that.subtotal);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int quantity,  String productName,  String variantName,  double price,  double subtotal)  $default,) {final _that = this;
switch (_that) {
case _TransactionItemEntity():
return $default(_that.id,_that.quantity,_that.productName,_that.variantName,_that.price,_that.subtotal);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int quantity,  String productName,  String variantName,  double price,  double subtotal)?  $default,) {final _that = this;
switch (_that) {
case _TransactionItemEntity() when $default != null:
return $default(_that.id,_that.quantity,_that.productName,_that.variantName,_that.price,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionItemEntity implements TransactionItemEntity {
  const _TransactionItemEntity({required this.id, required this.quantity, required this.productName, required this.variantName, required this.price, required this.subtotal});
  

@override final  String id;
@override final  int quantity;
@override final  String productName;
@override final  String variantName;
@override final  double price;
@override final  double subtotal;

/// Create a copy of TransactionItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionItemEntityCopyWith<_TransactionItemEntity> get copyWith => __$TransactionItemEntityCopyWithImpl<_TransactionItemEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionItemEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.variantName, variantName) || other.variantName == variantName)&&(identical(other.price, price) || other.price == price)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}


@override
int get hashCode => Object.hash(runtimeType,id,quantity,productName,variantName,price,subtotal);

@override
String toString() {
  return 'TransactionItemEntity(id: $id, quantity: $quantity, productName: $productName, variantName: $variantName, price: $price, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$TransactionItemEntityCopyWith<$Res> implements $TransactionItemEntityCopyWith<$Res> {
  factory _$TransactionItemEntityCopyWith(_TransactionItemEntity value, $Res Function(_TransactionItemEntity) _then) = __$TransactionItemEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, int quantity, String productName, String variantName, double price, double subtotal
});




}
/// @nodoc
class __$TransactionItemEntityCopyWithImpl<$Res>
    implements _$TransactionItemEntityCopyWith<$Res> {
  __$TransactionItemEntityCopyWithImpl(this._self, this._then);

  final _TransactionItemEntity _self;
  final $Res Function(_TransactionItemEntity) _then;

/// Create a copy of TransactionItemEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? quantity = null,Object? productName = null,Object? variantName = null,Object? price = null,Object? subtotal = null,}) {
  return _then(_TransactionItemEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,variantName: null == variantName ? _self.variantName : variantName // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
