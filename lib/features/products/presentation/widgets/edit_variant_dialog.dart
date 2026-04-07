import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/core/presentation/widgets/app_text_field.dart';
import 'package:client/core/presentation/widgets/app_dialog.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EditVariantDialog extends StatefulWidget {
  final VariantEntity variant;
  final ValueChanged<VariantEntity> onSave;

  const EditVariantDialog({
    super.key,
    required this.variant,
    required this.onSave,
  });

  @override
  State<EditVariantDialog> createState() => _EditVariantDialogState();
}

class _EditVariantDialogState extends State<EditVariantDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _skuCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.variant.name);
    _priceCtrl = TextEditingController(
      text: widget.variant.price.toInt().toString(),
    );
    _stockCtrl = TextEditingController(text: widget.variant.stock.toString());
    _skuCtrl = TextEditingController(text: widget.variant.sku);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _skuCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.edit_note, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                "Edit Detail Varian",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDialogField(
            controller: _nameCtrl,
            label: "Nama Varian",
            hint: "Misal: Large, Merah",
            icon: Icons.label_outline,
          ),
          const SizedBox(height: 16),
          _buildDialogField(
            controller: _skuCtrl,
            label: "SKU",
            hint: "Kode unik barang",
            icon: Icons.qr_code_scanner,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDialogField(
                  controller: _priceCtrl,
                  label: "Harga (Rp)",
                  hint: "0",
                  icon: Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDialogField(
                  controller: _stockCtrl,
                  label: "Stok",
                  hint: "0",
                  icon: Icons.inventory_2_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppTextButton(
                onPressed: () => Navigator.pop(context),
                text: "Batal",
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              AppButton(
                isFullWidth: false,
                onPressed: () {
                  final newVariant = widget.variant.copyWith(
                    name: _nameCtrl.text,
                    sku: _skuCtrl.text,
                    price:
                        double.tryParse(_priceCtrl.text) ??
                        widget.variant.price,
                    stock:
                        int.tryParse(_stockCtrl.text) ?? widget.variant.stock,
                  );
                  Navigator.pop(context);
                  widget.onSave(newVariant);
                },
                text: "Simpan",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return AppTextField(
      controller: controller,
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
      keyboardType: keyboardType,
    );
  }
}
