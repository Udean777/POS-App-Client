import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/core/presentation/widgets/app_text_field.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/features/profile/presentation/providers/profile_provider.dart';
import 'package:client/features/store/presentation/providers/store_config_provider.dart';
import 'package:client/features/products/presentation/providers/product_actions_notifier.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class StoreConfigScreen extends ConsumerStatefulWidget {
  const StoreConfigScreen({super.key});

  @override
  ConsumerState<StoreConfigScreen> createState() => _StoreConfigScreenState();
}

class _StoreConfigScreenState extends ConsumerState<StoreConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  String _selectedType = 'RETAIL';
  String? _uploadedLogoUrl;
  XFile? _localImageFile;
  bool _isUploading = false;

  final List<String> _businessTypes = ['RETAIL', 'F&B', 'JASA', 'LAINNYA'];

  @override
  void initState() {
    super.initState();
    final user = ref.read(profileProvider).value;
    _nameController = TextEditingController(text: user?.businessName ?? '');
    _addressController = TextEditingController(
      text: user?.businessAddress ?? '',
    );
    _phoneController = TextEditingController(text: user?.businessPhone ?? '');
    _selectedType = user?.businessType != '' && user?.businessType != null
        ? user!.businessType
        : 'RETAIL';
    _uploadedLogoUrl = user?.businessLogoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 500,
    );

    if (image != null) {
      setState(() {
        _localImageFile = image;
        _isUploading = true;
      });

      final url = await ref
          .read(productActionsProvider.notifier)
          .uploadImage(image.path);

      if (mounted) {
        setState(() {
          if (url != null) _uploadedLogoUrl = url;
          _isUploading = false;
        });
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(storeConfigProvider.notifier)
        .updateBusiness(
          name: _nameController.text,
          type: _selectedType,
          address: _addressController.text,
          phone: _phoneController.text,
          logoUrl: _uploadedLogoUrl,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeConfigProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<AsyncValue<void>>(storeConfigProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          if (prev?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Konfigurasi toko berhasil diperbarui"),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Konfigurasi Toko",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Logo Picker Section
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryOpaque,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildLogoPreview(),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _isUploading ? null : _pickLogo,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.card, width: 3),
                        ),
                        child: Icon(
                          _isUploading ? Icons.hourglass_empty : Icons.edit,
                          color: AppColors.card,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Form Sections
            _buildSection(
              title: "Identitas Toko",
              icon: Icons.storefront_outlined,
              colorScheme: colorScheme,
              children: [
                AppTextField(
                  controller: _nameController,
                  labelText: "Nama Toko",
                  prefixIcon: const Icon(Icons.business_outlined),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Nama toko wajib diisi" : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  decoration: const InputDecoration(
                    labelText: "Tipe Bisnis",
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: _businessTypes
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedType = v);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSection(
              title: "Kontak & Alamat",
              icon: Icons.location_on_outlined,
              colorScheme: colorScheme,
              children: [
                AppTextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  labelText: "Nomor Telepon",
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _addressController,
                  maxLines: 3,
                  labelText: "Alamat Toko",
                  prefixIcon: const Icon(Icons.map_outlined),
                ),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.card,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: SafeArea(
          child: AppButton(
            onPressed: _submit,
            isLoading: state.isLoading || _isUploading,
            text: "Simpan Konfigurasi",
          ),
        ),
      ),
    );
  }

  Widget _buildLogoPreview() {
    if (_isUploading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_localImageFile != null) {
      return Image.file(File(_localImageFile!.path), fit: BoxFit.cover);
    }

    if (_uploadedLogoUrl != null && _uploadedLogoUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: _uploadedLogoUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }

    return Icon(Icons.store_outlined, size: 48, color: AppColors.primaryOpaque);
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required ColorScheme colorScheme,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
