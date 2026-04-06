import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/add_product_notifier.dart';
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

  final List<VariantEntity> _variants = [
    VariantEntity(
      id: const Uuid().v4(),
      name: 'Default',
      price: 0,
      stock: 0,
      sku: '',
    ),
  ];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final product = ProductEntity(
        id: const Uuid().v4(),
        name: _nameController.text,
        description: _descController.text,
        category: _categoryController.text,
        variants: _variants,
      );
      ref.read(addProductProvider.notifier).addProduct(product);
    }
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
      appBar: AppBar(title: const Text("Tambah Produk Baru")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Deskripsi Produk'),
              maxLines: 3,
            ),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Kategori'),
            ),
            const SizedBox(height: 20),
            const Text(
              "Varian & Harga",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),

            ..._variants.asMap().entries.map((entry) {
              int idx = entry.key;
              return Card(
                key: ValueKey(_variants[idx].id),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _variants[idx].name,
                              decoration: const InputDecoration(
                                labelText: 'Nama Varian',
                              ),
                              onChanged: (v) => _variants[idx] =
                                  _variants[idx].copyWith(name: v),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue: _variants[idx].sku,
                              decoration:
                                  const InputDecoration(labelText: 'SKU'),
                              onChanged: (v) => _variants[idx] =
                                  _variants[idx].copyWith(sku: v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _variants[idx].price > 0
                                  ? _variants[idx].price.toString()
                                  : '',
                              decoration:
                                  const InputDecoration(labelText: 'Harga'),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => _variants[idx] = _variants[idx]
                                  .copyWith(price: double.tryParse(v) ?? 0),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              initialValue: _variants[idx].stock > 0
                                  ? _variants[idx].stock.toString()
                                  : '',
                              decoration:
                                  const InputDecoration(labelText: 'Stok'),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => _variants[idx] = _variants[idx]
                                  .copyWith(stock: int.tryParse(v) ?? 0),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                setState(() => _variants.removeAt(idx)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            TextButton.icon(
              onPressed: () => setState(
                () => _variants.add(
                  VariantEntity(
                    id: const Uuid().v4(),
                    name: '',
                    price: 0,
                    stock: 0,
                    sku: '',
                  ),
                ),
              ),
              icon: const Icon(Icons.add),
              label: const Text("Tambah Varian"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: state.isLoading ? null : _submit,
          child: state.isLoading
              ? const CircularProgressIndicator()
              : const Text("Simpan Produk"),
        ),
      ),
    );
  }
}
