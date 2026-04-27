import 'package:flutter/material.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/operasional_expense_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/pengeluaran_widget.dart';

class OperasionalItemSelectionCard extends StatefulWidget {
  final OperasionalExpenseItem item;
  final ValueChanged<bool> onChanged;
  final ValueChanged<String> onQuantityChanged;
  final ValueChanged<String> onAmountChanged;

  const OperasionalItemSelectionCard({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onQuantityChanged,
    required this.onAmountChanged,
  });

  @override
  State<OperasionalItemSelectionCard> createState() =>
      _OperasionalItemSelectionCardState();
}

class _OperasionalItemSelectionCardState
    extends State<OperasionalItemSelectionCard> {
  late final TextEditingController _quantityController;
  late final TextEditingController _amountController;
  late final FocusNode _quantityFocusNode;
  late final FocusNode _amountFocusNode;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantity == 0 ? '' : widget.item.quantity.toString(),
    );
    _amountController = TextEditingController(
      text: widget.item.amount == 0
          ? ''
          : formatAmountInput(widget.item.amount),
    );
    _quantityFocusNode = FocusNode();
    _amountFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant OperasionalItemSelectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final nextQuantity = widget.item.quantity == 0
        ? ''
        : widget.item.quantity.toString();
    final nextAmount = widget.item.amount == 0
        ? ''
        : formatAmountInput(widget.item.amount);

    if (!_quantityFocusNode.hasFocus &&
        _quantityController.text != nextQuantity) {
      _quantityController.text = nextQuantity;
    }

    if (!_amountFocusNode.hasFocus && _amountController.text != nextAmount) {
      _amountController.text = nextAmount;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _amountController.dispose();
    _quantityFocusNode.dispose();
    _amountFocusNode.dispose();
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
                      controller: _amountController,
                      focusNode: _amountFocusNode,
                      hintText: 'Rp',
                      prefixText: 'Rp ',
                      keyboardType: TextInputType.number,
                      inputFormatters: const [ThousandsSeparatorFormatter()],
                      enabled: widget.item.isSelected,
                      onChanged: widget.onAmountChanged,
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
