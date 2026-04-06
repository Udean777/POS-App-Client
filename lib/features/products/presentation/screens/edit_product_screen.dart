import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/product_actions_notifier.dart';
import 'package:client/features/products/presentation/widgets/product_form_section.dart';
import 'package:client/features/products/presentation/widgets/variant_input_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final ProductEntity product;
  const EditProductScreen({super.key, required this.product});

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _nameController = TextEditingController(text: widget.product.name);
  late final _categoryController = TextEditingController(
    text: widget.product.category,
  );
  late final _descController = TextEditingController(
    text: widget.product.description,
  );

  bool _isMultiVariant = false;
  double _price = 0;
  int _stock = 0;
  String _sku = '';
  List<VariantEntity> _variants = [];

  @override
  void initState() {
    super.initState();
    _isMultiVariant =
        widget.product.variants.length > 1 ||
        (widget.product.variants.isNotEmpty &&
            widget.product.variants.first.name != 'Default');

    _variants = List.from(widget.product.variants);

    if (!_isMultiVariant && _variants.isNotEmpty) {
      _price = _variants.first.price;
      _stock = _variants.first.stock;
      _sku = _variants.first.sku;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final List<VariantEntity> finalVariants;
    if (!_isMultiVariant) {
      finalVariants = [
        VariantEntity(
          id: _variants.isNotEmpty ? _variants.first.id : const Uuid().v4(),
          name: 'Default',
          price: _price,
          stock: _stock,
          sku: _sku,
        ),
      ];
    } else {
      if (_variants.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tambahkan minimal satu varian")),
        );
        return;
      }
      finalVariants = _variants;
    }

    final updatedProduct = widget.product.copyWith(
      name: _nameController.text,
      description: _descController.text,
      category: _categoryController.text,
      variants: finalVariants,
    );

    ref.read(productActionsProvider.notifier).updateProduct(updatedProduct);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(productActionsProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          if (prev?.isLoading == true) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Produk berhasil diperbarui")),
            );
          }
        },
        error: (err, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString()), backgroundColor: Colors.red),
        ),
      );
    });

    final state = ref.watch(productActionsProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Edit Produk"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            ProductFormSection(
              title: "Informasi Dasar",
              icon: Icons.inventory_2_outlined,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Produk',
                      hintText: 'Misal: Kopi Susu Aren',
                    ),
                    validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      hintText: 'Misal: Minuman, Makanan',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      hintText: 'Penjelasan singkat tentang produk...',
                    ),
                  ),
                ],
              ),
            ),
            ProductFormSection(
              title: "Harga & Inventaris",
              icon: Icons.sell_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile.adaptive(
                    value: _isMultiVariant,
                    onChanged: (v) => setState(() => _isMultiVariant = v),
                    title: const Text(
                      "Punya banyak varian?",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text("Aktifkan untuk rasa/ukuran berbeda"),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 20),
                  if (!_isMultiVariant) ...[
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            initialValue: _price > 0 ? _price.toString() : '',
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Harga Jual',
                              prefixText: 'Rp ',
                            ),
                            onChanged: (v) => _price = double.tryParse(v) ?? 0,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: _stock > 0 ? _stock.toString() : '',
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Stok',
                            ),
                            onChanged: (v) => _stock = int.tryParse(v) ?? 0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _sku,
                      decoration: const InputDecoration(
                        labelText: 'SKU (Opsional)',
                        hintText: 'Kode unik produk',
                      ),
                      onChanged: (v) => _sku = v,
                    ),
                  ] else ...[
                    ..._variants.asMap().entries.map((entry) {
                      return VariantInputCard(
                        variant: entry.value,
                        onDelete: () =>
                            setState(() => _variants.removeAt(entry.key)),
                        onChanged: (newVariant) =>
                            setState(() => _variants[entry.key] = newVariant),
                      );
                    }),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => setState(() {
                        _variants.add(
                          VariantEntity(
                            id: const Uuid().v4(),
                            name: '',
                            price: 0,
                            stock: 0,
                            sku: '',
                          ),
                        );
                      }),
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text("Tambah Varian Baru"),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: state.isLoading ? null : _submit,
            child: state.isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text("Simpan Perubahan"),
          ),
        ),
      ),
    );
  }
}
