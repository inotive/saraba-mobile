import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/material_expense_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/pengeluaran_widget.dart';

class MaterialItemSelectionCard extends StatefulWidget {
  final MaterialExpenseItem item;
  final ValueChanged<bool> onChanged;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String> onTotalChanged;

  const MaterialItemSelectionCard({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onQuantityChanged,
    required this.onTotalChanged,
  });

  @override
  State<MaterialItemSelectionCard> createState() =>
      _MaterialItemSelectionCardState();
}

class _MaterialItemSelectionCardState extends State<MaterialItemSelectionCard> {
  late final TextEditingController _quantityController;
  late final TextEditingController _totalController;
  late final FocusNode _quantityFocusNode;
  late final FocusNode _totalFocusNode;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantity == 0 ? '' : widget.item.quantity.toString(),
    );
    _totalController = TextEditingController(
      text: widget.item.total == 0 ? '' : formatAmountInput(widget.item.total),
    );
    _quantityFocusNode = FocusNode();
    _totalFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant MaterialItemSelectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextQuantity = widget.item.quantity == 0
        ? ''
        : widget.item.quantity.toString();
    final nextTotal = widget.item.total == 0
        ? ''
        : formatAmountInput(widget.item.total);

    if (!_quantityFocusNode.hasFocus &&
        _quantityController.text != nextQuantity) {
      _quantityController.text = nextQuantity;
    }

    if (!_totalFocusNode.hasFocus && _totalController.text != nextTotal) {
      _totalController.text = nextTotal;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _totalController.dispose();
    _quantityFocusNode.dispose();
    _totalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.item.isSelected ? const Color(0xFFFFF1E8) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: widget.item.isSelected
              ? const Color(0xFFF7944D)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: widget.item.isSelected,
                onChanged: (value) => widget.onChanged(value ?? false),
                activeColor: const Color(0xFFF7944D),
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Expanded(
                child: Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Kuantitas'),
                    const SizedBox(height: 6),
                    CompactTextField(
                      controller: _quantityController,
                      focusNode: _quantityFocusNode,
                      hintText: '0',
                      keyboardType: TextInputType.number,
                      enabled: widget.item.isSelected,
                      onChanged: widget.onQuantityChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldLabel('Total'),
                    const SizedBox(height: 6),
                    CompactTextField(
                      controller: _totalController,
                      focusNode: _totalFocusNode,
                      hintText: 'Rp',
                      prefixText: 'Rp ',
                      keyboardType: TextInputType.number,
                      inputFormatters: const [ThousandsSeparatorFormatter()],
                      enabled: widget.item.isSelected,
                      onChanged: widget.onTotalChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
