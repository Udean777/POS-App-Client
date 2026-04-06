// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'staff_id') String get staffId;@JsonKey(name: 'total_amount') double get totalAmount;@JsonKey(name: 'amount_paid') double get amountPaid;@JsonKey(name: 'change') double get change;@JsonKey(name: 'payment_method') String get paymentMethod; String get status;@JsonKey(name: 'created_at') DateTime get createdAt; Map<String, dynamic>? get staff; List<TransactionItemModel> get items;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.staffId, staffId) || other.staffId == staffId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.change, change) || other.change == change)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.staff, staff)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessId,staffId,totalAmount,amountPaid,change,paymentMethod,status,createdAt,const DeepCollectionEquality().hash(staff),const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'TransactionModel(id: $id, businessId: $businessId, staffId: $staffId, totalAmount: $totalAmount, amountPaid: $amountPaid, change: $change, paymentMethod: $paymentMethod, status: $status, createdAt: $createdAt, staff: $staff, items: $items)';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'staff_id') String staffId,@JsonKey(name: 'total_amount') double totalAmount,@JsonKey(name: 'amount_paid') double amountPaid,@JsonKey(name: 'change') double change,@JsonKey(name: 'payment_method') String paymentMethod, String status,@JsonKey(name: 'created_at') DateTime createdAt, Map<String, dynamic>? staff, List<TransactionItemModel> items
});




}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? staffId = null,Object? totalAmount = null,Object? amountPaid = null,Object? change = null,Object? paymentMethod = null,Object? status = null,Object? createdAt = null,Object? staff = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,staffId: null == staffId ? _self.staffId : staffId // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double,change: null == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,staff: freezed == staff ? _self.staff : staff // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItemModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionModel].
extension TransactionModelPatterns on TransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'staff_id')  String staffId, @JsonKey(name: 'total_amount')  double totalAmount, @JsonKey(name: 'amount_paid')  double amountPaid, @JsonKey(name: 'change')  double change, @JsonKey(name: 'payment_method')  String paymentMethod,  String status, @JsonKey(name: 'created_at')  DateTime createdAt,  Map<String, dynamic>? staff,  List<TransactionItemModel> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.businessId,_that.staffId,_that.totalAmount,_that.amountPaid,_that.change,_that.paymentMethod,_that.status,_that.createdAt,_that.staff,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'staff_id')  String staffId, @JsonKey(name: 'total_amount')  double totalAmount, @JsonKey(name: 'amount_paid')  double amountPaid, @JsonKey(name: 'change')  double change, @JsonKey(name: 'payment_method')  String paymentMethod,  String status, @JsonKey(name: 'created_at')  DateTime createdAt,  Map<String, dynamic>? staff,  List<TransactionItemModel> items)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.id,_that.businessId,_that.staffId,_that.totalAmount,_that.amountPaid,_that.change,_that.paymentMethod,_that.status,_that.createdAt,_that.staff,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'staff_id')  String staffId, @JsonKey(name: 'total_amount')  double totalAmount, @JsonKey(name: 'amount_paid')  double amountPaid, @JsonKey(name: 'change')  double change, @JsonKey(name: 'payment_method')  String paymentMethod,  String status, @JsonKey(name: 'created_at')  DateTime createdAt,  Map<String, dynamic>? staff,  List<TransactionItemModel> items)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.businessId,_that.staffId,_that.totalAmount,_that.amountPaid,_that.change,_that.paymentMethod,_that.status,_that.createdAt,_that.staff,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionModel implements TransactionModel {
  const _TransactionModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'staff_id') required this.staffId, @JsonKey(name: 'total_amount') required this.totalAmount, @JsonKey(name: 'amount_paid') required this.amountPaid, @JsonKey(name: 'change') required this.change, @JsonKey(name: 'payment_method') required this.paymentMethod, required this.status, @JsonKey(name: 'created_at') required this.createdAt, final  Map<String, dynamic>? staff, final  List<TransactionItemModel> items = const []}): _staff = staff,_items = items;
  factory _TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'staff_id') final  String staffId;
@override@JsonKey(name: 'total_amount') final  double totalAmount;
@override@JsonKey(name: 'amount_paid') final  double amountPaid;
@override@JsonKey(name: 'change') final  double change;
@override@JsonKey(name: 'payment_method') final  String paymentMethod;
@override final  String status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
 final  Map<String, dynamic>? _staff;
@override Map<String, dynamic>? get staff {
  final value = _staff;
  if (value == null) return null;
  if (_staff is EqualUnmodifiableMapView) return _staff;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<TransactionItemModel> _items;
@override@JsonKey() List<TransactionItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionModelCopyWith<_TransactionModel> get copyWith => __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.staffId, staffId) || other.staffId == staffId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.change, change) || other.change == change)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._staff, _staff)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,businessId,staffId,totalAmount,amountPaid,change,paymentMethod,status,createdAt,const DeepCollectionEquality().hash(_staff),const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'TransactionModel(id: $id, businessId: $businessId, staffId: $staffId, totalAmount: $totalAmount, amountPaid: $amountPaid, change: $change, paymentMethod: $paymentMethod, status: $status, createdAt: $createdAt, staff: $staff, items: $items)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'staff_id') String staffId,@JsonKey(name: 'total_amount') double totalAmount,@JsonKey(name: 'amount_paid') double amountPaid,@JsonKey(name: 'change') double change,@JsonKey(name: 'payment_method') String paymentMethod, String status,@JsonKey(name: 'created_at') DateTime createdAt, Map<String, dynamic>? staff, List<TransactionItemModel> items
});




}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? staffId = null,Object? totalAmount = null,Object? amountPaid = null,Object? change = null,Object? paymentMethod = null,Object? status = null,Object? createdAt = null,Object? staff = freezed,Object? items = null,}) {
  return _then(_TransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,staffId: null == staffId ? _self.staffId : staffId // ignore: cast_nullable_to_non_nullable
as String,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double,change: null == change ? _self.change : change // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,staff: freezed == staff ? _self._staff : staff // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItemModel>,
  ));
}


}

// dart format on
