import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/pengeluaran_category.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/pengeluaran_widget.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/request/models/request_item_sheet_result.dart';

class TambahItemRequestSheet extends StatefulWidget {
  final RequestItem? initialItem;
  final PengeluaranCategory? category;
  final String defaultName;

  const TambahItemRequestSheet({
    super.key,
    this.initialItem,
    this.category,
    required this.defaultName,
  });

  @override
  State<TambahItemRequestSheet> createState() => _TambahItemRequestSheetState();
}

class _TambahItemRequestSheetState extends State<TambahItemRequestSheet> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _amountController = TextEditingController();

  bool get _canSubmit {
    return _nameController.text.trim().isNotEmpty &&
        (int.tryParse(_quantityController.text.trim()) ?? 0) > 0 &&
        parseCurrencyInput(_amountController.text) > 0;
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialItem?.name ?? '';
    _quantityController.text = widget.initialItem?.quantity.toString() ?? '';
    _amountController.text = widget.initialItem == null
        ? ''
        : formatAmountInput(widget.initialItem!.unitPrice);
    _nameController.addListener(() => setState(() {}));
    _quantityController.addListener(() => setState(() {}));
    _amountController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _deleteItem() {
    Navigator.pop(context, RequestItemSheetResult.deleted());
  }

  void _saveItem() {
    final qty = int.tryParse(_quantityController.text.trim()) ?? 0;
    final price = parseCurrencyInput(_amountController.text);

    final item = RequestItem(
      id:
          widget.initialItem?.id ??
          'request-${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      quantity: qty,
      unitPrice: price,
    );

    Navigator.pop(context, RequestItemSheetResult.saved(item));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          18,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: widget.initialItem == null
                      ? const Icon(Icons.close, size: 18)
                      : const Icon(Icons.arrow_back_ios_new, size: 18),
                ),
                Expanded(
                  child: Text(
                    widget.initialItem == null ? 'Tambah Item' : 'Edit',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const FieldLabel('Nama Item'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Ketik Disini',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF5D93E8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel('Kuantitas'),
                      const SizedBox(height: 8),
                      CompactTextField(
                        controller: _quantityController,
                        hintText: '0',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel('Harga Satuan'),
                      const SizedBox(height: 8),
                      CompactTextField(
                        controller: _amountController,
                        hintText: 'Rp',
                        prefixText: 'Rp ',
                        keyboardType: TextInputType.number,
                        inputFormatters: const [ThousandsSeparatorFormatter()],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (widget.initialItem != null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _deleteItem,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF111827)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canSubmit ? _saveItem : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7944D),
                        disabledBackgroundColor: const Color(0xFFFAD1B7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        minimumSize: const Size.fromHeight(50),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSubmit ? _saveItem : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7944D),
                    disabledBackgroundColor: const Color(0xFFFAD1B7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
