import 'package:flutter/material.dart';
import 'package:saraba_mobile/repository/model/project/project_detail_response_model.dart';
import 'package:saraba_mobile/repository/services/pekerjaan_service.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/operasional_expense_item.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/operasional_item_sheet_result.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/models/pengeluaran_category.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/operasional_item_selected_card.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/pengeluaran_widget.dart';
import 'package:saraba_mobile/ui/pekerjaan/detail/views/pengeluaran/widgets/tambah_item_operasional_sheet.dart';

class OperasionalItemPickerSheet extends StatefulWidget {
  final String? projectId;
  final PengeluaranCategory category;
  final List<OperasionalExpenseItem> initialItems;

  const OperasionalItemPickerSheet({
    super.key,
    required this.initialItems,
    required this.category,
    this.projectId,
  });

  @override
  State<OperasionalItemPickerSheet> createState() =>
      _OperasionalItemPickerSheetState();
}

class _OperasionalItemPickerSheetState
    extends State<OperasionalItemPickerSheet> {
  final _searchController = TextEditingController();
  final _service = PekerjaanService();
  List<OperasionalExpenseItem> _items = const [];
  bool _isLoadingItems = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    _loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    if (widget.category == PengeluaranCategory.pettyCash ||
        widget.projectId == null ||
        widget.projectId!.isEmpty) {
      setState(() {
        _items = List<OperasionalExpenseItem>.from(widget.initialItems);
        _isLoadingItems = false;
      });
      return;
    }

    final response = await _service.fetchProyekDetail(widget.projectId!);
    final rabItems = response?.data.rab.items ?? const <ProjectRabItem>[];

    if (!mounted) {
      return;
    }

    setState(() {
      _items = _mergeWithRabItems(widget.initialItems, rabItems);
      _isLoadingItems = false;
    });
  }

  List<OperasionalExpenseItem> _mergeWithRabItems(
    List<OperasionalExpenseItem> selected,
    List<ProjectRabItem> rabItems,
  ) {
    final mapped = <String, OperasionalExpenseItem>{};

    void addItem(OperasionalExpenseItem item) {
      mapped[_itemKey(item.name)] = item;
    }

    for (final item in _flattenRabItems(rabItems)) {
      addItem(
        OperasionalExpenseItem(
          id: 'rab-${item.id}',
          name: item.uraian,
          quantity: 0,
          amount: 0,
          note: '',
          attachments: const [],
        ),
      );
    }

    for (final item in selected) {
      addItem(item.copyWith(isSelected: true));
    }

    return mapped.values.toList();
  }

  List<ProjectRabItem> _flattenRabItems(List<ProjectRabItem> items) {
    final result = <ProjectRabItem>[];

    void visit(ProjectRabItem item) {
      final isOperasional = item.kategori.trim().toLowerCase() == 'operasional';
      final isLeafItem = item.tipe.trim().toLowerCase() == 'item';
      final hasName = item.uraian.trim().isNotEmpty;

      if (isOperasional && isLeafItem && hasName) {
        result.add(item);
      }

      for (final child in item.children) {
        visit(child);
      }
    }

    for (final item in items) {
      visit(item);
    }

    return result;
  }

  String _itemKey(String value) {
    return value.trim().toLowerCase();
  }

  List<OperasionalExpenseItem> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return _items;
    }

    return _items
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  Future<void> _openAddNewItemSheet() async {
    final result = await showModalBottomSheet<OperasionalItemSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => TambahItemOperasionalSheet(
        category: widget.category,
        defaultName: '',
      ),
    );

    if (result?.item == null) {
      return;
    }

    setState(() {
      _items = [..._items, result!.item!.copyWith(isSelected: true)];
    });
  }

  void _toggleItem(OperasionalExpenseItem item, bool value) {
    setState(() {
      _items = _items
          .map(
            (current) => current.id == item.id
                ? current.copyWith(
                    isSelected: value,
                    quantity: value ? current.quantity.clamp(1, 9999) : 0,
                    amount: value ? current.amount : 0,
                  )
                : current,
          )
          .toList();
    });
  }

  void _updateQuantity(OperasionalExpenseItem item, String rawValue) {
    final quantity = int.tryParse(rawValue) ?? 0;
    setState(() {
      _items = _items
          .map(
            (current) => current.id == item.id
                ? current.copyWith(quantity: quantity)
                : current,
          )
          .toList();
    });
  }

  void _updateAmount(OperasionalExpenseItem item, String rawValue) {
    final amount = parseCurrencyInput(rawValue);
    setState(() {
      _items = _items
          .map(
            (current) => current.id == item.id
                ? current.copyWith(amount: amount)
                : current,
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = _items.where((item) => item.isSelected).toList();
    final emptyText = widget.category == PengeluaranCategory.pettyCash
        ? 'Belum ada item petty cash'
        : 'Belum ada item operasional';

    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Pilih Item',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SearchTextField(
                controller: _searchController,
                hintText: 'Cari Item',
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _isLoadingItems
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFF7944D),
                        ),
                      )
                    : _filteredItems.isEmpty
                    ? Center(
                        child: Text(
                          emptyText,
                          style: const TextStyle(color: Color(0xFF6B7280)),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _filteredItems.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return OperasionalItemSelectionCard(
                            key: ValueKey(item.id),
                            item: item,
                            onChanged: (value) => _toggleItem(item, value),
                            onQuantityChanged: (value) =>
                                _updateQuantity(item, value),
                            onAmountChanged: (value) =>
                                _updateAmount(item, value),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _openAddNewItemSheet,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF7944D)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(Icons.add, color: Color(0xFFF7944D)),
                      label: const Text(
                        'Tambah Baru',
                        style: TextStyle(color: Color(0xFFF7944D)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedItems.isEmpty
                          ? null
                          : () => Navigator.pop(context, selectedItems),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7944D),
                        disabledBackgroundColor: const Color(0xFFFAD1B7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
