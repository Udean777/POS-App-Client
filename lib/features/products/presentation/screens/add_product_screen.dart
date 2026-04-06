import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/add_product_notifier.dart';
import 'package:client/features/products/presentation/widgets/product_form_section.dart';
import 'package:client/features/products/presentation/widgets/variant_input_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descController = TextEditingController();

  bool _isMultiVariant = false;

  double _price = 0;
  int _stock = 0;
  String _sku = '';

  final List<VariantEntity> _variants = [];

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final List<VariantEntity> finalVariants;
    if (!_isMultiVariant) {
      finalVariants = [
        VariantEntity(
          id: const Uuid().v4(),
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

    final product = ProductEntity(
      id: const Uuid().v4(),
      name: _nameController.text,
      description: _descController.text,
      category: _categoryController.text,
      variants: finalVariants,
    );

    ref.read(addProductProvider.notifier).addProduct(product);
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
    ref.listen<AsyncValue<void>>(addProductProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          if (prev?.isLoading == true) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Produk berhasil ditambahkan")),
            );
          }
        },
        error: (err, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err.toString()), backgroundColor: Colors.red),
        ),
      );
    });

    final state = ref.watch(addProductProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Tambah Produk Baru"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            // Section 1: Basic Info
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

            // Section 2: Pricing & Variants
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
                    subtitle: const Text(
                      "Aktifkan jika produk punya ukuran/rasa berbeda",
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 20),
                  if (!_isMultiVariant) ...[
                    // Simple Mode
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
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
                      decoration: const InputDecoration(
                        labelText: 'SKU (Opsional)',
                        hintText: 'Kode unik produk',
                      ),
                      onChanged: (v) => _sku = v,
                    ),
                  ] else ...[
                    // Multi Variant Mode
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
                : const Text("Simpan Produk"),
          ),
        ),
      ),
    );
  }
}
