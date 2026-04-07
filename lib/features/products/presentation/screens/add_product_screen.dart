import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/add_product_notifier.dart';
import 'package:client/features/products/presentation/providers/product_actions_notifier.dart';
import 'package:client/features/products/presentation/widgets/product_form_section.dart';
import 'package:client/features/products/presentation/widgets/product_image_picker.dart';
import 'package:client/features/products/presentation/widgets/variant_input_card.dart';
import 'package:client/core/presentation/widgets/app_text_field.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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

  XFile? _imageFile;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  bool _isMultiVariant = false;
  double _price = 0;
  int _stock = 0;
  String _sku = '';

  final List<VariantEntity> _variants = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );

    if (image != null) {
      setState(() => _imageFile = image);
      _uploadImage(image.path);
    }
  }

  Future<void> _uploadImage(String path) async {
    setState(() => _isUploading = true);

    final url = await ref
        .read(productActionsProvider.notifier)
        .uploadImage(path);

    if (mounted) {
      setState(() {
        _uploadedImageUrl = url;
        _isUploading = false;
      });
    }
  }

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
      imageUrl: _uploadedImageUrl,
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
    _listenToAddProductState();
    final state = ref.watch(addProductProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
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
            ProductImagePicker(
              imageFile: _imageFile,
              isUploading: _isUploading,
              onPickImage: _pickImage,
            ),
            const SizedBox(height: 32),
            _buildBasicInfoSection(),
            _buildVariantSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(state),
    );
  }

  void _listenToAddProductState() {
    ref.listen<AsyncValue<void>>(addProductProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          if (prev?.isLoading == true) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Produk berhasil ditambahkan"),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        error: (err, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.toString()),
            backgroundColor: AppColors.danger,
          ),
        ),
      );
    });
  }

  Widget _buildBasicInfoSection() {
    return ProductFormSection(
      title: "Informasi Dasar",
      icon: Icons.inventory_2_outlined,
      child: Column(
        children: [
          AppTextField(
            controller: _nameController,
            labelText: 'Nama Produk',
            hintText: 'Misal: Kopi Susu Aren',
            validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _categoryController,
            labelText: 'Kategori',
            hintText: 'Misal: Minuman, Makanan',
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _descController,
            maxLines: 3,
            labelText: 'Deskripsi',
            hintText: 'Penjelasan singkat tentang produk...',
          ),
        ],
      ),
    );
  }

  Widget _buildVariantSection() {
    return ProductFormSection(
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
          if (!_isMultiVariant)
            _buildSingleVariantInput()
          else
            ..._buildMultiVariantInput(),
        ],
      ),
    );
  }

  Widget _buildSingleVariantInput() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: AppTextField(
                keyboardType: TextInputType.number,
                labelText: 'Harga Jual',
                prefixText: 'Rp ',
                onChanged: (v) => _price = double.tryParse(v) ?? 0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AppTextField(
                keyboardType: TextInputType.number,
                labelText: 'Stok',
                onChanged: (v) => _stock = int.tryParse(v) ?? 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          labelText: 'SKU (Opsional)',
          hintText: 'Kode unik produk',
          onChanged: (v) => _sku = v,
        ),
      ],
    );
  }

  List<Widget> _buildMultiVariantInput() {
    return [
      ..._variants.asMap().entries.map((entry) {
        return VariantInputCard(
          variant: entry.value,
          onDelete: () => setState(() => _variants.removeAt(entry.key)),
          onChanged: (newVariant) =>
              setState(() => _variants[entry.key] = newVariant),
        );
      }),
      const SizedBox(height: 8),
      AppOutlineButton(
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
        text: "Tambah Varian Baru",
      ),
    ];
  }

  Widget _buildBottomNav(AsyncValue<void> state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: AppButton(
          onPressed: _submit,
          isLoading: state.isLoading,
          text: "Simpan Produk",
        ),
      ),
    );
  }
}
